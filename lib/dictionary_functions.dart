import 'package:dart_cli_japanese_kanji_quiz/dictionary.dart';

bool isHiragana(String line) {
  if (line.isEmpty) return false;
  final codeUnit = line.codeUnitAt(0);
  return codeUnit >= 0x3040 && codeUnit <= 0x309F;
}

bool isKatakana(String line) {
  if (line.isEmpty) return false;
  final codeUnit = line.codeUnitAt(0);
  return codeUnit >= 0x30A0 && codeUnit <= 0x30FF;
}

bool isKanji(String line) {
  if (line.isEmpty) return false;
  final codeUnit = line.codeUnitAt(0);
  return (codeUnit >= 0x4E00 && codeUnit <= 0x9FFF) || (codeUnit >= 0x3400 && codeUnit <= 0x4DBF);
}

List<dynamic> searchInHiragana(Map<String, dynamic> readingsJson, String line) {
  var listedKanji = [];
  String normalizeKey(String key) => key.replaceAll('-', '').replaceAll('.', '');
  // Navigate readings (for hiragana)

  for (var entry in readingsJson.entries) {
    String normalizedKey = normalizeKey(entry.key);
    if (normalizedKey == line) {
      if (entry.value['main_kanji'].isNotEmpty) {
        listedKanji.addAll(entry.value['main_kanji']);
      }
      if (entry.value['name_kanji'].isNotEmpty) {
        listedKanji.addAll(entry.value['name_kanji']);
      }
    }
  }
  return listedKanji;
}

List<dynamic> searchInMeaning(Map<String, dynamic> kanjiInnerMap, String line) {
  var listedKanji = [];
  for (var value in kanjiInnerMap.values) {
    // Navigate kanji -> meaning keys (English Meaning)
    final meanings = value['meanings'];
    for (var meaning in meanings) {
      if (meaning == line.toLowerCase()) {
        listedKanji.add(value['kanji']);
      }
    }
  }
  return listedKanji;
}

List<Map<String, dynamic>> searchInWords(
    Map<String, dynamic> wordsJson, Map<String, dynamic> kanjiInnerMap, String line, bool isRomaji) {
  List<Map<String, dynamic>> words = [];
  List<Object> dictionary = [];
  var kanji = [];
  for (var values in wordsJson.values) {
    for (var entry in values) {
      for (var variant in entry['variants']) {
        final meaning = entry['meanings'].map((meaning) => meaning['glosses']).toList();
        final variants = entry['variants'].map((variant) => variant['pronounced']).toList();
        if (isRomaji) {
          if (meaningContainsInput(meaning, line)) {
            variant['written'].runes.forEach((c) {
              var char = new String.fromCharCode(c);
              kanji.add(char);
            });
            words.add({
              'kanji': variant['written'],
              'meanings': meaning,
              'pronounced': variants,
              'dictionary': dictionary,
            });
          }
        } else {
          if (variant['written'] == line || variants.contains(line)) {
            variant['written'].runes.forEach((c) {
              var char = new String.fromCharCode(c);
              kanji.add(char);
            });
            words.add({
              'kanji': variant['written'],
              'meanings': meaning,
              'pronounced': variants,
              'dictionary': dictionary,
            });
          }
        }
      }
    }
  }
  final listMapKanji = searchWithListedKanji(kanjiInnerMap, kanji.toSet().toList());
  dictionary.add(Dictionary.fromJson(listMapKanji));
  return words;
}

List<dynamic> searchWithListedKanji(Map<String, dynamic> kanjiInnerMap, List<dynamic> listedKanji) {
  List<dynamic> listMapKanji = [];
  for (var kanji in listedKanji) {
    var kanjiDictionary = kanjiInnerMap['$kanji'];
    listMapKanji.addAll([kanjiDictionary]);
  }
  return listMapKanji;
}

String normalizeMeaning(String meaning) {
  return meaning
      .replaceAll(RegExp(r'[()]'), '')
      .replaceAll(RegExp(r'\s+'), ' ')
      .replaceAll('-', ' ')
      .trim()
      .toLowerCase();
}

bool meaningContainsInput(List<dynamic> wordList, String input) {
  String normalizedInput = normalizeMeaning(input);
  for (var sublist in wordList) {
    for (var word in sublist) {
      if (normalizeMeaning(word) == normalizedInput) {
        return true;
      }
    }
  }
  return false;
}

// Helper function to handle conversion of a dynamic value to a list and join
String convertToListAndJoin(dynamic value) {
  if (value is List) {
    return value.join(', ').replaceAll('[', '').replaceAll(']', '');
  } else if (value is String) {
    return value;
  } else {
    return 'n/a';
  }
}

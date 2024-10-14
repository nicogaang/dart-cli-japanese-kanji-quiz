import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_cli_japanese_kanji_quiz/dictionary.dart';

class DictionaryApiException implements Exception {
  const DictionaryApiException(this.message);
  final String message;
}

class DictionaryApiClient {
  static const fileUrl = 'src/kanjiapi_full.json';

  Future<List<Object>> fetchDictionary(String line) async {
    //・・ One kanji character query
    final firstChar = line[0];
    final jsonUrl = await File(fileUrl).readAsString();
    final apiJson = jsonDecode(jsonUrl);
    var kanjiInnerMap = apiJson['kanjis'];
    var kanjiDictionary = kanjiInnerMap['$firstChar'];

    //・・ If the input is not a one character Kanji
    var listedKanji = [];
    List<dynamic> listMapKanji = [];
    if (kanjiDictionary == null) {
      // Normalize hiragana keys that contains '-' and '.'
      String normalizeKey(String key) => key.replaceAll('-', '').replaceAll('.', '');
      // Navigate readings (for hiragana)
      final readingsJson = apiJson['readings'];
      for (var entry in readingsJson.entries) {
        String normalizedKey = normalizeKey(entry.key);
        if (entry.key == line && normalizedKey == line) {
          if (entry.value['main_kanji'].isNotEmpty) {
            listedKanji.addAll(entry.value['main_kanji']);
          }
          if (entry.value['name_kanji'].isNotEmpty) {
            listedKanji.addAll(entry.value['name_kanji']);
          }
          break;
        }
      }
      // Navigate kanji -> meaning keys (for romaji)
      if (listedKanji.isEmpty) {
        for (var value in kanjiInnerMap.values) {
          final meanings = value['meanings'];
          for (var meaning in meanings) {
            if (meaning == line.toLowerCase()) {
              listedKanji.add(value['kanji']);
            }
          }
        }
      }
      for (var kanji in listedKanji) {
        kanjiDictionary = kanjiInnerMap['$kanji'];
        listMapKanji.addAll([kanjiDictionary]);
      }
    } else {
      listMapKanji.addAll([kanjiDictionary]);
    }

    return Dictionary.fromJson(listMapKanji);
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_cli_japanese_kanji_quiz/dictionary.dart';
import 'package:dart_cli_japanese_kanji_quiz/dictionary_word.dart';

class DictionaryApiException implements Exception {
  const DictionaryApiException(this.message);
  final String message;
}

class DictionaryApiClient {
  static const fileUrl = 'src/kanjiapi_full.json';

  Future<List<Object>> fetchDictionary(String line) async {
    //・・ One kanji character
    final jsonUrl = await File(fileUrl).readAsString();
    final apiJson = jsonDecode(jsonUrl);
    var kanjiInnerMap = apiJson['kanjis'];
    var kanjiDictionary = kanjiInnerMap['$line'];

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
        }
      }
      // Navigate kanji -> meaning keys (English Meaning)
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

    //・・Navigate to words (if input is a word)
    if (listMapKanji.isEmpty) {
      final wordsJson = apiJson['words'];
      List<Map<String, dynamic>> words = [];

      for (var values in wordsJson.values) {
        for (var entry in values) {
          for (var variant in entry['variants']) {
            if (variant['written'] == line) {
              var meaning = entry['meanings'].map((meaning) => meaning['glosses']).toList();
              words.add({
                'kanji': variant['written'],
                'meanings': meaning,
                'pronounced': variant['pronounced'],
              });
            }
          }
        }
      }
      return DictionaryWord.fromJsonWord(words);
    }

    //・・ One kanji character
    return Dictionary.fromJson(listMapKanji);
  }
}

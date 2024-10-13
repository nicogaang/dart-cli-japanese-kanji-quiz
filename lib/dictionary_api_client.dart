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
    final jsonUrl = await File(fileUrl).readAsString();
    final apiJson = jsonDecode(jsonUrl);
    var kanjiInnerMap = apiJson['kanjis'];
    var kanjiDictionary = kanjiInnerMap['$line'];
    var listedKanji = [];
    List<dynamic> listMapKanji = [];
    if (kanjiDictionary == null) {
      // Normalize hiragana keys that contains '-' and '.'
      String normalizeKey(String key) =>
          key.replaceAll('-', '').replaceAll('.', '');
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

      for (var kanji in listedKanji) {
        kanjiDictionary = kanjiInnerMap['$kanji'];
        listMapKanji.addAll([kanjiDictionary]);
      }
    } else {
      kanjiDictionary = kanjiInnerMap['$line'];
      listMapKanji.addAll([kanjiDictionary]);
    }
    return Dictionary.fromJson(listMapKanji);
  }
}

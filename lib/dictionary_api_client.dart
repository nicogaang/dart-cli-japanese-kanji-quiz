import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dart_cli_japanese_kanji_quiz/dictionary.dart';
import 'package:dart_cli_japanese_kanji_quiz/dictionary_word.dart';
import 'package:dart_cli_japanese_kanji_quiz/dictionary_functions.dart';

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
      listedKanji = searchInHiragana(apiJson, line);
      if (listedKanji.isEmpty) {
        listedKanji = searchInMeaning(kanjiInnerMap, line);
      }
      listMapKanji = searchWithListedKanji(kanjiInnerMap, listedKanji);
    } else {
      listMapKanji.addAll([kanjiDictionary]);
    }

    //・・Navigate to words (if input is a word)
    if (listMapKanji.isEmpty) {
      final wordsJson = apiJson['words'];
      List<Map<String, dynamic>> words = searchInWords(wordsJson, line);

      return DictionaryWord.fromJsonWord(words);
    }

    //・・ One kanji character
    return Dictionary.fromJson(listMapKanji);
  }
}

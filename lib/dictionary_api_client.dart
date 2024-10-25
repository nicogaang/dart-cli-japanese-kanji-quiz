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
    final kanjiInnerMap = apiJson['kanjis'];
    final wordsJson = apiJson['words'];
    final readingsJson = apiJson['readings'];

    var listMapKanji = [];
    var words = [];
    var listedKanji;
    var isRomaji;

    if (isKanji(line)) {
      var kanjiDictionary = kanjiInnerMap['$line'];
      if (line.length == 1) {
        listMapKanji.addAll([kanjiDictionary]);
      } else {
        isRomaji = false;
        words = searchInWords(wordsJson, kanjiInnerMap, line, isRomaji);
        return DictionaryWord.fromJsonWord(words);
      }
    } else if (isHiragana(line)) {
      listedKanji = searchInHiragana(readingsJson, line);
      listMapKanji = searchWithListedKanji(kanjiInnerMap, listedKanji);
      if (listMapKanji.isEmpty) {
        isRomaji = false;
        words = searchInWords(wordsJson, kanjiInnerMap, line, isRomaji);
        return DictionaryWord.fromJsonWord(words);
      }
    } else {
      listedKanji = searchInMeaning(kanjiInnerMap, line);
      listMapKanji = searchWithListedKanji(kanjiInnerMap, listedKanji);
      if (listMapKanji.isEmpty) {
        isRomaji = true;
        words = searchInWords(wordsJson, kanjiInnerMap, line, isRomaji);
        return DictionaryWord.fromJsonWord(words);
      }
    }
    return Dictionary.fromJson(listMapKanji);
  }
}

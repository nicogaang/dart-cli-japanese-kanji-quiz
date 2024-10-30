import 'dart:convert';
import 'dart:io';

import 'package:dart_cli_japanese_kanji_quiz/quiz.dart';

class QuizApiClient {
  static const fileUrl = 'src/kanjiapi_full.json';

  Future<MapOfSortedKanjiByJlpt> fetchKanjiByJlpt(String jlptlvl) async {
    final jsonUrl = await File(fileUrl).readAsString();
    final apiJson = jsonDecode(jsonUrl);
    final kanjiInnerMap = apiJson['kanjis'];
    List<dynamic> kanjiByJlptLvl = [];
    for (var kanji in kanjiInnerMap.values) {
      if (kanji['jlpt'].toString() == jlptlvl) {
        kanjiByJlptLvl.add(kanji);
      }
    }
    return MapOfSortedKanjiByJlpt.fromJson(kanjiByJlptLvl);
  }
}

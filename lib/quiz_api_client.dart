import 'dart:convert';
import 'dart:io';

class QuizApiClient {
  static const fileUrl = 'src/kanjiapi_full.json';

  Future<List<dynamic>> fetchKanjiByJlpt(String jlptlvl) async {
    final jsonUrl = await File(fileUrl).readAsString();
    final apiJson = jsonDecode(jsonUrl);
    final kanjiInnerMap = apiJson['kanjis'];
    var kanjiByJlptLvl = [];
    for (var kanji in kanjiInnerMap.values) {
      if (kanji['jlpt'].toString() == jlptlvl) {
        print(kanji);
      }
    }
    return kanjiByJlptLvl;
  }
}

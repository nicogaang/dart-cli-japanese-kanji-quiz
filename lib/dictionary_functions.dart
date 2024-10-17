List<dynamic> searchInHiragana(Map<String, dynamic> apiJson, String line) {
  var listedKanji = [];
  String normalizeKey(String key) => key.replaceAll('-', '').replaceAll('.', '');
  // Navigate readings (for hiragana)
  final readingsJson = apiJson['readings'];
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

List<Map<String, dynamic>> searchInWords(Map<String, dynamic> wordsJson, String line) {
  List<Map<String, dynamic>> words = [];
  for (var values in wordsJson.values) {
    for (var entry in values) {
      for (var variant in entry['variants']) {
        var meaning = entry['meanings'].map((meaning) => meaning['glosses']).toList();
        var variants = entry['variants'].map((variant) => variant['pronounced']).toList();
        if (variant['written'] == line) {
          words.add({
            'kanji': variant['written'],
            'meanings': meaning,
            'pronounced': variants,
          });
        }
      }
    }
  }
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

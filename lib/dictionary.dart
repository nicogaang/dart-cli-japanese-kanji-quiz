class Dictionary {
  Dictionary({
    required this.kanji,
    required this.kunyomi,
    required this.meaning,
    required this.onyomi,
    required this.jlptlvl,
    required this.frequency,
  });
  String kanji;
  String kunyomi;
  String meaning;
  String onyomi;
  String jlptlvl;
  int frequency;

  static List<Dictionary> fromJson(List<dynamic> json) {
    List<Dictionary> allKanji = [];

    for (var kanjiMap in json) {
      if (kanjiMap != null) {
        allKanji.add(Dictionary(
          kanji: _convertToListAndJoin(kanjiMap['kanji']),
          kunyomi: _convertToListAndJoin(kanjiMap['kun_readings']),
          meaning: _convertToListAndJoin(kanjiMap['meanings']),
          onyomi: _convertToListAndJoin(kanjiMap['on_readings']),
          jlptlvl: kanjiMap['jlpt']?.toString() ?? '',
          frequency: kanjiMap['freq_mainichi_shinbun'] ?? 0,
        ));
      }
    }
    allKanji.sort((a, b) => b.frequency.compareTo(
        a.frequency)); //To do : Research about what component of a kanji with common meaning should be sorted.
    return allKanji;
  }

// Helper function to handle conversion of a dynamic value to a list and join
  static String _convertToListAndJoin(dynamic value) {
    if (value is List) {
      return value.join(', ');
    } else if (value is String) {
      return value;
    } else {
      return 'n/a';
    }
  }

  @override
  String toString() => '''
------------------------------
  Kanji       :$kanji
  Meaning     :$meaning
  Kunyomi     :$kunyomi
  Onyomi      :$onyomi
  JLPT Level  :$jlptlvl
''';
}

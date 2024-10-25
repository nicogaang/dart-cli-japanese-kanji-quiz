import 'package:dart_cli_japanese_kanji_quiz/dictionary_api_client.dart';

class DictionaryWord {
  DictionaryWord({
    required this.kanji,
    required this.meaning,
    required this.pronounce,
    required this.dictionary,
  });
  String kanji;
  String meaning;
  String pronounce;
  String dictionary;

  static List<DictionaryWord> fromJsonWord(List<dynamic> json) {
    List<DictionaryWord> allKanji = [];

    var foundEntry = json.firstWhere((entry) {
      allKanji.add(DictionaryWord(
        kanji: _convertToListAndJoin(entry['kanji']),
        meaning: _convertToListAndJoin(entry['meanings']),
        pronounce: _convertToListAndJoin(entry['pronounced']),
        dictionary: _convertToListAndJoin(entry['dictionary']),
      ));

      return true;
    });

    if (foundEntry == null) {
      throw DictionaryApiException('No kanji found.');
    }
    return allKanji;
  }

// Helper function to handle conversion of a dynamic value to a list and join
  static String _convertToListAndJoin(dynamic value) {
    if (value is List) {
      return value.join(', ').replaceAll('[', '').replaceAll(']', '');
    } else if (value is String) {
      return value;
    } else {
      return 'n/a';
    }
  }

  @override
  String toString() => '''
------------------------------
  Word        :$kanji
  Meaning     :$meaning
  Pronounce   :$pronounce

  Kanji Meaning
  $dictionary
''';
}

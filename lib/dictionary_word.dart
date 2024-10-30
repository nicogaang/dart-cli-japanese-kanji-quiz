import 'package:dart_cli_japanese_kanji_quiz/dictionary_api_client.dart';
import 'package:dart_cli_japanese_kanji_quiz/dictionary_functions.dart';

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
        kanji: convertToListAndJoin(entry['kanji']),
        meaning: convertToListAndJoin(entry['meanings']),
        pronounce: convertToListAndJoin(entry['pronounced']),
        dictionary: convertToListAndJoin(entry['dictionary']),
      ));

      return true;
    });

    if (foundEntry == null) {
      throw DictionaryApiException('No kanji found.');
    }
    return allKanji;
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

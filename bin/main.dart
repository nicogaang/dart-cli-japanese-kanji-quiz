import 'dart:io';
import 'package:dart_cli_japanese_kanji_quiz/dictionary_api_client.dart';
import 'package:dart_cli_japanese_kanji_quiz/quiz.dart';
import 'package:dart_cli_japanese_kanji_quiz/quiz_api_client.dart';

Future<void> main() async {
  while (true) {
    stdout.write('(1) Dictionary || (2) Kanji Quiz : ');
    final choice = stdin.readLineSync().toString();
    if (choice.toLowerCase() == '1') {
      while (true) {
        stdout.write('Search for Kanji : ');
        final line = stdin.readLineSync().toString();
        final api = DictionaryApiClient();
        if (line == 'q') {
          break;
        }
        try {
          final kanjis = await api.fetchDictionary(line);
          for (var kanji in kanjis) {
            print(kanji);
          }
        } on DictionaryApiException catch (e) {
          print(e.message);
        } catch (e) {
          print(e);
        }
      }
    } else if (choice.toLowerCase() == '2') {
      stdout.write('Select JLPT level : N(4) | N(3) | N(2) | N(1) \n Choice : ');
      var listOfLvl = <String>['1', '2', '3', '4'];
      final jlptLvl = stdin.readLineSync().toString();
      if (listOfLvl.contains(jlptLvl)) {
        final api = QuizApiClient();
        final kanjiByJlpt = await api.fetchKanjiByJlpt(jlptLvl);

        String typeOfQuiz = 'kanji';
        final quiz = QuizPaper(kanjiByJlpt: kanjiByJlpt);
        final setOfQuestion = quiz.setOfQuestion(typeOfQuiz);
        startQuiz(setOfQuestion);
      }
    } else if (choice == 'q') {
      break;
    }
  }
}


// TEST MAIN FUNCTION
// Future<void> main() async {
//   final jlptLvl = '4';
//   final api = QuizApiClient();
//   final kanjiByJlpt = await api.fetchKanjiByJlpt(jlptLvl);
//   final quiz = QuizPaper(kanjiByJlpt: kanjiByJlpt);
//   final questionaire = quiz.setOfQuestion('kanji');
//   startQuiz(questionaire);
// }

import 'dart:io';
import 'dart:math';

class QuizException implements Exception {
  const QuizException(this.message);
  final String message;
}

class MapOfSortedKanjiByJlpt {
  final List<dynamic> kanjiByJlpt;
  MapOfSortedKanjiByJlpt({required this.kanjiByJlpt});

  factory MapOfSortedKanjiByJlpt.fromJson(List<dynamic> json) => MapOfSortedKanjiByJlpt(
        kanjiByJlpt: json,
      );
}

class QuizPaper {
  final MapOfSortedKanjiByJlpt kanjiByJlpt;
  QuizPaper({required this.kanjiByJlpt});
  List<dynamic> get sortedKanji => kanjiByJlpt.kanjiByJlpt;

  List<Map<String, dynamic>> setOfQuestion(String typeOfQuiz) {
    List<Map<String, dynamic>> setOfQuestion = [];
    for (var kanji in sortedKanji) {
      List<dynamic> reading = [];
      if (!kanji['kun_readings'].isEmpty) {
        reading = [convertToListAndJoin(kanji['kun_readings'])];
      }
      if (reading.isEmpty) {
        reading.addAll([convertToListAndJoin(kanji['on_readings'])]);
      }
      final choices = generateChoices(sortedKanji, reading);
      if (typeOfQuiz == 'kanji') {
        setOfQuestion.add({
          'question': kanji['kanji'],
          'answer': reading,
          'meaning': kanji['meanings'],
          'choices': choices,
        });
      }
    }
    return setOfQuestion;
  }
}

// Example method to convert list to string
String convertToListAndJoin(List<dynamic> list) => list.join(", ").replaceAll('.', '').replaceAll('-', '');

List<dynamic> generateChoices(List<dynamic> sortedKanji, List<dynamic> reading) {
  final mainAnswer = reading;
  List<dynamic> choicesWitAnswer = [];
  choicesWitAnswer.addAll(mainAnswer);
  while (choicesWitAnswer.length < 4 || choicesWitAnswer.isEmpty) {
    final randomKanji = sortedKanji[Random().nextInt(sortedKanji.length)];
    String readings;
    if (!randomKanji['kun_readings'].isEmpty) {
      readings = convertToListAndJoin(randomKanji['kun_readings']);
      if (readings.isEmpty) {
        readings = convertToListAndJoin(randomKanji['on_readings']);
      }
    } else {
      continue;
    }
    if (!choicesWitAnswer.contains(readings)) {
      choicesWitAnswer.add(readings);
    }
  }
  return choicesWitAnswer;
}

List<Map<String, dynamic>> paginateQuizzPaper(List<Map<String, dynamic>> question, int page, int itemsPerPage) {
  int startIndex = (page - 1) * itemsPerPage;
  int endIndex = startIndex + itemsPerPage;
  endIndex = endIndex > question.length ? question.length : endIndex;
  return question.sublist(startIndex, endIndex);
}

int remainingItems(List<Map<String, dynamic>> questions, int page, int itemsPerPage) =>
    questions.length - (page * itemsPerPage);

void startQuiz(List<Map<String, dynamic>> setOfQuestion) {
  int page = 1;
  int itemsPerPage = 10;
  bool continueQuiz = true;
  int answeredItems = 0;
  int score = 0;
  List<String> listOfPossibleAnswer = ['a', 'b', 'c', 'd'];
  while (continueQuiz && (page - 1) * itemsPerPage < setOfQuestion.length) {
    final questionsToDisplay = paginateQuizzPaper(setOfQuestion, page, itemsPerPage);
    questionsToDisplay.shuffle();
    int remaining = remainingItems(setOfQuestion, page, itemsPerPage);

    bool answerIsCorrect = false;

    for (var question in questionsToDisplay) {
      final correctAnswer = question['answer'];
      List<dynamic> choice = [];
      for (var choices in question['choices']) {
        choice.add(choices);
      }
      choice.shuffle();

      print('''
      Remaining : $remaining
      Answered  : $answeredItems
      Score     : $score

      What kanji is this : ${question['question']}
      A : ${choice[0]}
      B : ${choice[1]}
      C : ${choice[2]}
      D : ${choice[3]}
      ''');
      stdout.write('Your answer : ');
      final answer = stdin.readLineSync().toString().toLowerCase();
      if (answer == 'a') {
        answerIsCorrect = choice[0] == correctAnswer[0];
      } else if (answer == 'b') {
        answerIsCorrect = choice[1] == correctAnswer[0];
      } else if (answer == 'c') {
        answerIsCorrect = choice[2] == correctAnswer[0];
      } else if (answer == 'd') {
        answerIsCorrect = choice[3] == correctAnswer[0];
      } else if (!listOfPossibleAnswer.contains(answer)) {
        print('In Japan, there is no space for error. Sorry.');
      }
      if (answerIsCorrect == true) {
        print('頭がいいね！ You got it right!');
        score++;
      } else {
        print('Wrong answer!');
      }
      answeredItems++;
      bool next = (answeredItems + remaining) == setOfQuestion.length;
      if (next) {
        stdout.write('Continue? (y/n) : ');
        final line = stdin.readLineSync();
        if (line == 'y') {
          page++;
          continueQuiz = true;
        } else {
          print('Thank You! \n Your Score : $score');
          continueQuiz = false;
        }
      }
      if (answeredItems == setOfQuestion.length) {
        print('End of quiz! \n Your Score : $score');
        continueQuiz = false;
      }
    }
  }
}

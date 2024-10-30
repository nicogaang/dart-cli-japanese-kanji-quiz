// import 'dart:math';

// class MapOfSortedKanjiByJlpt {
//   final List<dynamic> kanjiByJlpt;
//   MapOfSortedKanjiByJlpt({required this.kanjiByJlpt});

//   factory MapOfSortedKanjiByJlpt.fromJson(List<dynamic> json) => MapOfSortedKanjiByJlpt(
//         kanjiByJlpt: json,
//       );
// }

// class QuizPaper {
//   final MapOfSortedKanjiByJlpt kanjiByJlpt;
//   QuizPaper({required this.kanjiByJlpt});
//   List<dynamic> get sortedKanji => kanjiByJlpt.kanjiByJlpt;

//   List<Map<String, dynamic>> generateQuestionsWithChoices(String choice) {
//     List<Map<String, dynamic>> setOfQuestion = [];
//     for (var kanji in sortedKanji) {
//       List<String> reading = [];
//       if ((kanji['kun_readings'] as List).isEmpty) {
//         reading.add(convertToListAndJoin(kanji['on_readings']));
//       }

//       var question = {
//         'question': choice == 'kanji' ? kanji['kanji'] : reading,
//         'answer': choice == 'kanji' ? reading : kanji['kanji'],
//         'meaning': kanji['meanings'],
//         'choices': generateChoices(kanji, choice)
//       };

//       setOfQuestion.add(question);
//     }
//     return setOfQuestion;
//   }

//   // Helper to generate a list of 4 choices
//   List<dynamic> generateChoices(dynamic kanji, String choice) {
//     List<dynamic> choices = [choice == 'kanji' ? kanji['kanji'] : convertToListAndJoin(kanji['on_readings'])];

//     while (choices.length < 4) {
//       // Randomly select a kanji item to use as a wrong answer
//       var randomKanji = sortedKanji[Random().nextInt(sortedKanji.length)];
//       var randomChoice = choice == 'kanji' ? randomKanji['kanji'] : convertToListAndJoin(randomKanji['on_readings']);

//       if (!choices.contains(randomChoice)) {
//         choices.add(randomChoice);
//       }
//     }
//     choices.shuffle(); // Shuffle choices so the correct answer isn't always in the same position
//     return choices;
//   }

//   // Example method to convert list to string
//   String convertToListAndJoin(List<dynamic> list) {
//     return list.join(", ");
//   }

//   // Display 10 items at a time
//   List<Map<String, dynamic>> paginateQuestions(List<Map<String, dynamic>> questions, int page, int itemsPerPage) {
//     int startIndex = (page - 1) * itemsPerPage;
//     int endIndex = startIndex + itemsPerPage;
//     endIndex = endIndex > questions.length ? questions.length : endIndex; // Handle overflow
//     return questions.sublist(startIndex, endIndex);
//   }

//   // Display a counter for the remaining items
//   int remainingItems(List<Map<String, dynamic>> questions, int page, int itemsPerPage) {
//     return questions.length - (page * itemsPerPage);
//   }
// }

// void main() {
//   // Example data to simulate input
//   var kanjiList = [
//     {
//       'kanji': '日',
//       'kun_readings': [],
//       'on_readings': ['ニチ', 'ジツ'],
//       'meanings': ['sun', 'day']
//     },
//     {
//       'kanji': '一',
//       'kun_readings': [],
//       'on_readings': ['イチ', 'イツ'],
//       'meanings': ['one']
//     },
//     // Add more kanji as needed
//   ];

//   var quizPaper = QuizPaper(kanjiByJlpt: MapOfSortedKanjiByJlpt(kanjiByJlpt: kanjiList));
//   var setOfQuestion = quizPaper.generateQuestionsWithChoices('kanji');

//   // Shuffle questions
//   setOfQuestion.shuffle();

//   int page = 1;
//   int itemsPerPage = 10;
//   bool continueQuiz = true;

//   while (continueQuiz && (page - 1) * itemsPerPage < setOfQuestion.length) {
//     var questionsToDisplay = quizPaper.paginateQuestions(setOfQuestion, page, itemsPerPage);
//     int remaining = quizPaper.remainingItems(setOfQuestion, page, itemsPerPage);

//     print("Page $page");
//     for (var question in questionsToDisplay) {
//       print("Question: ${question['question']}");
//       print("Choices: ${question['choices']}");
//       print("Meaning: ${question['meaning']}");
//       print("Correct Answer: ${question['answer']}\n");
//     }
//     print("Remaining questions: $remaining");

//     if (remaining > 0) {
//       print("Continue to the next set? (yes/no)");
//       // Simulate user input
//       String userInput = 'yes'; // This would be input in a real application
//       if (userInput.toLowerCase() == 'no') {
//         continueQuiz = false;
//       } else {
//         page++;
//       }
//     } else {
//       print("Quiz complete!");
//       continueQuiz = false;
//     }
//   }
// }

// class Quiz {
//   final String question;
//   final String meaning;
//   final String answer;
//   final List<dynamic> choices;

//   Quiz({required this.question, required this.choices, required this.meaning, required this.answer});

//   factory Quiz.displayQuestion(Map<String, dynamic> question) => Quiz(
//         question: question['question'],
//         choices: question['choices'],
//         meaning: convertToListAndJoin(question['meaning']),
//         answer: convertToListAndJoin(question['answer']),
//       );

//   @override
//   String toString() {
//     var toDisplay;
//     var randomizedChoice;
//     choices.shuffle();
//     bool timedOut = false;
//     var timer = Timer(const Duration(seconds: 10), () => timedOut = true);
//     var hint = timedOut == true ? meaning : '';
//     for (var choice in choices) {
//       randomizedChoice = '''
//         A: ${choice[0]}
//         B: ${choice[1]}
//         C: ${choice[2]}
//         D: ${choice[3]}
//       ''';
//     }
//     toDisplay = '''
//       Time : $timer
//       Hint : $hint

//       What kanji is this ? : $question
//       $randomizedChoice
//       ''';
//     return toDisplay;
//   }
// }

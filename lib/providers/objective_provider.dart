import 'package:flutter/material.dart';
import 'package:flutter_virash/objective/mcqPojo.dart';
import 'package:flutter_virash/objective/scores.dart';

class ObjectiveProvider with ChangeNotifier {
  PageController _pageController = PageController();
  PageController get pageController => _pageController;

  List<MCQPojo> _mcqs = [];
  List<MCQPojo> get mcqs => _mcqs;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isAnswered = false;
  bool get isAnswered => _isAnswered;

  int _correctAns = 0;
  int get correctAns => _correctAns;

  var _selectedAns;
  get selectedAns => _selectedAns;

  int _questionNumber = 1;
  int get questionNumber => _questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => _numOfCorrectAns;

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setMCQS(List<MCQPojo> list) {
    _mcqs = list;
    notifyListeners();
  }

  checkAns(MCQPojo question, int selectedIndex) {
    _isAnswered = true;
    _correctAns = question.answerIndex;
    _selectedAns = selectedIndex;

    if (correctAns == selectedAns) _numOfCorrectAns++;

    notifyListeners();
  }

  nextQuestion(BuildContext context) {
    if (questionNumber != mcqs.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);
      notifyListeners();
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, ObjectiveScores.route, (route) => false,
          arguments: ScoresArg(numOfCorrectAns, mcqs));

      _isAnswered = false;
      _correctAns = 0;
      _numOfCorrectAns = 0;
      _questionNumber = 1;

      notifyListeners();
    }
  }

  updateTheQnNum(index) {
    _questionNumber = index + 1;
    notifyListeners();
  }

  initialValues() {
    _isAnswered = false;
    _correctAns = 0;
    _numOfCorrectAns = 0;
    _questionNumber = 1;
    notifyListeners();
  }

  // List<MCQQuestions> _mcqQuestions = [];
  // List<MCQQuestions> get mcqQuestions => _mcqQuestions;

  // void mark(int mcqId, String correctAnswer, String selectedAnswer) {
  //   _mcqQuestions.add(MCQQuestions(mcqId, correctAnswer, selectedAnswer));
  //   notifyListeners();
  // }
}

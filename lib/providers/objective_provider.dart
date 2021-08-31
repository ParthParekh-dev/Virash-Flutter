import 'package:flutter/material.dart';

class MCQQuestions {
  final int mcqId;
  final String correctAnswer;
  final String selectedAnswer;

  MCQQuestions(this.mcqId, this.correctAnswer, this.selectedAnswer);
}

class ObjectiveProvider with ChangeNotifier {
  List<MCQQuestions> _mcqQuestions = [];
  List<MCQQuestions> get mcqQuestions => _mcqQuestions;

  void mark(int mcqId, String correctAnswer, String selectedAnswer) {
    _mcqQuestions.add(MCQQuestions(mcqId, correctAnswer, selectedAnswer));
    notifyListeners();
  }
}

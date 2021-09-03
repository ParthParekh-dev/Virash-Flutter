class MCQPojo {
  late int id;
  late String question;
  late List<dynamic> options;
  late int answerIndex;
  late String reason;
  late String questionImage;

  MCQPojo(
      {required this.id,
      required this.question,
      required this.options,
      required this.answerIndex,
      required this.reason,
      required this.questionImage});

  MCQPojo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    options = json['options'].cast<dynamic>();
    answerIndex = json['answer_index'];
    reason = json['reason'];
    questionImage = json['question_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question'] = this.question;
    data['options'] = this.options;
    data['answer_index'] = this.answerIndex;
    data['reason'] = this.reason;
    data['question_image'] = this.questionImage;
    return data;
  }
}

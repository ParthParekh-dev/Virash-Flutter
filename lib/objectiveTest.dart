import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_virash/questions.dart';

typedef QuestionCheckCallback<Question, int> = void Function(
    Question question, int selectedIndex);

class ObjectiveTest extends StatefulWidget {
  static var route = '/objectiveTest';

  @override
  _ObjectiveTestState createState() => _ObjectiveTestState();
}

class _ObjectiveTestState extends State<ObjectiveTest> {
  List<Question> _questions = sample_data
      .map(
        (question) => Question(
            id: question['id'],
            question: question['question'],
            options: question['options'],
            answer: question['answer_index']),
      )
      .toList();

  PageController _pageController = PageController();

  bool isAnswered = false;
  int correctAns = 0;
  var selectedAns;
  int questionNumber = 1;
  int numOfCorrectAns = 0;
  bool showScore = false;

  void checkAns(Question question, int selectedIndex) {
    print(question.question);
    print(selectedIndex);
    setState(() {
      isAnswered = true;
      correctAns = question.answer;
      selectedAns = selectedIndex;

      if (correctAns == selectedAns) numOfCorrectAns++;

      Future.delayed(Duration(seconds: 3), () {
        nextQuestion();
      });
    });
  }

  void nextQuestion() {
    if (questionNumber != _questions.length) {
      setState(() {
        isAnswered = false;
      });
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);
    } else {
      setState(() {
        showScore = true;
      });
    }
  }

  void updateTheQnNum(index) {
    setState(() {
      questionNumber = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showScore) {
      return Scaffold(
          appBar: AppBar(
            title: Text('Objective Test Series'),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Your Score",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${correctAns * 10}/${_questions.length * 10}",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Objective Test Series'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: updateTheQnNum,
                    itemCount: _questions.length,
                    itemBuilder: (context, index1) => Expanded(
                        flex: 1,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 12),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _questions[index1].question,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              ...List.generate(
                                  _questions[index1].options.length, (index) {
                                Color getTheRightColor() {
                                  if (isAnswered) {
                                    if (index == correctAns) {
                                      return Color(0xFF6AC259);
                                    } else if (index == selectedAns &&
                                        selectedAns != correctAns) {
                                      return Color(0xFFE92E30);
                                    }
                                  }
                                  return Color(0xFFC1C1C1);
                                }

                                IconData getTheRightIcon() {
                                  return getTheRightColor() == Color(0xFFE92E30)
                                      ? Icons.close
                                      : Icons.done;
                                }

                                return InkWell(
                                  onTap: () =>
                                      checkAns(_questions[index1], index),
                                  child: Container(
                                    margin: EdgeInsets.only(top: 25),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: getTheRightColor()),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${index + 1}. ${_questions[index1].options[index]}",
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 14,
                                              color: Colors.black),
                                        ),
                                        Container(
                                          height: 26,
                                          width: 26,
                                          decoration: BoxDecoration(
                                            color: getTheRightColor() ==
                                                    Color(0xFFC1C1C1)
                                                ? Colors.transparent
                                                : getTheRightColor(),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                                color: getTheRightColor()),
                                          ),
                                          child: getTheRightColor() ==
                                                  Color(0xFFC1C1C1)
                                              ? null
                                              : Icon(getTheRightIcon(),
                                                  size: 16),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                            ],
                          ),
                        )),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     NeumorphicButton(
                //       margin: EdgeInsets.only(top: 12),
                //       onPressed: () {
                //         _pageController.previousPage(
                //             duration: Duration(milliseconds: 250),
                //             curve: Curves.ease);
                //       },
                //       style: NeumorphicStyle(
                //         shape: NeumorphicShape.flat,
                //         depth: 3,
                //         color: Color(0xFFFF7801),
                //         boxShape: NeumorphicBoxShape.roundRect(
                //             BorderRadius.circular(8)),
                //       ),
                //       padding: const EdgeInsets.all(12.0),
                //       child: Icon(
                //         Icons.chevron_left,
                //         color: Colors.white,
                //         size: 28.0,
                //         semanticLabel: 'Prev Question',
                //       ),
                //     ),
                //     NeumorphicButton(
                //         margin: EdgeInsets.only(top: 12),
                //         onPressed: () {
                //           _pageController.nextPage(
                //               duration: Duration(milliseconds: 250),
                //               curve: Curves.ease);
                //         },
                //         style: NeumorphicStyle(
                //           shape: NeumorphicShape.flat,
                //           depth: 3,
                //           color: Color(0xFFFF7801),
                //           boxShape: NeumorphicBoxShape.roundRect(
                //               BorderRadius.circular(8)),
                //         ),
                //         padding: const EdgeInsets.all(12.0),
                //         child: Icon(
                //           Icons.chevron_right,
                //           color: Colors.white,
                //           size: 28.0,
                //           semanticLabel: 'Next Question',
                //         )),
                //   ],
                // )
              ],
            ),
          ),
        ),
      );
    }
  }
}

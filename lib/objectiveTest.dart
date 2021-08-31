import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_virash/questions.dart';

import 'package:provider/provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'animationWidgets.dart';

class ObjectiveTest extends StatefulWidget {
  static var route = '/objectiveTest';

  @override
  _ObjectiveTestState createState() => _ObjectiveTestState();
}

class _ObjectiveTestState extends State<ObjectiveTest>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
    _controller =
        AnimationController(duration: Duration(seconds: 60), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward().whenComplete(nextQuestion);

    _controller.addListener(() {
      setState(() {});
    });
  }

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

  void checkAns(Question question, int selectedIndex) {
    setState(() {
      isAnswered = true;
      correctAns = question.answer;
      selectedAns = selectedIndex;

      if (correctAns == selectedAns) numOfCorrectAns++;

      _controller.stop();

      Future.delayed(Duration(milliseconds: 1500), () {
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

      _controller.reset();

      _controller.forward().whenComplete(nextQuestion);
    } else {
      print("${numOfCorrectAns * 10} / ${_questions.length * 10}");
    }
  }

  void updateTheQnNum(index) {
    setState(() {
      questionNumber = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = context.watch<InternetProvider>().isConnected;
    if (!isConnected) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationWidgets().noInternet,
        )),
      );
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xFFFF7801), width: 1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Stack(
                      children: [
                        // LayoutBuilder provide us the available space for the conatiner
                        // constraints.maxWidth needed for our animation
                        LayoutBuilder(
                          builder: (context, constraints) => Container(
                            // from 0 to 1 it takes 60s
                            height: 34,
                            width: constraints.maxWidth * _animation.value,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF7801), Color(0xFFFF7801)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12 / 2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("${(_animation.value * 60).round()} sec",
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                                "Q${index1 + 1}. ${_questions[index1].question}",
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
              ],
            ),
          ),
        ),
      );
    }
  }
}

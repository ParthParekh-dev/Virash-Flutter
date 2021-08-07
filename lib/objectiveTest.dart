import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_virash/questions.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  // Block swipe to next qn
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  // onPageChanged: _questionController.updateTheQnNum,
                  itemCount: _questions.length,
                  itemBuilder: (context, index) => QuestionCard(
                    question: _questions[index],
                  ),
                ),
              ),
              // PageView.builder(
              //     itemCount: 2,
              //     itemBuilder: (context, index) => QuestionCard()),
              // QuestionCard(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NeumorphicButton(
                    margin: EdgeInsets.only(top: 12),
                    onPressed: () {
                      _pageController.previousPage(
                          duration: Duration(milliseconds: 250),
                          curve: Curves.ease);
                    },
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 3,
                      color: Color(0xFF3B6AA2),
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(8)),
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28.0,
                      semanticLabel: 'Prev Question',
                    ),
                  ),
                  NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 250),
                            curve: Curves.ease);
                      },
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 3,
                        color: Color(0xFF3B6AA2),
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 28.0,
                        semanticLabel: 'Next Question',
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class QuestionCard extends StatelessWidget {
  const QuestionCard({
    Key? key,
    required this.question,
  }) : super(key: key);

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        flex: 1,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                question.question,
                style: TextStyle(color: Color(0xFF000000), fontSize: 18),
              ),
              Option(),
              Option(),
              Option(),
              Option(),
            ],
          ),
        ));
  }
}

class Option extends StatelessWidget {
  const Option({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFFC1C1C1)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Option 1",
            style: TextStyle(color: Color(0xFFC1C1C1), fontSize: 12),
          ),
          Container(
            height: 26,
            width: 26,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Color(0xFFC1C1C1)),
            ),
            child: null,
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_virash/examList.dart';
import 'package:flutter_virash/liveSession.dart';
import 'package:flutter_virash/shopCourse.dart';
import 'package:flutter_virash/strategyExamList.dart';
// import 'package:flutter_virash/studyMaterial.dart';
import 'package:flutter_virash/testSeries.dart';
import 'package:flutter_virash/whatsappForm.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  static var route = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Center(
                child: Hero(
                  tag: "HeroOne",
                  child: Image.asset('assets/logo_unique.png'),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 7.5, 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LiveSession.route);
                        },
                        child: MainCard(
                          cardChild: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.ggCircle,
                                  size: 50,
                                  color: Color(0xFFFF7801),
                                ),
                                Text(
                                  'Live Sessions',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7.5, 0, 15, 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ShopCourse.route);
                        },
                        child: MainCard(
                          cardChild: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.graduationCap,
                                  size: 50,
                                  color: Color(0xFFFF7801),
                                ),
                                Text(
                                  'All Courses',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 7.5, 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ExamList.route);
                        },
                        child: MainCard(
                          cardChild: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.leanpub,
                                  size: 50,
                                  color: Color(0xFFFF7801),
                                ),
                                Text(
                                  'Study Material',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7.5, 0, 15, 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, TestSeries.route);
                        },
                        child: MainCard(
                          cardChild: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.joomla,
                                  size: 50,
                                  color: Color(0xFFFF7801),
                                ),
                                Text(
                                  'Test Series',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 7.5, 25),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, WhatsappForm.route);
                          },
                          child: MainCard(
                            cardChild: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.whatsapp,
                                    size: 50,
                                    color: Color(0xFFFF7801),
                                  ),
                                  Text(
                                    'Whatsapp Groups',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(7.5, 0, 15, 25),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, StrategyExamList.route);
                        },
                        child: MainCard(
                          cardChild: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.empire,
                                  size: 50,
                                  color: Color(0xFFFF7801),
                                ),
                                Text(
                                  'Exam Strategy',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainCard extends StatelessWidget {
  MainCard({required this.cardChild});

  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFFFFFFFF),
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: cardChild,
    );
  }
}

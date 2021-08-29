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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LiveSession.route);
                        },
                        child: MainCard(
                            title: 'Live Sessions',
                            subTitle: '7k+',
                            childIcon: FontAwesomeIcons.ggCircle),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ShopCourse.route);
                        },
                        child: MainCard(
                            title: 'All Courses',
                            subTitle: '50+',
                            childIcon: FontAwesomeIcons.graduationCap),
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ExamList.route);
                        },
                        child: MainCard(
                            title: 'Study Material',
                            subTitle: '14k+',
                            childIcon: FontAwesomeIcons.leanpub),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, TestSeries.route);
                        },
                        child: MainCard(
                            title: 'Test Series',
                            subTitle: '700+',
                            childIcon: FontAwesomeIcons.joomla),
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, WhatsappForm.route);
                          },
                          child: MainCard(
                              title: 'Whatsapp Groups',
                              subTitle: '70+',
                              childIcon: FontAwesomeIcons.whatsapp),
                        )),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, StrategyExamList.route);
                        },
                        child: MainCard(
                            title: 'Exam Strategy',
                            subTitle: '14k+',
                            childIcon: FontAwesomeIcons.empire),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MainCard extends StatelessWidget {
  MainCard(
      {required this.childIcon, required this.title, required this.subTitle});

  final IconData childIcon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.20,
          width: MediaQuery.of(context).size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Color(0xFFFFFFFF),
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 130,
          left: 110,
          child: Container(
            height: 80,
            width: 80,
            child: Card(
                color: Color(0xFFFFFFFF),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: FaIcon(
                    childIcon,
                    size: 40,
                    color: Color(0xFFFF7801),
                  ),
                  onPressed: () {},
                )),
          ),
        ),
      ],
    );
  }
}

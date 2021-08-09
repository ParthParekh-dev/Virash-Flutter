import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_virash/liveSession.dart';
import 'package:flutter_virash/shopCourse.dart';
import 'package:flutter_virash/studyMaterial.dart';
import 'package:flutter_virash/testSeries.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: MainCard(
                  cardChild: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Icon(
                          Icons.cloud_upload_outlined,
                          color: Color(0xFFFFFFFF),
                          size: 60,
                        )),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Upload Assignment',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'PoppinsBold',
                                    color: Colors.white,
                                    fontSize: 18),
                              ),
                              Text(
                                'Add document from internal storage',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          icon: Icon(
                            Icons.add_circle,
                            color: Color(0xFFFF7801),
                            size: 24.0,
                          ),
                          label: Text(
                            'Add document',
                            style: TextStyle(
                              color: Color(0xFFFF7801),
                            ),
                          ),
                          onPressed: () {
                            // Navigator.pushNamed(context, '/addAssignment');
                          },
                        ),
                      ],
                    ),
                  ),
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
                      padding: const EdgeInsets.fromLTRB(15, 0, 7.5, 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, LiveSession.route);
                        },
                        child: MainCard(
                          cardChild: Center(
                            child: Text(
                              'Live Sessions',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7.5, 0, 15, 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, ShopCourse.route);
                          },
                          child: MainCard(
                            cardChild: Center(
                              child: Text(
                                'All Courses',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ))
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
                        padding: const EdgeInsets.fromLTRB(15, 0, 7.5, 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, StudyMaterial.route);
                          },
                          child: MainCard(
                            cardChild: Center(
                              child: Text(
                                'Study Material',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7.5, 0, 15, 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, TestSeries.route);
                          },
                          child: MainCard(
                            cardChild: Center(
                              child: Text(
                                'Test Series',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ))
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
      color: Color(0xFFFF7801),
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: cardChild,
    );
  }
}

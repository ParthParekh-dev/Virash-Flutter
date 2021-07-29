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
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30, 30, 0, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "HeroOne",
                      child: FaIcon(
                        FontAwesomeIcons.skyatlas,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Welcome to Virash',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.white),
                        ),
                        Text(
                          'Hey, Parth!',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: MainCard(
                  cardChild: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: Color(0xFF133157),
                          size: 60,
                        ),
                        Column(
                          children: [
                            Text(
                              'Upload Assignment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'PoppinsBold',
                                  color: Color(0xFF133157),
                                  fontSize: 18),
                            ),
                            Text(
                              'Add document from internal storage',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF133157),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF133157),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          label: Text(
                            'Add document',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/addAssignment');
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
                            cardChild: Center(child: Text('Live Sessions')),
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(7.5, 0, 15, 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, ShopCourse.route);
                          },
                          child: MainCard(
                            cardChild: Center(child: Text('All Courses')),
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
                            cardChild: Center(child: Text('Study Material')),
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
                            cardChild: Center(child: Text('Test Series')),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: MainCard(
                  cardChild: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload_outlined,
                          color: Color(0xFF133157),
                          size: 60,
                        ),
                        Column(
                          children: [
                            Text(
                              'Upload Assignment',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'PoppinsBold',
                                  color: Color(0xFF133157),
                                  fontSize: 18),
                            ),
                            Text(
                              'Add document from internal storage',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Color(0xFF133157),
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xFF133157),
                            shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0),
                            ),
                          ),
                          icon: Icon(
                            Icons.add_circle,
                            color: Colors.white,
                            size: 24.0,
                          ),
                          label: Text(
                            'Add document',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/addAssignment');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
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
      color: Colors.white,
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: cardChild,
    );
  }
}

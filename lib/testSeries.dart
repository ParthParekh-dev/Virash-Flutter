import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_virash/objectiveTest.dart';

class TestSeries extends StatefulWidget {
  static var route = '/testSeries';

  @override
  _TestSeriesState createState() => _TestSeriesState();
}

class _TestSeriesState extends State<TestSeries> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      onPressed: () {
                        Navigator.pushNamed(context, ObjectiveTest.route);
                      },
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 3,
                        color: Color(0xFF3B6AA2),
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Objective",
                        style: TextStyle(color: Colors.white),
                      )),
                  NeumorphicButton(
                      margin: EdgeInsets.only(top: 12),
                      onPressed: () {},
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 3,
                        color: Color(0xFF3B6AA2),
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(8)),
                      ),
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Subjective",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

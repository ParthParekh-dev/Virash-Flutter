import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/examStrategy.dart';
// import 'package:flutter_virash/subjectList.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'homePage.dart';

class StrategyExamList extends StatefulWidget {
  static var route = '/strategyExamList';

  @override
  _StrategyExamListState createState() => _StrategyExamListState();
}

class _StrategyExamListState extends State<StrategyExamList> {
  late SharedPreferences prefs;

  Future<List<Exams>> _getExams() async {
    prefs = await SharedPreferences.getInstance();

    var response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/exam.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"course_id": prefs.getString('course_id')}
      ]),
    );
    var jsonData = json.decode(response.body);

    var listExams = jsonData;

    List<Exams> users = [];

    var u = listExams;

    for (int i = 0; i <= listExams.length - 1; i++) {
      var name = u[i]['exam_name'];
      var id = u[i]['exam_id'].toString();
      Exams user = Exams(id, name);

      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Exams'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, HomePage.route, (r) => false);
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      body: Container(
        child: FutureBuilder(
          future: _getExams(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: SpinKitCubeGrid(
                    color: Color(0xFFFF7801),
                    size: 50.0,
                  ),
                ),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          onTap: () {
                            print(snapshot.data[index].id);
                            Navigator.pushNamed(context, ExamStrategy.route,
                                arguments: snapshot.data[index].id);
                          },
                          title: Text(
                            snapshot.data[index].name,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 30),
                        child: Divider(
                          thickness: 1,
                        ),
                      ),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Exams {
  final String id;
  final String name;

  Exams(this.id, this.name);
}

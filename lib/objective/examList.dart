import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/homePage.dart';
import 'package:flutter_virash/objective/subjectList.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExamPojo {
  final int id;
  final String name;

  ExamPojo(this.id, this.name);
}

class ExamList extends StatefulWidget {
  static var route = '/objectiveExamList';
  ExamList({Key? key}) : super(key: key);

  @override
  _ExamListState createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  Future<List<ExamPojo>> getExams() async {
    prefs = await SharedPreferences.getInstance();

    final url = "https://virashtechnologies.com/unique/api/exam.php";
    var res = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"course_id": prefs.getString('course_id')}
      ]),
    );
    final resBody = jsonDecode(res.body) as List;
    List<ExamPojo> myList = [];
    for (var exam in resBody) {
      myList.add(ExamPojo(exam["exam_id"], exam["exam_name"]));
    }
    return myList;
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
            future: getExams(),
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
                if (snapshot.data.length == 0) {
                  return AnimationWidgets().noData;
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
                                Navigator.pushNamed(context, SubjectList.route,
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
              }
            },
          ),
        ),
      );
    }
  }
}

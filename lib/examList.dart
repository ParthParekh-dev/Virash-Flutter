// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:flutter_virash/subjectList.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'animationWidgets.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'homePage.dart';

class ExamList extends StatefulWidget {
  static var route = '/examList';

  @override
  _ExamListState createState() => _ExamListState();
}

class _ExamListState extends State<ExamList> {
  late SharedPreferences prefs;
  var count = 0;

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
      var thumbnail = u[i]['thumbnail'].toString();
      Exams user = Exams(id, name, thumbnail);

      users.add(user);
    }

    count = users.length;

    return users;
  }

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var from = args.toString();

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
            future: _getExams(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: Color(0xFFFF7801),
                      size: 50.0,
                    ),
                  ),
                );
              } else {
                if (count == 0) {
                  return AnimationWidgets().noData;
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, SubjectList.route,
                                arguments: [
                                  snapshot.data[index].id,
                                  snapshot.data[index].name,
                                  from
                                ]);
                          },
                          child: Card(
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 4,
                                    child: Center(
                                        child: FadeInImage.memoryNetwork(
                                            placeholder: kTransparentImage,
                                            image:
                                                snapshot.data[index].thumbnail,
                                            height: 120,
                                            fit: BoxFit.fitHeight)),
                                  ),
                                  Expanded(
                                    flex: 6,
                                    child: Center(
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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

class Exams {
  final String id;
  final String name;
  final String thumbnail;

  Exams(this.id, this.name, this.thumbnail);
}

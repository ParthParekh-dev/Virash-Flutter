import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/homePage.dart';
import 'package:flutter_virash/objective/chapterList.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class SubjectPojo {
  final int subjectId;
  final String subjectName;

  SubjectPojo(this.subjectId, this.subjectName);
}

class SubjectList extends StatefulWidget {
  static var route = '/objectiveSubjectList';
  SubjectList({Key? key}) : super(key: key);

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  Future<List<SubjectPojo>> getSubjects() async {
    final url = "https://virashtechnologies.com/unique/api/subject.php";
    var res = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"exam_id": ModalRoute.of(context)!.settings.arguments}
      ]),
    );
    final resBody = jsonDecode(res.body) as List;
    List<SubjectPojo> myList = [];
    for (var subject in resBody) {
      myList.add(SubjectPojo(subject["subject_id"], subject["subject_name"]));
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
          title: Text('All Subjects'),
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
            future: getSubjects(),
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
                                Navigator.pushNamed(context, ChapterList.route,
                                    arguments: snapshot.data[index].subjectId);
                              },
                              title: Text(
                                snapshot.data[index].subjectName,
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

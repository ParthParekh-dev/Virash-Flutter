import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/chapterList.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SubjectList extends StatefulWidget {
  static var route = '/subjectList';

  @override
  _SubjectListState createState() => _SubjectListState();
}

class _SubjectListState extends State<SubjectList> {
  late SharedPreferences prefs;
  Future<List<Subject>> _getSubject(String exam_id) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('exam_id', exam_id);

    var response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/subject.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"exam_id": exam_id}
      ]),
    );
    var jsonData = json.decode(response.body);

    var listSubjects = jsonData;

    List<Subject> users = [];

    var u = listSubjects;

    for (int i = 0; i <= listSubjects.length - 1; i++) {
      var name = u[i]['subject_name'];
      var id = u[i]['subject_id'].toString();
      Subject user = Subject(id, name);

      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var exam_id = args.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Subjects'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getSubject(exam_id),
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
                            Navigator.pushNamed(context, ChapterList.route,
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

class Subject {
  final String id;
  final String name;

  Subject(this.id, this.name);
}

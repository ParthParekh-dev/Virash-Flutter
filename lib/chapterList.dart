import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/studyMaterial.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

class ChapterList extends StatefulWidget {
  static var route = '/chapterList';

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  Future<List<Chapter>> _getChapter(String subject_id) async {
    var response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/chapter.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"subject_id": subject_id}
      ]),
    );
    var jsonData = json.decode(response.body);

    var listSubjects = jsonData;

    List<Chapter> users = [];

    var u = listSubjects;

    for (int i = 0; i <= listSubjects.length - 1; i++) {
      var name = u[i]['chapter_name'];
      var id = u[i]['chapter_id'].toString();
      Chapter user = Chapter(id, name);

      users.add(user);
    }

    return users;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    var subject_id = args.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text('All Chapters'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getChapter(subject_id),
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
                            // print(snapshot.data[index].id);
                            Navigator.pushNamed(context, StudyMaterial.route,
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

class Chapter {
  final String id;
  final String name;

  Chapter(this.id, this.name);
}

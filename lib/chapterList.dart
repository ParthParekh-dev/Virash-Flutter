import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/liveSession.dart';
import 'package:flutter_virash/studyMaterial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'animationWidgets.dart';
import 'homePage.dart';

import 'package:provider/provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';

class ChapterList extends StatefulWidget {
  static var route = '/chapterList';

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  late SharedPreferences prefs;
  var count = 0;

  Future<List<Chapter>> _getChapter(String subjectId) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('subject_id', subjectId);

    var response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/chapter.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"subject_id": subjectId}
      ]),
    );
    var jsonData = json.decode(response.body);

    var listSubjects = jsonData;

    List<Chapter> users = [];

    var u = listSubjects;

    for (int i = 0; i <= listSubjects.length - 1; i++) {
      var name = u[i]['chapter_name'];
      var id = u[i]['chapter_id'].toString();
      var thumbnail = u[i]['ch_thumbnail'].toString();
      Chapter user = Chapter(id, name, thumbnail);

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
    final args = ModalRoute.of(context)!.settings.arguments as List;
    var subjectId = args[0].toString();
    var subjectName = args[1].toString();
    var from = args[2].toString();

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
          title: Text(subjectName),
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
            future: _getChapter(subjectId),
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
                            if (from == "study_material") {
                              Navigator.pushNamed(context, StudyMaterial.route,
                                  arguments: [
                                    snapshot.data[index].id,
                                    snapshot.data[index].name
                                  ]);
                            } else {
                              Navigator.pushNamed(context, LiveSession.route);
                            }
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
                                              snapshot.data[index].thumbnail),
                                    ),
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

class Chapter {
  final String id;
  final String name;
  final String thumbnail;

  Chapter(this.id, this.name, this.thumbnail);
}

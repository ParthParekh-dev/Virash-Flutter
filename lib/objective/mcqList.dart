import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/homePage.dart';
import 'package:flutter_virash/objective/mcq.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MCQListPojo {
  final int mcqId;
  final String title;
  final int questionCount;

  MCQListPojo(this.mcqId, this.title, this.questionCount);
}

class MCQListArguments {
  final int chapterId;
  final int subjectId;

  MCQListArguments(this.chapterId, this.subjectId);
}

class ObjectiveMCQList extends StatefulWidget {
  static var route = "/objectiveMCQList";

  ObjectiveMCQList({Key? key}) : super(key: key);

  @override
  _ObjectiveMCQListState createState() => _ObjectiveMCQListState();
}

class _ObjectiveMCQListState extends State<ObjectiveMCQList> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  Future<List<MCQListPojo>> getMCQList() async {
    prefs = await SharedPreferences.getInstance();
    final args = ModalRoute.of(context)!.settings.arguments as MCQListArguments;

    final url = "https://virashtechnologies.com/unique/api/mcqList.php";
    var res = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "mobile_number": prefs.getString('mobile'),
          "user_id": prefs.getString('user_id'),
          "subject_id": args.subjectId,
          "chapter_id": args.chapterId
        }
      ]),
    );
    final resBody = jsonDecode(res.body);
    if (resBody != null) {
      List<MCQListPojo> myList = [];
      for (var mcq in resBody as List) {
        myList.add(
            MCQListPojo(mcq["mcq_id"], mcq["title"], mcq["question_count"]));
      }
      return myList;
    } else {
      return [];
    }
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
          title: Text("All MCQ's"),
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
            future: getMCQList(),
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
                                Navigator.pushNamed(context, ObjectiveMCQ.route,
                                    arguments: MCQArguments(
                                        snapshot.data[index].mcqId,
                                        snapshot.data[index].title));
                              },
                              title: Text(
                                snapshot.data[index].title,
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

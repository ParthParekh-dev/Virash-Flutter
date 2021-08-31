import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/homePage.dart';
import 'package:flutter_virash/objective/mcqList.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ChapterPojo {
  final int chapterId;
  final String chapterName;

  ChapterPojo(this.chapterId, this.chapterName);
}

class ChapterList extends StatefulWidget {
  static var route = '/objectiveChapterList';
  ChapterList({Key? key}) : super(key: key);

  @override
  _ChapterListState createState() => _ChapterListState();
}

class _ChapterListState extends State<ChapterList> {
  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  Future<List<ChapterPojo>> getChapters() async {
    final url = "https://virashtechnologies.com/unique/api/chapter.php";
    var res = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"subject_id": ModalRoute.of(context)!.settings.arguments}
      ]),
    );
    final resBody = jsonDecode(res.body) as List;
    List<ChapterPojo> myList = [];
    for (var chapter in resBody) {
      myList.add(ChapterPojo(chapter["chapter_id"], chapter["chapter_name"]));
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
          title: Text('All Chapters'),
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
            future: getChapters(),
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
                                Navigator.pushNamed(
                                    context, ObjectiveMCQList.route,
                                    arguments: MCQListArguments(
                                        snapshot.data[index].chapterId,
                                        ModalRoute.of(context)!
                                            .settings
                                            .arguments as int));
                              },
                              title: Text(
                                snapshot.data[index].chapterName,
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

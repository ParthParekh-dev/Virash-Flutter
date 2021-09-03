import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/pdfViewer.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'animationWidgets.dart';
import 'homePage.dart';

import 'package:provider/provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';

class ExamStrategy extends StatefulWidget {
  static var route = '/examStrategy';

  @override
  _ExamStrategyState createState() => _ExamStrategyState();
}

class _ExamStrategyState extends State<ExamStrategy> {
  late SharedPreferences prefs;
  var count = 0;

  Future<List<PdfDetails>> _getStrategy(String examId) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString('exam_id', examId);

    var response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/exam-strategy.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "mobile_number": prefs.getString('mobile')!,
          "user_id": prefs.getString('user_id')!,
          "exam_id": prefs.getString('exam_id')!
        }
      ]),
    );
    var jsonData = json.decode(response.body);

    var listMaterial = jsonData;

    List<PdfDetails> users = [];

    var u = listMaterial;

    for (int i = 0; i <= listMaterial.length - 1; i++) {
      var name = u[i]['title'];
      var attachment = u[i]['attachment'];
      var id = u[i]['id'].toString();
      var pic = u[i]['thumbnail'];
      PdfDetails user = PdfDetails(id, name, pic, attachment);

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
    var examId = args.toString();

    bool isConnected = context.watch<InternetProvider>().isConnected;
    if (!isConnected) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimationWidgets().noInternet,
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Exam Strategy'),
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
            future: _getStrategy(examId),
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
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: ListTile(
                              onTap: () {
                                Navigator.pushNamed(context, PdfViewer.route,
                                    arguments: snapshot.data[index].attachment);
                              },
                              leading: CircleAvatar(
                                radius: 40,
                                backgroundImage:
                                    NetworkImage(snapshot.data[index].avatar),
                              ),
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

class PdfDetails {
  final String id;
  final String title;
  final String avatar;
  final String attachment;

  PdfDetails(this.id, this.title, this.avatar, this.attachment);
}

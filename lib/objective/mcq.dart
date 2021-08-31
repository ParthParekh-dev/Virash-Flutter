import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MCQArguments {
  final int mcqId;
  final String title;

  MCQArguments(this.mcqId, this.title);
}

class MCQPojo {
  final int qaId;
  final String question;
  final String op1;
  final String op2;
  final String op3;
  final String op4;
  final String answer;
  final String reason;
  final String questionImage;

  MCQPojo(this.qaId, this.question, this.op1, this.op2, this.op3, this.op4,
      this.answer, this.reason, this.questionImage);
}

class ObjectiveMCQ extends StatefulWidget {
  static var route = "/objectiveMCQ";
  ObjectiveMCQ({Key? key}) : super(key: key);

  @override
  _ObjectiveMCQState createState() => _ObjectiveMCQState();
}

class _ObjectiveMCQState extends State<ObjectiveMCQ> {
  late PageController _pageController = PageController();
  late SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  Future<List<MCQPojo>> getMCQS() async {
    prefs = await SharedPreferences.getInstance();
    final args = ModalRoute.of(context)!.settings.arguments as MCQArguments;

    final url = "https://virashtechnologies.com/unique/api/mcqQaList.php";
    var res = await post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "mobile_number": prefs.getString('mobile'),
          "user_id": prefs.getString('user_id'),
          "mcq_id": args.mcqId
        }
      ]),
    );
    final resBody = jsonDecode(res.body);
    if (resBody != null) {
      List<MCQPojo> myList = [];
      for (var mcq in resBody as List) {
        myList.add(MCQPojo(
            mcq["qa_id"],
            mcq["question"],
            mcq["op1"],
            mcq["op2"],
            mcq["op3"],
            mcq["op4"],
            mcq["answer"],
            mcq["reason"],
            mcq["question_image"]));
      }
      return myList;
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MCQArguments;
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
          title: Text(args.title),
        ),
        body: Container(
          child: FutureBuilder(
            future: getMCQS(),
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
                  return PageView.builder(
                    // physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                                "Q${index + 1}. ${snapshot.data[index].question}"),
                            SizedBox(
                              height: 20,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(snapshot.data[index].op1),
                                Text(snapshot.data[index].op2),
                                Text(snapshot.data[index].op3),
                                Text(snapshot.data[index].op1)
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  );
                  // return ListView.builder(
                  //   itemCount: snapshot.data.length,
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return Column(
                  //       children: [
                  //         Padding(
                  //           padding: const EdgeInsets.all(5.0),
                  //           child: ListTile(
                  //             onTap: () {},
                  //             title: Text(
                  //               snapshot.data[index].question,
                  //               style: TextStyle(
                  //                 fontSize: 16,
                  //                 color: Colors.black,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.symmetric(
                  //               vertical: 0, horizontal: 30),
                  //           child: Divider(
                  //             thickness: 1,
                  //           ),
                  //         ),
                  //       ],
                  //     );
                  //   },
                  // );
                }
              }
            },
          ),
        ),
      );
    }
  }
}

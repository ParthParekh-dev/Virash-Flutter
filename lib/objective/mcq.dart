// import 'dart:convert';

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
// import 'package:flutter_virash/helpers/apiHelper.dart';
import 'package:flutter_virash/objective/mcqPojo.dart';
// import 'package:flutter_virash/objective/mcqPojo.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:flutter_virash/providers/objective_provider.dart';
import 'package:http/http.dart';
// import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MCQArguments {
  final int mcqId;
  final String title;

  MCQArguments(this.mcqId, this.title);
}

class ObjectiveMCQ extends StatefulWidget {
  static var route = "/objectiveMCQ";
  ObjectiveMCQ({Key? key}) : super(key: key);

  @override
  _ObjectiveMCQState createState() => _ObjectiveMCQState();
}

class _ObjectiveMCQState extends State<ObjectiveMCQ>
    with SingleTickerProviderStateMixin {
  // static const countdownDuration = 10;
  // int seconds = countdownDuration;
  // Timer? timer;

  // late PageController _pageController = PageController();

  // late AnimationController _controller;
  // late Animation _animation;

  // _startTimer() {
  //   _controller.forward().whenComplete(() {
  //     _pageController.nextPage(
  //         duration: Duration(seconds: 0), curve: Curves.easeIn);
  //   });
  //   timer = Timer.periodic(Duration(seconds: 1), (_) {
  //     if (seconds > 0) {
  //       setState(() {
  //         seconds--;
  //       });
  //     } else {
  //       timer?.cancel();
  //       _controller.stop();
  //     }
  //   });
  // }

  _getMCQS(MCQArguments args) async {
    var prefs = await SharedPreferences.getInstance();
    var provider = Provider.of<ObjectiveProvider>(context, listen: false);
    provider.initialValues();
    provider.setIsLoading(true);
    var response = await post(
      Uri.parse("https://virashtechnologies.com/unique/api/mcqQaList.php"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "mobile_number": prefs.getString("mobile") ?? "",
          "user_id": prefs.getString("user_id") ?? "",
          "mcq_id": args.mcqId
        }
      ]),
    );
    provider.setIsLoading(false);
    List<MCQPojo> mcqs = [];
    if (response.statusCode == 200 && jsonDecode(response.body) != null) {
      var body = jsonDecode(response.body);
      body.forEach((e) {
        MCQPojo mcq = MCQPojo(
            id: e['id'],
            question: e['question'],
            options: e['options'],
            answerIndex: e['answer_index'],
            reason: e['reason'],
            questionImage: e['question_image']);
        mcqs.add(mcq);
      });
      // _startTimer();
    }
    provider.setMCQS(mcqs);
  }

  @override
  initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
    // _controller = AnimationController(
    //     duration: Duration(seconds: 10),
    //     lowerBound: 0,
    //     upperBound: 1.0,
    //     vsync: this)
    //   ..addListener(() {
    //     setState(() {});
    //   });
    // _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    Future.delayed(Duration(seconds: 0), () {
      final args = ModalRoute.of(context)!.settings.arguments as MCQArguments;
      _getMCQS(args);
    });
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MCQArguments;
    bool isConnected = context.watch<InternetProvider>().isConnected;
    bool isLoading = context.watch<ObjectiveProvider>().isLoading;
    bool isAnswered = context.watch<ObjectiveProvider>().isAnswered;
    int correctAns = context.watch<ObjectiveProvider>().correctAns;
    var selectedAns = context.watch<ObjectiveProvider>().selectedAns;
    List<MCQPojo> mcqs = context.watch<ObjectiveProvider>().mcqs;

    if (!isConnected) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationWidgets().noInternet,
        )),
      );
    } else {
      if (isLoading) {
        return Scaffold(
          appBar: AppBar(
            title: Text(args.title),
          ),
          body: Container(
            child: Center(
              child: SpinKitFadingCircle(
                color: Color(0xFFFF7801),
                size: 50.0,
              ),
            ),
          ),
        );
      } else {
        if (mcqs.length == 0) {
          return Scaffold(
            appBar: AppBar(
              title: Text(args.title),
            ),
            body: Container(
              child: AnimationWidgets().noData,
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(args.title),
            ),
            body: SafeArea(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Timer
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Container(
                    //           margin: EdgeInsets.symmetric(vertical: 12),
                    //           width: MediaQuery.of(context).size.width,
                    //           height: 20,
                    //           child: ClipRRect(
                    //             borderRadius:
                    //                 BorderRadius.all(Radius.circular(20)),
                    //             child: LinearProgressIndicator(
                    //               value: _controller.value,
                    //               valueColor: AlwaysStoppedAnimation<Color>(
                    //                   Color(0xFFFF7801)),
                    //               backgroundColor: Color(0xFFFFDAB8),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //       SizedBox(
                    //         width: 18,
                    //       ),
                    //       Text(
                    //           "${seconds == 60 ? '01:00' : '00:${seconds > 9 ? seconds : '0$seconds'}'}")
                    //     ],
                    //   ),
                    // ),
                    // Question Card
                    Expanded(
                      child: PageView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        onPageChanged:
                            context.read<ObjectiveProvider>().updateTheQnNum,
                        controller:
                            context.read<ObjectiveProvider>().pageController,
                        itemCount: mcqs.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    "Question ${index + 1} of ${mcqs.length}",
                                    style: TextStyle(
                                        color: Color(0xFFFF7801),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${mcqs[index].question}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  ...List.generate(
                                    mcqs[index].options.length,
                                    (index1) {
                                      Color getBgColor() {
                                        if (isAnswered) {
                                          if (index1 == correctAns) {
                                            return Color(0xFF4bc46b);
                                          } else if (index1 == selectedAns &&
                                              selectedAns != correctAns) {
                                            return Color(0xFFe8544d);
                                          }
                                        }
                                        return Colors.grey[200]!;
                                      }

                                      Color getTextColor() {
                                        if (isAnswered) {
                                          if (index1 == correctAns) {
                                            return Colors.white;
                                          } else if (index1 == selectedAns &&
                                              selectedAns != correctAns) {
                                            return Colors.white;
                                          }
                                        }
                                        return Colors.black;
                                      }

                                      Color getCircleBorderColor() {
                                        if (isAnswered) {
                                          if (index1 == correctAns) {
                                            return Colors.white;
                                          } else if (index1 == selectedAns &&
                                              selectedAns != correctAns) {
                                            return Colors.white;
                                          }
                                        }
                                        return Colors.black87;
                                      }

                                      Color getCircleColor() {
                                        if (isAnswered) {
                                          if (index1 == correctAns) {
                                            return Colors.white;
                                          } else if (index1 == selectedAns &&
                                              selectedAns != correctAns) {
                                            return Colors.white;
                                          }
                                        }
                                        return Colors.transparent;
                                      }

                                      IconData getIcon() {
                                        return getBgColor() == Color(0xFFe8544d)
                                            ? Icons.close
                                            : Icons.done;
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          var provider =
                                              Provider.of<ObjectiveProvider>(
                                                  context,
                                                  listen: false);
                                          if (!isAnswered) {
                                            provider.checkAns(
                                                mcqs[index], index1);
                                          }
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(12),
                                          margin: EdgeInsets.symmetric(
                                              vertical: 10),
                                          decoration: BoxDecoration(
                                            color: getBgColor(),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 8, 0),
                                                decoration: BoxDecoration(
                                                  color: getCircleColor(),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  border: Border.all(
                                                      color:
                                                          getCircleBorderColor()),
                                                ),
                                                child: getTextColor() ==
                                                        Colors.black
                                                    ? null
                                                    : Icon(getIcon(), size: 12),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  mcqs[index].options[index1],
                                                  style: TextStyle(
                                                      color: getTextColor(),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 15),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  isAnswered
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                "Explanation",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              Text(
                                                mcqs[index].reason,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      : Text("")
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Next Button
                    isAnswered
                        ? ElevatedButton(
                            onPressed: () {
                              context
                                  .read<ObjectiveProvider>()
                                  .nextQuestion(context);
                            },
                            child: Text(
                              "Next Question",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFFFF7801),
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide.none,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 0,
                          ),
                  ],
                ),
              ),
            ),
          );
        }
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/homePage.dart';
import 'package:flutter_virash/objective/mcqPojo.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:provider/provider.dart';

class ScoresArg {
  final int correctAns;
  final List<MCQPojo> mcqs;

  ScoresArg(this.correctAns, this.mcqs);
}

class ObjectiveScores extends StatefulWidget {
  static var route = "/objectiveScores";
  ObjectiveScores({Key? key}) : super(key: key);

  @override
  _ObjectiveScoresState createState() => _ObjectiveScoresState();
}

class _ObjectiveScoresState extends State<ObjectiveScores> {
  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
  }

  double calculatePercent(ScoresArg args) {
    double percent = (args.correctAns / args.mcqs.length) * 100;
    print(percent);
    return percent;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScoresArg;
    bool isConnected = context.watch<InternetProvider>().isConnected;
    final double percentage = calculatePercent(args);
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
          title: Text("Results"),
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 120,
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        height: 120,
                        width: 120,
                        child: CircularProgressIndicator(
                          strokeWidth: 10,
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(Color(0xFFFF7801)),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        double.parse((percentage).toStringAsFixed(2))
                            .toString(),
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "You Scored ${args.correctAns * 10} out of ${args.mcqs.length * 10}.",
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, HomePage.route, (r) => false);
                },
                child: Text(
                  "Go Back To Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF7801),
                  padding: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

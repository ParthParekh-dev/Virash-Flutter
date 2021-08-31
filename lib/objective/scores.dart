import 'package:flutter/material.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:provider/provider.dart';

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
      return Container(
        child: null,
      );
    }
  }
}

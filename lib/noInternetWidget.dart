import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoInternetWidget extends StatefulWidget {
  @override
  _NoInternetWidgetState createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset('assets/nointernet.json'),
        ElevatedButton(
          onPressed: () {},
          child: Text('Refresh'),
        )
      ],
    );
  }
}

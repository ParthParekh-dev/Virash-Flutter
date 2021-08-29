import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_virash/homePage.dart';
import 'package:lottie/lottie.dart';

class PaymentSuccess extends StatelessWidget {
  static var route = '/paymentSuccess';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Lottie.asset('assets/paymentdone.json'),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.route, (r) => false);
          },
          child: Text('Okay'),
        )
      ],
    );
  }
}

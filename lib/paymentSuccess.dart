import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_virash/homePage.dart';

class PaymentSuccess extends StatelessWidget {
  static var route = '/paymentSuccess';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Payment Successfull'),
        MaterialButton(
          onPressed: () {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.route, (r) => false);
          },
          child: Text('OK'),
        )
      ],
    );
  }
}

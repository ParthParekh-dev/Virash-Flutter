import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Lottie.asset('assets/nodata.json')],
    );
  }
}

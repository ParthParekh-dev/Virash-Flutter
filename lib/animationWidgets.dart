import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationWidgets {
  Widget noInternet = Container(
    child: Center(
      child: Column(
        children: [
          Lottie.asset('assets/nointernet.json'),
          Text("Check Your Internet Connection And Try Again!")
        ],
      ),
    ),
  );

  Widget noData = Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Lottie.asset('assets/nodata.json'), Text('No Data Found')],
    ),
  );
}

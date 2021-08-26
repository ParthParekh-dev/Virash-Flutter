import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimationWidgets {
  Widget noInternet = Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Lottie.asset('assets/nointernet.json'),
        ElevatedButton(
          onPressed: () {},
          child: Text('Refresh'),
        )
      ],
    ),
  );

  Widget noData = Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Lottie.asset('assets/nodata.json'), Text('No Data Found')],
    ),
  );
}

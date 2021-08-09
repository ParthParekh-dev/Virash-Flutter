import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

import 'loginPage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SplashScreenView(
      navigateRoute: LoginPage(),
      duration: 3000,
      imageSize: 250,
      imageSrc: "assets/logo_unique.png",
      backgroundColor: Colors.white,
    ));
  }
}

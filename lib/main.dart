import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_virash/liveSession.dart';
import 'package:flutter_virash/shopCourse.dart';
import 'package:flutter_virash/studyMaterial.dart';
import 'package:flutter_virash/testSeries.dart';

import 'homePage.dart';
import 'loginPage.dart';
import 'addAssignment.dart';
import 'splash.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Color(0xFF3B6AA2),
          appBarTheme: AppBarTheme(
            color: Color(0xFF133157),
          )),
      debugShowCheckedModeBanner: false,
      home: Splash(),
      initialRoute: '/',
      routes: {
        LoginPage.route: (context) => LoginPage(),
        HomePage.route: (context) => HomePage(),
        AddAssignment.route: (context) => AddAssignment(),
        TestSeries.route: (context) => TestSeries(),
        LiveSession.route: (context) => LiveSession(),
        StudyMaterial.route: (context) => StudyMaterial(),
        ShopCourse.route: (context) => ShopCourse()
      },
    ),
  );
}

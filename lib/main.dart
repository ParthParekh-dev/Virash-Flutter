import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_virash/liveSession.dart';
import 'package:flutter_virash/objectiveTest.dart';
import 'package:flutter_virash/productList.dart';
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
          scaffoldBackgroundColor: Color(0xFFFFFFFF),
          appBarTheme: AppBarTheme(
            color: Color(0xFFFF7801),
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
        ShopCourse.route: (context) => ShopCourse(),
        ProductList.route: (context) => ProductList(),
        ObjectiveTest.route: (context) => ObjectiveTest(),
      },
    ),
  );
}

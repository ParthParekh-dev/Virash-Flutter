import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_virash/chapterList.dart';
import 'package:flutter_virash/examList.dart';
import 'package:flutter_virash/cartDataType.dart';
import 'package:flutter_virash/examStrategy.dart';
import 'package:flutter_virash/liveSession.dart';
import 'package:flutter_virash/newUserRegistration.dart';
import 'package:flutter_virash/objective/mcqList.dart';
import 'package:flutter_virash/objective/mcq.dart';
import 'package:flutter_virash/objective/scores.dart';
import 'package:flutter_virash/objectiveTest.dart';
import 'package:flutter_virash/paymentSuccess.dart';
import 'package:flutter_virash/pdfViewer.dart';
import 'package:flutter_virash/productDetail.dart';
import 'package:flutter_virash/productList.dart';
import 'package:flutter_virash/providers/cart_provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:flutter_virash/providers/objective_provider.dart';
import 'package:flutter_virash/shopCourse.dart';
import 'package:flutter_virash/showCart.dart';
import 'package:flutter_virash/studyMaterial.dart';
import 'package:flutter_virash/subjectList.dart';
import 'package:flutter_virash/testSeries.dart';
import 'package:flutter_virash/whatsappForm.dart';
import 'package:flutter_virash/verifyOTP.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'addAssignment.dart';
import 'splash.dart';
import 'strategyExamList.dart';

main() async {
  await getSharedPref();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => InternetProvider()),
      ChangeNotifierProvider(create: (_) => ObjectiveProvider())
    ],
    child: MaterialApp(
      theme: ThemeData(
          fontFamily: 'Poppins',
          scaffoldBackgroundColor: Color(0xFFFFFFFF),
          appBarTheme: AppBarTheme(
            color: Color(0xFF00008B),
            brightness: Brightness.dark,
          ),
          textSelectionTheme:
              TextSelectionThemeData(cursorColor: Color(0xFF00008B))),
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
        ShowCart.route: (context) => ShowCart(),
        ObjectiveTest.route: (context) => ObjectiveTest(),
        WhatsappForm.route: (context) => WhatsappForm(),
        OTPVerificationScreen.route: (context) => OTPVerificationScreen(),
        NewUserRegistration.route: (context) => NewUserRegistration(),
        ExamList.route: (context) => ExamList(),
        SubjectList.route: (context) => SubjectList(),
        ChapterList.route: (context) => ChapterList(),
        PdfViewer.route: (context) => PdfViewer(),
        StrategyExamList.route: (context) => StrategyExamList(),
        ExamStrategy.route: (context) => ExamStrategy(),
        ProductDetail.route: (context) => ProductDetail(),
        PaymentSuccess.route: (context) => PaymentSuccess(),
        ObjectiveMCQList.route: (context) => ObjectiveMCQList(),
        ObjectiveMCQ.route: (context) => ObjectiveMCQ(),
        ObjectiveScores.route: (context) => ObjectiveScores()
      },
    ),
  ));
}

Future<void> getSharedPref() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('cartList')) {
    final String encodedData = CartPojo.encode([]);
    await prefs.setString('cartList', encodedData);
  }
  if (!prefs.containsKey('mobile')) {
    prefs.setString('mobile', '');
  }
  if (!prefs.containsKey('email')) {
    prefs.setString('email', '');
  }
  if (!prefs.containsKey('name')) {
    prefs.setString('name', '');
  }
  if (!prefs.containsKey('course_id')) {
    prefs.setString('course_id', '');
  }
  if (!prefs.containsKey('exam_id')) {
    prefs.setString('exam_id', '');
  }
  if (!prefs.containsKey('subject_id')) {
    prefs.setString('subject_id', '');
  }
  if (!prefs.containsKey('chapter_id')) {
    prefs.setString('chapter_id', '');
  }
  if (!prefs.containsKey('user_id')) {
    prefs.setString('user_id', '');
  }
  if (!prefs.containsKey('isLoggedIn')) {
    prefs.setBool('isLoggedIn', false);
  }
}

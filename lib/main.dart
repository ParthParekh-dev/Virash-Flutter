import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_virash/cartDataType.dart';
import 'package:flutter_virash/liveSession.dart';
import 'package:flutter_virash/objectiveTest.dart';
import 'package:flutter_virash/productList.dart';
import 'package:flutter_virash/shopCourse.dart';
import 'package:flutter_virash/showCart.dart';
import 'package:flutter_virash/studyMaterial.dart';
import 'package:flutter_virash/testSeries.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homePage.dart';
import 'loginPage.dart';
import 'addAssignment.dart';
import 'splash.dart';

main() async {
  await getSharedPref();

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
        ShowCart.route: (context) => ShowCart(),
        ObjectiveTest.route: (context) => ObjectiveTest(),
      },
    ),
  );
}

Future<void> getSharedPref() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  if (!prefs.containsKey('cartList')) {
    final String encodedData = CartPojo.encode([]);
    await prefs.setString('cartList', encodedData);
    print(CartPojo.decode(prefs.getString('cartList')!));
  } else {
    print(CartPojo.decode(prefs.getString('cartList')!));
  }
}

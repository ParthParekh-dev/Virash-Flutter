// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_virash/animationWidgets.dart';
import 'package:flutter_virash/examList.dart';
import 'package:flutter_virash/exitPopup.dart';
import 'package:flutter_virash/logoutPopup.dart';
// import 'package:flutter_virash/loginPage.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:flutter_virash/shopCourse.dart';
import 'package:flutter_virash/strategyExamList.dart';
import 'package:flutter_virash/whatsappForm.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static var route = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var sliderImage = [];
  var imageUrl =
      "https://virashtechnologies.com/unique/img/slider/slider_1630441324.jpg";

  @override
  void initState() {
    super.initState();
    getSlider();
    context.read<InternetProvider>().startMonitoring();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = context.watch<InternetProvider>().isConnected;
    return WillPopScope(
      onWillPop: () => showExitPopup(context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            'Unique Commerce Academy',
            style: TextStyle(
              fontSize: 17,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                showLogoutPopup(context);
              },
              icon: Icon(Icons.power_settings_new_outlined),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isConnected
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                height: 180,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: FutureBuilder(
                                  future: getSlider(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.data == null) {
                                      return Container(
                                        child: Center(
                                          child: SpinKitFadingCircle(
                                            color: Color(0xFF00008B),
                                            size: 50.0,
                                          ),
                                        ),
                                      );
                                    } else {
                                      return CarouselSlider(
                                        options: CarouselOptions(
                                          autoPlay: true,
                                          autoPlayCurve: Curves.fastOutSlowIn,
                                          // enableInfiniteScroll: false,
                                          enlargeCenterPage: true,
                                        ),
                                        items: [
                                          ...List.generate(
                                            snapshot.data.length,
                                            (index) => Card(
                                              elevation: 5,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 8),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: Image.network(
                                                  snapshot.data[index],
                                                  fit: BoxFit.fill,
                                                  // width: double.infinity,
                                                  // height: 100,
                                                ),
                                              ),
                                            ),
                                            // Container(
                                            //   width: MediaQuery.of(context)
                                            //       .size
                                            //       .width,
                                            //   // margin: EdgeInsets.symmetric(
                                            //   //     horizontal: 5.0),
                                            //   decoration: BoxDecoration(
                                            //     color: Colors.amber,
                                            //     borderRadius:
                                            //         BorderRadius.circular(8.0),
                                            //   ),
                                            //   child: ,
                                            // ),
                                          )
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, ExamList.route,
                                              arguments: "live_session");
                                        },
                                        child: MainCard(
                                            title: 'Recorded Sessions',
                                            subTitle: '7k+',
                                            childIcon: 'assets/live.png'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, ShopCourse.route);
                                        },
                                        child: MainCard(
                                            title: 'Buy Course',
                                            subTitle: '50+',
                                            childIcon: 'assets/course.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, ExamList.route,
                                              arguments: "study_material");
                                        },
                                        child: MainCard(
                                            title: 'Study Material',
                                            subTitle: '14k+',
                                            childIcon: 'assets/material.png'),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.pushNamed(
                                          //     context, TestSeries.route);
                                          Navigator.pushNamed(
                                              context, ExamList.route,
                                              arguments: "test_series");
                                        },
                                        child: MainCard(
                                            title: 'MCQ\'s',
                                            subTitle: '700+',
                                            childIcon: 'assets/test.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                                context, WhatsappForm.route);
                                          },
                                          child: MainCard(
                                              title: 'Whatsapp Groups',
                                              subTitle: '70+',
                                              childIcon: 'assets/whatsapp.png'),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, StrategyExamList.route);
                                        },
                                        child: MainCard(
                                            title: 'Exam Strategy',
                                            subTitle: '14k+',
                                            childIcon: 'assets/strategy.png'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/v1.png",
                                      fit: BoxFit.fill,
                                      // width: double.infinity,
                                      // height: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/v2.png",
                                      fit: BoxFit.fill,
                                      // width: double.infinity,
                                      // height: 100,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Card(
                                  elevation: 5,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      "assets/v3.png",
                                      fit: BoxFit.fill,
                                      // width: double.infinity,
                                      // height: 100,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : AnimationWidgets().noInternet,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List<dynamic>> getSlider() async {
    Response response = await get(
      Uri.parse('https://virashtechnologies.com/unique/api/slider.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var result = json.decode(response.body);

    var apiList = [];

    for (var i in result) {
      apiList.add(i['slider_image']);
    }

    return apiList;
  }
}

class MainCard extends StatelessWidget {
  MainCard(
      {required this.childIcon, required this.title, required this.subTitle});

  final String childIcon;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 120,
          width: MediaQuery.of(context).size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Card(
              color: Color(0xFFFFFFFF),
              elevation: 20,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    Text(
                      subTitle,
                      style: TextStyle(
                          fontFamily: 'Poppins-SemiBold',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Align(
          // alignment: Alignment.topLeft,
          alignment: const Alignment(1, -1.0),
          child: Card(
            elevation: 5,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              alignment: Alignment.center,
              width: 50,
              height: 50,
              child: Image.asset(
                childIcon,
                fit: BoxFit.contain,
                width: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class Slider {
  final String id;
  final String image;

  Slider(this.id, this.image);
}

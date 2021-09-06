import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_virash/homePage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:flutter_virash/providers/internet_provider.dart';
import 'package:flutter_virash/animationWidgets.dart';

import 'verifyOTP.dart';

class NewUserRegistration extends StatefulWidget {
  static var route = '/newRegister';
  @override
  _NewUserRegistrationState createState() => _NewUserRegistrationState();
}

class _NewUserRegistrationState extends State<NewUserRegistration> {
  String name = "", mobile = "", email = "";
  Widget signinChild = SignInButton();
  List _courses = [];
  var course;

  void showLoader() {
    setState(() {
      signinChild = Spinner();
    });
  }

  void hideLoader() {
    setState(() {
      signinChild = SignInButton();
    });
  }

  Future<String> fetchCourse() async {
    final url = "https://virashtechnologies.com/unique/api/course.php";
    var res = await get(Uri.parse(url));
    final resBody = jsonDecode(res.body) as List;
    setState(() {
      _courses = resBody;
    });
    return "Success";
  }

  @override
  void initState() {
    super.initState();
    context.read<InternetProvider>().startMonitoring();
    fetchCourse();
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected = context.watch<InternetProvider>().isConnected;
    if (!isConnected) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AnimationWidgets().noInternet,
        )),
      );
    } else {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: SafeArea(
          child: Scaffold(
              body: Stack(
            children: [
              Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: PageScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height*0.20,
                        child: Lottie.asset('assets/login.json'),),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'New User Registration',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: TextField(
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            name = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFF00008B)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            mobile = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFF00008B)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            labelText: 'Mobile',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: TextField(
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            email = value;
                          },
                          decoration: InputDecoration(
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFF00008B)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                            ),
                            fillColor: Colors.white,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 30),
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 15),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black.withOpacity(0.6),
                                  width: 1),
                              borderRadius: BorderRadius.circular(40)),
                          child: DropdownButton<int>(
                            isExpanded: true,
                            value: course,
                            hint: Text(
                              "Select Course",
                              style: TextStyle(
                                fontFamily: 'Poppins',
                              ),
                            ),
                            items: _courses.map(
                              (course) {
                                return DropdownMenuItem(
                                  child: Text(
                                    course['course_name'],
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: course['course_id'] as int,
                                );
                              },
                            ).toList(),
                            onChanged: (int? value) {
                              setState(() {
                                course = value ?? 0;
                              });
                            },
                          ),
                        ),
                      ),
                      // DropdownButton<String>(
                      //   items: course_id.map((String val) {
                      //     return new DropdownMenuItem<String>(
                      //       value: val,
                      //       child: new Text(val),
                      //     );
                      //   }).toList(),
                      //   onChanged: (newVal) {
                      //     setState(() {
                      //       _mySelection = newVal.toString();
                      //     });
                      //   },
                      //   value: _mySelection,
                      // ),
                      SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (name == "" ||
                              email == "" ||
                              mobile == "" ||
                              course == null ||
                              mobile.length != 10) {
                            Fluttertoast.showToast(
                                msg:
                                    'Please enter the all the fields correctly',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.SNACKBAR,
                                timeInSecForIosWeb: 2);
                          } else {
                            register(name, mobile, email, course);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF00008B),
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(5.0),
                          ),
                        ),
                        child: signinChild,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
        ),
      );
    }
  }

  void register(String name, String mobile, String email, int course) async {
    showLoader();
    Response response = await post(
      Uri.parse(
          'https://virashtechnologies.com/unique/api/user-registration.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {
          "name": name,
          "mobile_number": mobile,
          "email": email,
          "course": "$course"
        }
      ]),
    );
    print(response.body);
    if (response.statusCode == 200) {
      hideLoader();
      var success = (json.decode(response.body)[0]['success']);
      if (success == "1") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('name', name);
        prefs.setString('mobile', mobile);
        prefs.setString('email', email);
        prefs.setString('course_id', "$course");

        Navigator.pushReplacementNamed(context, OTPVerificationScreen.route,
            arguments: mobile);
      } else {
        Fluttertoast.showToast(
            msg: "User Already Exists",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 2);
      }
    } else {
      hideLoader();
      Fluttertoast.showToast(
          msg: "Registration Unsuccessful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    }
  }
}

class SignInButton extends StatelessWidget {
  const SignInButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        "Register",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class Spinner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 25.0,
        ),
      ),
    );
  }
}

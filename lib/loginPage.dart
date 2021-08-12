import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_virash/homePage.dart';
import 'package:flutter_virash/newUserRegistration.dart';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static var route = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String mobile = "";
  Widget loginChild = LoginButton();

  void showLoader() {
    setState(() {
      loginChild = Spinner();
    });
  }

  void hideLoader() {
    setState(() {
      loginChild = LoginButton();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                  Hero(
                    tag: "HeroOne",
                    child: Image.asset('assets/logo_unique.png'),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'To continue with your account',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF37DBFF),
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
                          borderSide:
                              BorderSide(width: 2, color: Color(0xFFFF7801)),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        labelText: 'Mobile number',
                        labelStyle: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (mobile == "") {
                        Fluttertoast.showToast(
                            msg: 'Please enter the mobile number',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 2);
                      } else {
                        verifyUser(mobile);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFF7801),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                    child: loginChild,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: 1,
                    margin: EdgeInsets.only(top: 8),
                    color: Color(0xFFFFFFFFF),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: Color(0xFFFF7801),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, NewUserRegistration.route);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFFFF7801),
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  void verifyUser(String mobile_no) async {
    showLoader();
    Response response = await post(
      Uri.parse('https://virashtechnologies.com/unique/api/user-login.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"mobile_number": mobile_no}
      ]),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      var result = json.decode(response.body)[0];

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_id', result['user_id'].toString());
      prefs.setString('name', result['name'].toString());
      prefs.setString('mobile', result['mobile_number'].toString());
      prefs.setString('email', result['email'].toString());
      prefs.setString('course_id', result['course'].toString());
      prefs.setBool('isLoggedIn', true);

      var success = (json.decode(response.body)[0]['success']);
      hideLoader();
      if (success == "1") {
        Navigator.of(context).pushNamedAndRemoveUntil(
            HomePage.route, (Route<dynamic> route) => false);
      } else {
        Fluttertoast.showToast(
            msg: "Seems like you aren't registered user. Please Sign In",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 2);
      }
    } else {
      hideLoader();
      Fluttertoast.showToast(
          msg:
              "Something went wrong, couldn't find the user. Please contact admin.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          timeInSecForIosWeb: 2);
    }
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Text(
        "Log In",
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  static var route = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isObscure = true;
  late String username, password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Lottie.asset(
              'assets/backbubbles.json',
              fit: BoxFit.fitWidth,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Lottie.asset('assets/backbubbles.json'),
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: PageScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "HeroOne",
                    child: FaIcon(
                      FontAwesomeIcons.skyatlas,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      'Virash',
                      style: TextStyle(
                          fontFamily: 'Poppinsbold', color: Colors.white),
                    ),
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
                          color: Colors.white,
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
                      cursorColor: Colors.black,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        username = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: Colors.black54,
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
                        password = value;
                      },
                      obscureText: isObscure,
                      decoration: InputDecoration(
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 2, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        fillColor: Colors.white,
                        floatingLabelBehavior: FloatingLabelBehavior.never,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        suffixIcon: IconButton(
                          padding: EdgeInsets.only(right: 20),
                          icon: Icon(
                            isObscure ? Icons.visibility : Icons.visibility_off,
                            color: Color(0xFF3B6AA2),
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '?Forgot Password',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/home');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF133157),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: Text(
                        "Log In",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
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
                      'Sign In with: ',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: NeumorphicButton(
                          onPressed: () {
                            print("onClick");
                          },
                          style: NeumorphicStyle(
                            color: Color(0xFF3B6AA2),
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            boxShape: NeumorphicBoxShape.circle(),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.snapchatGhost,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: NeumorphicButton(
                          onPressed: () {
                            print("onClick");
                          },
                          style: NeumorphicStyle(
                            color: Color(0xFF3B6AA2),
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            boxShape: NeumorphicBoxShape.circle(),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.google,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: NeumorphicButton(
                          onPressed: () {
                            print("onClick");
                          },
                          style: NeumorphicStyle(
                            color: Color(0xFF3B6AA2),
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            boxShape: NeumorphicBoxShape.circle(),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.twitter,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: NeumorphicButton(
                          onPressed: () {
                            print("onClick");
                          },
                          style: NeumorphicStyle(
                            color: Color(0xFF3B6AA2),
                            shape: NeumorphicShape.flat,
                            depth: 3,
                            boxShape: NeumorphicBoxShape.circle(),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.facebookF,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF133157),
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
}

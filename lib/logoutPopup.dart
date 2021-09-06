// import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginPage.dart';

Future<void> showLogoutPopup(context) async {
  return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure, you want to log out?"),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setBool('isLoggedIn', false);
                        Navigator.pushNamedAndRemoveUntil(context,
                            LoginPage.route, (Route<dynamic> route) => false);
                      },
                      child: Text("Yes"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade800),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("No", style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                    ),
                  ))
                ],
              )
            ],
          ),
        );
      });
}

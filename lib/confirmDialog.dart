import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum ConfirmActions { yes, cancel }

class ConfirmDialog {
  static showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Remove"),
      onPressed: () {},
    ); // set up the AlertDialog
    CupertinoAlertDialog iosAlert = CupertinoAlertDialog(
      title: Text("Are You Sure?"),
      content: Text("Would you like to remove this item from your cart?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    AlertDialog androidAlert = AlertDialog(
      title: Text("Are You Sure?"),
      content: Text("Would you like to remove this item from your cart?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (Platform.isAndroid) {
          return androidAlert;
        } else {
          return iosAlert;
        }
      },
    );
  }
}



import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DialogUtil {

  static void showMessage(BuildContext context, String msg) {
    final snackbar = SnackBar(content: Text(msg), backgroundColor: Colors.blueAccent,);

    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  static void showToast(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 3,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0);

  }
}
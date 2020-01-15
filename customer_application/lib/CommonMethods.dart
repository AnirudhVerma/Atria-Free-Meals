import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonMethods {

  void toast(context, String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  int getEpochTime() {
    final epochTimeDate = DateTime(1970, 01, 01);
    var now = DateTime.now();
    var requestTime = now.difference(epochTimeDate).inSeconds;
    return requestTime;
  }

}

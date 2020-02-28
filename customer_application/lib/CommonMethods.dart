import 'package:customer_application/GlobalVariables.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'AesHelper.dart';

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

  String getTimeStamp(){
    DateTime now = new DateTime.now();
    DateTime date = new DateTime(now.year, now.month, now.day);
    String dayFormat = DateFormat('E MMM d y').format(date);
    String timeStamp = '$dayFormat ${now.toString().substring(11,19)} GMT + 0530(India Standard Time)';
    return timeStamp;
  }

  String getEncryptedRequestBeforeLogin(String dataTobeEncrypted, String phoneNumber){
    String data = """{ "ts": "${CommonMethods().getTimeStamp()}",
                    "username":"$phoneNumber", "data":"${encrypt(dataTobeEncrypted)}" }""";
    return data;
  }

  String getEncryptedRequestAfterLogin(dataTobeEncrypted){
    String data = """{ "ts": "${CommonMethods().getTimeStamp()}",
                    "username":"${GlobalVariables().phoneNumber}", "data":"${encrypt(dataTobeEncrypted)}" }""";
    return data;
  }

}

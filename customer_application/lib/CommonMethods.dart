import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonMethods{

  void toast(context, String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }

}
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'BookService.dart';
import 'CommonMethods.dart';
import 'GlobalVariables.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'networkConfig.dart';

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {

  String _date = "Not set";
  String _toDate = 'Not Set';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('Request Account Statement',  style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),),
      elevation: 5.0,
      shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(6))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 15,),
          Text('Request Account Statement', style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),),
          SizedBox(height: 15,),
          Center(
            //padding: EdgeInsets.all(15.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showDatePicker(context,

                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            onChanged: (date) {
                              print('confirm $date');
                              _date = '${date.year} - ${date.month} - ${date.day}';
                              setState(() {
                                _date = '${date.year} - ${date.month} - ${date.day}';
                              });
                            },
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            maxTime: DateTime(2022, 12, 31),
                            onConfirm: (date) {
                              print('confirm $date');
                              _date = '${date.year} - ${date.month} - ${date.day}';
                              setState(() {
                                _date = '${date.year} - ${date.month} - ${date.day}';
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.en,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "From",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          " $_date",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20.0,width: 500,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true,
                              minTime: DateTime(2000, 1, 1),
                              maxTime: DateTime(2022, 12, 31), onConfirm: (date) {
                                print('confirm $date');
                                _toDate = '${date.year} - ${date.month} - ${date.day}';
                                setState(() {});
                              }, currentTime: DateTime.now(), locale: LocaleType.en);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "To",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          " $_toDate",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                minWidth: 100,
                child: Text('CANCEL', style: TextStyle(color: Colors.blue, ),),
                onPressed: () {
                  Navigator.pop(context);
                  /* ... */ },
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                minWidth: 100,
                color: Colors.blue,
                child: Text('PROCEED', style: TextStyle(color: Colors.white, ),),
                onPressed: () {
                  if(_date == 'Not set' || _toDate == 'Not set'){
                    CommonMethods().toast(context, 'Please Select Date');
                  }
                  else{
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) =>
                                BookService( )));
                  }
                  /* ... */ },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
import 'dart:convert';

import 'package:customer_application/CreateTextField.dart';
import 'package:customer_application/DatePickerButton.dart';
import 'package:customer_application/MyAlertDialog.dart';
import 'package:customer_application/repository.dart';
import 'package:dio/dio.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'BookService.dart';
import 'CommonMethods.dart';
import 'CommonMethods.dart';
import 'CreateDropDown.dart';
import 'GlobalVariables.dart';
import 'JSONResponseClasses/ComplaintList.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'book_service/book_service_bloc.dart';
import 'networkConfig.dart';

class CreateGrievanceUI extends StatefulWidget {

  CreateGrievanceUI();

  @override
  _CreateGrievanceUIState createState() => new _CreateGrievanceUIState();
}

class _CreateGrievanceUIState extends State<CreateGrievanceUI> {


  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 20,
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 300,
              ),
//            CreateDropDown(myJson: convertOutputToMap2(GlobalVariables().myComplaintList.oUTPUT),),
             /* EnhancedFutureBuilder(
                rememberFutureResult: true,
                future: Repository().getComplaintList(),
                whenNotDone: CircularProgressIndicator(),
                whenDone: (dynamic data){
                  return CreateDropDown(myJson: convertOutputToMap2(data.oUTPUT));
                },
              ),*/
              Center(
                child: StreamBuilder(
                  stream: Repository().getComplaintList('System').asStream(),
                  builder: (context, complaintListSnapshot){
                    if (!complaintListSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(complaintListSnapshot.hasError){
                      return Text('${complaintListSnapshot.error}\nSome error occured');
                    }
                    else{
                      CommonMethods().toast(context, complaintListSnapshot.data.toString());
                      return CreateDropDownGrievance(myJson: convertOutputToMap2(complaintListSnapshot.data.oUTPUT));
                    }

                  },
                ),
              ),
              new TextField(
                expands: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Booking ID',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              new TextField(
                  expands: false,
                  maxLines: 5,
                  minLines: 5,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Remarks',
                  )
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: CupertinoButton(
                    child: Text(
                      'Lodge Grievance',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: Repository().logout,
                    color: Colors.blue,
                  )),
            ],
          ),
        ));
  }

  List<Map> convertOutputToMap2(List<OUTPUT2> ml) {

    List<Map> listOfMap = [];
    for (var listObject in ml) {
      Map myMap1 = new Map();
      myMap1['name'] = listObject.complaintList;
      myMap1['value'] = listObject.complaintList;
      listOfMap.add(myMap1);
      myMap1 = null;
    }
    return listOfMap;
  }

}
import 'dart:convert';

import 'package:customer_application/CreateTextField.dart';
import 'package:customer_application/DatePickerButton.dart';
import 'package:customer_application/MyAlertDialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

import 'BookService.dart';
import 'CommonMethods.dart';
import 'CreateDropDown.dart';
import 'GlobalVariables.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'networkConfig.dart';

class CustomParamsDialog extends StatefulWidget {

  CustomParamsDialog({this.selectedService});
  OUTPUT selectedService;

  @override
  _CustomParamsDialogState createState() => new _CustomParamsDialogState();
}

class _CustomParamsDialogState extends State<CustomParamsDialog> {

//  String _date = "Not set";
//  String _toDate = 'Not Set';

  @override
  Widget build(BuildContext context) {
    return MyAlertDialog(
      // title: Text('Request Account Statement',  style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),),
      elevation: 5.0,
      shape: RoundedRectangleBorder(side: BorderSide.none, borderRadius: BorderRadius.all(Radius.circular(6))),
      content: SingleChildScrollView(
        child: Material(
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Text(
                  '${widget.selectedService.servicename}',
                  style: TextStyle(
                      color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 25,
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 500,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                        constraints: BoxConstraints(
                          maxHeight: 400,
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.selectedService.customParams.length,
                          itemBuilder: (BuildContext context, int index) {
                            CustomParams mCust =
                            widget.selectedService.customParams[index];
                            RegExp regex = new RegExp(widget.selectedService.customParams[index].rEGEX);
                            GlobalVariables().listOfParams = new List(widget.selectedService.customParams.length);
                            if (mCust.dATATYPE == 'LIST') {
                              print(mCust.lIST);
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Text('${mCust.nAME}  '),
//                            dropDown(convertListToMap(mCust.lIST)),
                                  new CreateDropDown(myJson: convertListToMap(mCust.lIST), position: int.parse(widget.selectedService.customParams[index].sEQUENCE, ),nameInMap: mCust.nAME,),
                                ],
                              );
                            }
                            if (mCust.dATATYPE == 'DOUBLE' || mCust.dATATYPE == 'NAMESTRING' || mCust.dATATYPE == 'NUMBER' || mCust.dATATYPE == 'alphanumeric') {
                              return Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
//                                  Text('${mCust.nAME}  '),
                                      Expanded(child: CreateTextField(hint: mCust.nAME, position: int.parse(widget.selectedService.customParams[index].sEQUENCE), regex: regex,)),
                                    ],
                                  ),
                                  SizedBox(height: 10,)
                                ],
                              );
                            }
                            if (mCust.dATATYPE == 'DATE') {
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 10.0,
                                    width: 500,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text('${mCust.nAME}  '),
                                      new DatePickerButton(position: int.parse(widget.selectedService.customParams[index].sEQUENCE)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                    width: 500,
                                  )
                                ],
                              );
                            }
                            return ListTile(
                              title: Text(
                                  'The service name is ${widget.selectedService.servicename}'),
                            );//Container(child: Text('Hello ${index}'),);
                          },
                        )
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      minWidth: 100,
                      child: Text(
                        'CANCEL',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        /* ... */
                      },
                    ),
                    MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      minWidth: 100,
                      color: Colors.blue,
                      child: Text(
                        'PROCEED',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {

                        if (allParamsFilled()) {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              new CupertinoPageRoute(
                                  builder: (context) => BookService()));
                      }
                        else{
                          CommonMethods().toast(context, 'Please fill all the Mandatory fields!');
                          /*Navigator.pop(context);
                          Navigator.push(
                              context,
                              new CupertinoPageRoute(
                                  builder: (context) => BookService()));*/
                        }
                        /* ... */
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField(String hint){
    return TextFormField(
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: hint,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
    );
  }

  List<Map> convertListToMap(List<LIST> ml){

    List<Map> _myJson = [{"name":"1", "value":"1"},{"name":"2", "value":"2"},{"name":"3", "value":"3"},{"name":"4", "value":"4"},{"name":"5", "value":"Five"}];

    var myMap = new Map();
    List<Map> listOfMap = [];
    for( var listObject in ml ){
      Map myMap1 = new Map();
      myMap1['name'] = listObject.name;
      myMap1['value'] = listObject.value;
      listOfMap.add(myMap1);
//      myMap.clear();
      myMap1 = null;
    }
//    listOfMap.add(myMap);
    return listOfMap;
  }

  bool allParamsFilled(){
    int count = 0;
    for(Map m in GlobalVariables().listOfParams){
      if (m == null){
        count++;
        print('The number of maps in list is $count');
        return false;
      }
      else return true;
    }
  }

}
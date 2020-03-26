import 'package:customer_application/CommonMethods.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'JSONResponseClasses/ComplaintList.dart';

class CreateDropDown extends StatefulWidget {

  List<Map> myJson;
  int position;
  String nameInMap;

  CreateDropDown({this.myJson, this.position, this.nameInMap});

  @override
  _CreateDropDownState createState() => new _CreateDropDownState();
}

class _CreateDropDownState extends State<CreateDropDown> {

  String _mySelection;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isDense: false,
      hint: new Text("Select"),
      value: _mySelection,
      onChanged: (String newValue) {
        Map myMap = new Map();
        myMap['name'] = widget.nameInMap;
        myMap['value'] = newValue;
        GlobalVariables().listOfParams[widget.position - 1] = myMap;
        CommonMethods().printLog(widget.myJson.toString());
        CommonMethods().toast(context, widget.myJson.toString());
        setState(() {
          _mySelection = newValue;
          /*Map myMap = new Map();
          myMap['name'] = widget.nameInMap;
          myMap['value'] = _mySelection;
          GlobalVariables().listOfParams.insert(widget.position - 1, myMap);
          CommonMethods().printLog('******************** The selected value is $_mySelection');*/
        });
      },
      items: widget.myJson.map((Map map) {
        return new DropdownMenuItem<String>(
          value: map["value"].toString(),
          child: Text(map['name'].toString()),
          /*child: new Text(
            map["value"],
          ),*/
        );
      }).toList(),

    );
  }

}

class CreateDropDownGrievance extends StatefulWidget {

  List<Map> myJson;

  CreateDropDownGrievance({this.myJson});

  @override
  _CreateDropDownGrievanceState createState() => new _CreateDropDownGrievanceState();
}

class _CreateDropDownGrievanceState extends State<CreateDropDownGrievance> {

  String _mySelection;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isDense: false,
      hint: new Text("Select"),
      value: _mySelection,
      onChanged: (String newValue) {
        Map myMap = new Map();
        myMap['name'] = newValue;
        myMap['value'] = newValue;
        CommonMethods().printLog(widget.myJson.toString());
        CommonMethods().toast(context, widget.myJson.toString());
        setState(() {
          _mySelection = newValue;
          /*Map myMap = new Map();
          myMap['name'] = widget.nameInMap;
          myMap['value'] = _mySelection;
          GlobalVariables().listOfParams.insert(widget.position - 1, myMap);
          CommonMethods().printLog('******************** The selected value is $_mySelection');*/
        });
      },
      items: widget.myJson.map((Map map) {
        return new DropdownMenuItem<String>(
          value: map["value"].toString(),
          child: Text(map['name'].toString()),
          /*child: new Text(
            map["value"],
          ),*/
        );
      }).toList(),

    );
  }

}
import 'package:customer_application/GlobalVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateHorizontalDropDown extends StatefulWidget {

  List<Map> myJson;

  CreateHorizontalDropDown({this.myJson});

  @override
  _CreateHorizontalDropDownState createState() => new _CreateHorizontalDropDownState();
}

class _CreateHorizontalDropDownState extends State<CreateHorizontalDropDown> {

  String _mySelection;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isDense: false,
      hint: new Text("Select"),
      value: _mySelection,
      onChanged: (String newValue) {
        /*Map myMap = new Map();
        myMap['name'] = widget.nameInMap;
        myMap['value'] = _mySelection;
        GlobalVariables().listOfParams[widget.position - 1] = myMap;*/
        setState(() {
          _mySelection = newValue;
          /*Map myMap = new Map();
          myMap['name'] = widget.nameInMap;
          myMap['value'] = _mySelection;
          GlobalVariables().listOfParams.insert(widget.position - 1, myMap);
          print('******************** The selected value is $_mySelection');*/
        });
      },
      items: widget.myJson.map((Map map) {
        return new DropdownMenuItem<String>(
          value: map["complaintType"].toString(),
          child: Text(map['complaintType'].toString()),
          /*child: new Text(
            map["value"],
          ),*/
        );
      }).toList(),

    );
  }
}
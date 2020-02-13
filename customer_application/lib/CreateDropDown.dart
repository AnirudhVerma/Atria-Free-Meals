import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateDropDown extends StatefulWidget {

  List<Map> myJson;

  CreateDropDown({this.myJson});

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
        setState(() {
          _mySelection = newValue;
          print('******************** The selected value is $_mySelection');
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
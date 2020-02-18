import 'package:customer_application/GlobalVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateTextField extends StatefulWidget{

  final String hint;
  final int position;
  final regex;

  CreateTextField({this.position, this.hint, this.regex});

  @override
  _CreateTextFieldState createState() => _CreateTextFieldState();
}

class _CreateTextFieldState extends State<CreateTextField> {

  bool _autovalidate = false;

  TextEditingController _controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      autovalidate: _autovalidate,
      onEditingComplete:() {
        setState(() {
          _autovalidate = true;
        });
      },
      onTap: (){
        setState(() {
          _autovalidate = true;
        });
      },
      validator: (input) {
        if (widget.regex.hasMatch(input) == false) {
          return 'Please Enter valid data!';
        }
        else if(input != '' && widget.regex.hasMatch(input)){
          Map myMap = new Map();
          myMap['name'] = widget.hint;
          myMap['value'] = input;
//          GlobalVariables().listOfParams.insert(widget.position - 1, myMap);
          GlobalVariables().listOfParams[widget.position - 1] = myMap;
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: widget.hint,
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(6.0))),
    );
  }
}
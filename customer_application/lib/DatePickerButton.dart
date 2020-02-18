import 'package:customer_application/GlobalVariables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class DatePickerButton extends StatefulWidget{

  int position;
  String nameInMap;

  DatePickerButton({this.position});

  @override
  _DatePickerButtonState createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {

  String _date = "Not set";

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0)),
      elevation: 4.0,
      onPressed: () {
        DatePicker.showDatePicker(
          context,
          theme: DatePickerTheme(
            containerHeight: MediaQuery.of(context).copyWith().size.height / 3,
            backgroundColor: Theme.of(context).backgroundColor,
            titleHeight: 24.0,
            itemHeight: 30.0,
            itemStyle: TextStyle(color: Colors.white),
          ),
          onChanged: (date) {
            print('confirm $date');
            _date = '${date.year}-${date.month}-${date.day}';
            Map myMap = new Map();
            myMap['name'] = widget.nameInMap;
            myMap['value'] = _date.toString();
            GlobalVariables().listOfParams.insert(widget.position - 1, myMap);
            setState(() {
              _date =
              '${date.year}-${date.month}-${date.day}';
            });
          },
          showTitleActions: true,
          minTime: DateTime(2000, 1, 1),
          maxTime: DateTime(2022, 12, 31),
          onConfirm: (date) {
            print('confirm $date');
            _date = '${date.year}-${date.month}-${date.day}';
            Map myMap = new Map();
            myMap['name'] = widget.nameInMap;
            myMap['value'] = _date.toString();
            GlobalVariables().listOfParams[widget.position - 1] = myMap;
            setState(() {
              _date =
              '${date.year}-${date.month}-${date.day}';
            });
          },
          currentTime: DateTime.now(),
          locale: LocaleType.en,
        );
      },
      child: Container(
        //color: Theme.of(context).backgroundColor,
        alignment: Alignment.center,
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            Text(
//              " From",
//              style: TextStyle(
//                  color: Colors.blue,
//                  fontWeight: FontWeight.bold,
//                  fontSize: 18.0),
//            ),
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
      color: Theme.of(context).backgroundColor,
    );
  }
}
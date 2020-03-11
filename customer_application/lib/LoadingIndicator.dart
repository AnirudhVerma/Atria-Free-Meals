import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatefulWidget {

  @override
  _LoadingIndicatorState createState() => _LoadingIndicatorState();
}

class _LoadingIndicatorState extends State<LoadingIndicator> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        //color: Colors.lightBlue,
        child: Center(
          //child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.blue),
          child: SpinKitWave(color: Colors.blue,size: 50,),
        ),
      ),
    );
  }
}

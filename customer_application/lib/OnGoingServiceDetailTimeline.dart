import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/IndividualServiceDetails.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GlobalVariables.dart';
import 'Timeline.dart';
import 'networkConfig.dart';

class OnGoingServiceDetailTimeline extends StatelessWidget {

  OnGoingServiceDetailTimeline({this.bookingID});

  final String bookingID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking $bookingID'),
      ),
      body: Timeline(
        children: <Widget>[
          Container(height: 100, child: Center(child: Text('Scheduled', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)), decoration: BoxDecoration( color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(5)),),
          Container(height: 100, child: Center(child: Text('Started', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)), decoration: BoxDecoration( color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(5)),),
          Container(height: 100, child: Center(child: Text('Document Picked', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)), decoration: BoxDecoration( color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(5)),),
          Container(height: 100, child: Center(child: Text('Document Submitted', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)), decoration: BoxDecoration( color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(5)),),
          Container(height: 100, child: Center(child: Text('Completed', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),)), decoration: BoxDecoration( color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(5)),),
        ],
        indicators: <Widget>[
          Icon(Icons.schedule, color: Colors.blue,),
          Icon(Icons.play_arrow),
          Icon(Icons.mail),
          Icon(Icons.check),
          Icon(Icons.done_all),
        ],
      ),
    );
  }

}

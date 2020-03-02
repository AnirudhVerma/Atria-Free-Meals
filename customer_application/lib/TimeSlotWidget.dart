//import 'dart:convert';
//
//import 'package:customer_application/JSONResponseClasses/BookingHistoryResponse.dart';
//import 'package:customer_application/OnGoingServiceDetail.dart';
//import 'package:customer_application/repository.dart';
//import 'package:dio/dio.dart';
//import 'package:enhanced_future_builder/enhanced_future_builder.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//import 'BookService.dart';
//import 'CommonMethods.dart';
//import 'GlobalVariables.dart';
//import 'JSONResponseClasses/ServiceList.dart';
//import 'networkConfig.dart';
//
//class TimeSlotWidget extends StatefulWidget {
//  @override
//  _TimeSlotWidgetState createState() => new _TimeSlotWidgetState();
//}
//
//class _TimeSlotWidgetState extends State<TimeSlotWidget> {
//
//  @override
//  Widget build(BuildContext context) {
//    var timeSlot;
//    return EnhancedFutureBuilder(
//      future: Repository().fetchTimeSlots(),
//      rememberFutureResult: true,
//      whenNotDone: Center(child: CircularProgressIndicator(),),
//      whenDone: (dynamic data) {
//        if (data.eRRORCODE !="00") {
//          CommonMethods().printLog('some error occured');
//          CommonMethods().printLog('project snapshot data is: ${data}');
//          return Center(
//            child: Text(
//                '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
//          );
//        } else {
//          return GridView.builder(
//            shrinkWrap: true,
//            itemCount: data.oUTPUT.length,
//            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//              crossAxisCount: 3,
//              crossAxisSpacing: 5.0,
//              mainAxisSpacing: 5.0,
//            ),
//            itemBuilder: (context, index) {
//              {
//                timeSlot = data.oUTPUT[index].slotnumber;
//                var avalabilityStatus = data.oUTPUT[index].avalabilityStatus;
//                CommonMethods().printLog('project snapshot data is: $data');
//
//                if(data.oUTPUT[index].avalabilityStatus != 'N')
//                  // if(index.isEven)
//                    {
//                  return MaterialButton(
//                    //title: Text(timeSlot),
//                    child: Center(
//                        child: Text(
//                          timeSlot,
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 20.0),
//                        )),
//                    color: Colors.blue[400],
//                    onPressed: () {
//                      timeSlot = data.oUTPUT[index].slotnumber;
//                      CommonMethods().toast(
//                          context, 'You tapped on ${timeSlot.toString()}');
//                      GlobalVariables().timeSlot = timeSlot;
//                      myBookServiceBloc.add(FetchLiamAccount());
//
//                    },
//                  );
//                }
//                else{
//                  return MaterialButton(
//                    color: Colors.pink,
//                    child: Center(
//                        child: Text(
//                          timeSlot,
//                          style: TextStyle(
//                              color: Colors.black54,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 20.0),
//                        )),
//                    onPressed: null,
//                  );
//                }
//                /*return MaterialButton(
//                    //title: Text(timeSlot),
//                    child: Center(
//                        child: Text(
//                          timeSlot,
//                          style: TextStyle(
//                              color: Colors.white,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 20.0),
//                        )),
//                    color: Colors.blue[400],
//                    onPressed: () {
//                      timeSlot = timeSlotSnapShot.data.oUTPUT[index].slotnumber;
//                      CommonMethods().toast(
//                          context, 'You tapped on ${timeSlot.toString()}');
//                      GlobalVariables().timeSlot = timeSlot;
//                      myBookServiceBloc.add(FetchLiamAccount());
//
//                    },
//                  );*/
//              }
//            },
//          );
//        }
//      },
//    );
//  }
//
//}

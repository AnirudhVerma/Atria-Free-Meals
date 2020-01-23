import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/IndividualServiceDetails.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'GlobalVariables.dart';
import 'networkConfig.dart';

class OnGoingServiceDetail extends StatelessWidget {

  OnGoingServiceDetail({this.bookingID});

  final String bookingID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: FutureBuilder(
        future: getBookingDetails(),
        builder: (context, bookingDetailSnapShot) {
          if (bookingDetailSnapShot.data == null) {
            print('The data is in loading state');
            print('project snapshot data is: ${bookingDetailSnapShot.data}');
            return Container(
              //child: CupertinoActivityIndicator(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/service-details.png'),
                  fit: BoxFit.cover,
                ),
              ),
              //child: CircularProgressIndicator(),
            );
          } else {
//          print('The data is loaded!!!!');
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Booking Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    Row(
                      children: <Widget>[
                        Text('Service Booking Detail', style: TextStyle(fontWeight: FontWeight.bold),),
                        Spacer(),
                        OutlineButton(
                          child: Text('View Details', style: TextStyle(color: Colors.blue),),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Service Name'),
                                SizedBox(height: 5,),
                                Text('Service Name', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Booking Id'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Account For Delivery Service'),
                                SizedBox(height: 5,),
                                Text('Account For Delivery Service', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Agent Name'),
                                SizedBox(height: 5,),
                                Text('Agent  Name', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Delivery Address'),
                                SizedBox(height: 5,),
                                Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Preferred Date'),
                                SizedBox(height: 5,),
                                Text('Preffered Date', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Preferred Time'),
                                SizedBox(height: 5,),
                                Text('Preffered Time', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Payment Account'),
                                SizedBox(height: 5,),
                                Text('Payment Account', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Service Charge'),
                                SizedBox(height: 5,),
                                Text('Service Charge', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Branch Name'),
                                SizedBox(height: 5,),
                                Text('Branch Name', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                      ),
                      elevation: 3,),
                    SizedBox(height: 20,),
                    Text('Additional Service Detail', style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Leaf Count'),
                                SizedBox(height: 5,),
                                Text('Credit Slip Filled'),
                                SizedBox(height: 10,),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Leaf Count', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text('Credit Slip Filled', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                      ),
                      elevation: 3,),
                    SizedBox(height: 20,),
                    Text('Other Details', style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Mobile'),
                                SizedBox(height: 5,),
                                Text('Request Date'),
                                SizedBox(height: 10,),
                                Text('Status'),
                                SizedBox(height: 10,),
                                Text('Auth Code'),
                                SizedBox(height: 10,),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text('Request Date', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Status', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text('Auth Code', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                              ],
                            ),
                          ],
                        ),
                      ),
                      elevation: 3,),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> getBookingDetails() async {

    String getServiceDetailsString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "username":"${GlobalVariables().phoneNumber}",
    "DEVICEID": "",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "bookingid":"$bookingID"
    }""";

    Response getServiceDetailsResponse = await NetworkCommon()
        .myDio
        .post("/getBookingDetails", data: getServiceDetailsString);
    var getServiceDetailsResponseString = jsonDecode(getServiceDetailsResponse.toString());
    var getServiceDetailsResponseObject =
    IndividualServiceDetails.fromJson(getServiceDetailsResponseString);
    //print("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    String id = getServiceDetailsResponseObject.serviceinfo[0].bookingid;

    return getServiceDetailsResponseObject;
    //print(accessToken);
  }

}

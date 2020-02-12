import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/IndividualServiceDetails.dart';
import 'package:customer_application/OnGoingServiceDetailTimeline.dart';
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
          if (bookingDetailSnapShot.data == null &&  bookingDetailSnapShot.connectionState == ConnectionState.waiting) {
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
              child: Center(child: CircularProgressIndicator()),
            );
          }
          else if (bookingDetailSnapShot.data == null &&  bookingDetailSnapShot.connectionState != ConnectionState.waiting) {
            print('The data is in loading state');
            print('project snapshot data is: ${bookingDetailSnapShot.data}');
            return Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/fogg-booking-history-1.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(child: Text('Couldn\'t connect to servers, please retry', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
            );
          }
          else {
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
                          onPressed: () => Navigator.push(context,
                              CupertinoPageRoute(builder: (context) => OnGoingServiceDetailTimeline(bookingID: bookingDetailSnapShot.data.serviceinfo[0].bookingid,)))
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
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].serviceName}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Booking Id'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].bookingid}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Account For Delivery Service'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].serviceAccount}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Agent Name'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.agentInfo[0].agentname}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
//                                Text('${bookingDetailSnapShot.data.serviceinfo[0].deliveryaddress}',textWidthBasis: Tex,),
                                SizedBox(height: 5,),
                                Text('', style: TextStyle(fontWeight: FontWeight.bold),),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Preferred Date'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].preferreddate}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Preferred Time'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].slottime}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Payment Account'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].lienMarkAccount}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Service Charge'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].serviceCharge}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('Branch Name'),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].branchname}', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].customParams[0].nAME}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].customParams[0].vALUE}', style: TextStyle(fontWeight: FontWeight.bold),),
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
                                Text('${GlobalVariables().phoneNumber}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].requestDate}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 10,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].sTATUS}', style: TextStyle(fontWeight: FontWeight.bold),),
                                SizedBox(height: 5,),
                                Text('${bookingDetailSnapShot.data.serviceinfo[0].authCodeCustomer}', style: TextStyle(fontWeight: FontWeight.bold),),
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

    return getServiceDetailsResponseObject;
  }

}

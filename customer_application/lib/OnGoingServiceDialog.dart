import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/BookingHistoryResponse.dart';
import 'package:customer_application/OnGoingServiceDetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BookService.dart';
import 'GlobalVariables.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'networkConfig.dart';

class OnGoingServiceDialog extends StatefulWidget {
  @override
  _OnGoingServiceDialogState createState() => new _OnGoingServiceDialogState();
}

class _OnGoingServiceDialogState extends State<OnGoingServiceDialog> {

  @override
  Widget build(BuildContext context) {
    var output;
    return FutureBuilder(
      future: getBookingHistory(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.data == null &&  servicesSnapShot.connectionState == ConnectionState.waiting) {
          print('The data is in loading state');
          print('project snapshot data is: ${servicesSnapShot.data}');
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fogg-booking-history-1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        else if (servicesSnapShot.data == null &&  servicesSnapShot.connectionState != ConnectionState.waiting) {
          print('The data is in loading state');
          print('project snapshot data is: ${servicesSnapShot.data}');
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fogg-booking-history-1.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Text('Looks like you don\'t have any On-Going Services'),
          );
        }
        else {
//          print('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data[index];
                print('project snapshot data is: ${servicesSnapShot.data}');
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: new Image(
                          image: new AssetImage(getIconPath(output.serviceName))),
                    ),
                    title: Text(output.serviceName, style: TextStyle(color: Colors.blue[800]),),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(output.preferreddate ),
                            SizedBox(width: 10,),
                            Text(output.slottime),
                          ],
                        ),
                        Text('Booking Id: ${output.bookingid}'),
                        Text('Status: ${output.sTATUS}'),
                      ],
                    ),trailing: Icon(Icons.arrow_forward_ios),
                    dense: true,
//                  subtitle: Text('Service Charge : ${output.serviceCharge}'),
                    onTap: () {
                      output = servicesSnapShot.data[index];
                      /*print('******************** THE OUTPUT IS ${output.toString()}');
                      GlobalVariables().userSelectedService = output;*/                   //unable to instantiate the userSelecteeService
                      /*GlobalVariables().serviceid = output.serviceid;
                      GlobalVariables().servicename = output.servicename;
                      GlobalVariables().servicetype = output.servicetype;
                      GlobalVariables().servicecategory = output.servicecategory;
                      GlobalVariables().serviceCharge = output.serviceCharge;
                      GlobalVariables().servicecode = output.servicecode;*/
                      //print('******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
                      Navigator.push(context, CupertinoPageRoute(builder: (context) => OnGoingServiceDetail(bookingID: output.bookingid,)));
                      String servicename;
                     /* Navigator.push(
                          context,
                          new CupertinoPageRoute(
                              builder: (context) =>
                                  BookService()));*/
                    },
                  ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
                elevation: 2.0,
                margin: EdgeInsets.all(2.0),);
              }
            },
          );
        }
      },
    );
  }

  String getIconPath(String serviceName){
    if (serviceName == 'Pickup Cheque instrument'){
      return 'assets/images/cheque.png';
    }
    if (serviceName == 'Request Account Statement'){
      return 'assets/images/bank-statement.png';
    }
  }

  Future<void> getBookingHistory() async {
    String getBookingHistoryString = """{
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
    "startindex":1,
   	"limit":10
    }""";

    Response getBookingHistoryResponse = await NetworkCommon()
        .myDio
        .post("/getBookingList", data: getBookingHistoryString);
    //print('The booking history request is ***********************  $getBookingHistoryString   ***************************************');
    var getBookingHistoryResponseString = jsonDecode(getBookingHistoryResponse.toString());
    var getBookingHistoryResponseObject =
    BookingHistoryResponse.fromJson(getBookingHistoryResponseString);
    //print("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    print("THE SERVICE RESPONSE IS ${getBookingHistoryResponseObject.oUTPUT.length}");

    var output = getBookingHistoryResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      print(
          '                SERVICE NAME IS $i : ${output[i].serviceName}             ');
      services.add(output[i].serviceName);
    }

    print('             THE SERVICES OFFERED ARE $services                 ');

    return output;
    //print(accessToken);
  }

}

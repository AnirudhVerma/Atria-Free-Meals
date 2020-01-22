import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/BookingHistoryResponse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BookService.dart';
import 'GlobalVariables.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'networkConfig.dart';

class CompletedServicesDialog extends StatefulWidget {
  @override
  _CompletedServicesDialogState createState() => new _CompletedServicesDialogState();
}

class _CompletedServicesDialogState extends State<CompletedServicesDialog> {

  @override
  Widget build(BuildContext context) {
    var output;
    return FutureBuilder(
      future: getBookingHistory(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.data == null) {
          print('The data is in loading state');
          print('project snapshot data is: ${servicesSnapShot.data}');
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fogg-booking-history-1.png'),
                fit: BoxFit.cover,
              ),
            ),
            //child: CircularProgressIndicator(),
          );
        } else {
//          print('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data[index];
                print('project snapshot data is: ${servicesSnapShot.data}');
                return ListTile(
                  title: Text(output.serviceName),
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
                    print('******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
                    String servicename;
                    /* Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) =>
                                BookService()));*/
                  },
                );
              }
            },
          );
        }
      },
    );
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
        .post("/getBookingHistory", data: getBookingHistoryString);
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

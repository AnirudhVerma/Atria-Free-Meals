import 'dart:convert';
import 'package:customer_application/JSONResponseClasses/BookingHistoryResponse.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'BookService.dart';
import 'CommonMethods.dart';
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
    return Container(
      constraints: BoxConstraints(
        minWidth: 360
      ),
      child: FutureBuilder(
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
              child: Center(child: CircularProgressIndicator(),),
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
              child: Text('Mm, Looks like you don\'t have any Completed Services',style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
            );
          }
          else {
//          CommonMethods().printLog('The data is loaded!!!!');
            return ListView.builder(
              itemCount: servicesSnapShot.data.length,
              itemBuilder: (context, index) {
                {
                  output = servicesSnapShot.data[index];
                  CommonMethods().printLog('project snapshot data is: ${servicesSnapShot.data}');
                  return ListTile(
                    title: Text(output.serviceName),
//                  subtitle: Text('Service Charge : ${output.serviceCharge}'),
                    onTap: () {
                      output = servicesSnapShot.data[index];
                      /*CommonMethods().printLog('******************** THE OUTPUT IS ${output.toString()}');
                      GlobalVariables().userSelectedService = output;*/                   //unable to instantiate the userSelecteeService
                      /*GlobalVariables().serviceid = output.serviceid;
                      GlobalVariables().servicename = output.servicename;
                      GlobalVariables().servicetype = output.servicetype;
                      GlobalVariables().servicecategory = output.servicecategory;
                      GlobalVariables().serviceCharge = output.serviceCharge;
                      GlobalVariables().servicecode = output.servicecode;*/
                      CommonMethods().printLog('******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
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
      ),
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
    "ts": "${CommonMethods().getTimeStamp()}",
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
    //CommonMethods().printLog("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // CommonMethods().printLog("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    CommonMethods().printLog("THE SERVICE RESPONSE IS ${getBookingHistoryResponseObject.oUTPUT.length}");

    var output = getBookingHistoryResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      CommonMethods().printLog(
          '                SERVICE NAME IS $i : ${output[i].serviceName}             ');
      services.add(output[i].serviceName);
    }

    CommonMethods().printLog('             THE SERVICES OFFERED ARE $services                 ');

    return getBookingHistoryResponseObject;
    //CommonMethods().printLog(accessToken);
  }

}

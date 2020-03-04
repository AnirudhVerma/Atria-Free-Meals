import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/BookingHistoryResponse.dart';
import 'package:customer_application/OnGoingServiceDetail.dart';
import 'package:dio/dio.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'BookService.dart';
import 'CommonMethods.dart';
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
    return EnhancedFutureBuilder(
      future: getBookingHistory(),
      rememberFutureResult: true,
      whenNotDone: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fogg-booking-history-1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: CircularProgressIndicator()),
      ),
      whenDone: (dynamic data) {
        if(data == null){
          return Center(
            child: Text(
                '/*ERROR OCCURED, Please retry, the data was null*/'),
          );
        }
        if (data.eRRORCODE == null ||  data.eRRORCODE !="00") {
          CommonMethods().printLog('some error occured');
          CommonMethods().printLog('project snapshot data is: ${data}');
          return Center(
            child: Text(
                '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
          );
        }
        else {
//          CommonMethods().printLog('The data is loaded!!!!');
          return ListView.builder(
            itemCount: data.oUTPUT.length,
            itemBuilder: (context, index) {
              {
                output = data.oUTPUT[index];
                CommonMethods().printLog('project snapshot data is: $data');
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
                      output = data.oUTPUT[index];
                      /*CommonMethods().printLog('******************** THE OUTPUT IS ${output.toString()}');
                      GlobalVariables().userSelectedService = output;*/                   //unable to instantiate the userSelecteeService
                      /*GlobalVariables().serviceid = output.serviceid;
                      GlobalVariables().servicename = output.servicename;
                      GlobalVariables().servicetype = output.servicetype;
                      GlobalVariables().servicecategory = output.servicecategory;
                      GlobalVariables().serviceCharge = output.serviceCharge;
                      GlobalVariables().servicecode = output.servicecode;*/
                      //CommonMethods().printLog('******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
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
    }else
      return'assets/images/bank-statement.png';
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
        .post("/getBookingList", data: getBookingHistoryString);
    //CommonMethods().printLog('The booking history request is ***********************  $getBookingHistoryString   ***************************************');
    var getBookingHistoryResponseString = jsonDecode(getBookingHistoryResponse.toString());
    CommonMethods().printLog('getBookingHistoryResponseString $getBookingHistoryResponseString' );
    var getBookingHistoryResponseObject =
    BookingHistoryResponse.fromJson(getBookingHistoryResponseString);
    //CommonMethods().printLog("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // CommonMethods().printLog("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    CommonMethods().printLog("THE SERVICE RESPONSE IS ${getBookingHistoryResponseObject.oUTPUT.length}");

   /* var output = getBookingHistoryResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      CommonMethods().printLog(
          '                SERVICE NAME IS $i : ${output[i].serviceName}             ');
      services.add(output[i].serviceName);
    }

    CommonMethods().printLog('             THE SERVICES OFFERED ARE $services                 ');
*/
    return getBookingHistoryResponseObject;
    //CommonMethods().printLog(accessToken);
  }

}

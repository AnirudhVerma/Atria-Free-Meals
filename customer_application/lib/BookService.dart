import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/Address.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer_application/CommonMethods.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'networkConfig.dart';

class BookService extends StatelessWidget {

  final String title;
  final int userid;
  final int serviceid;
  final String accessToken;
  final String userName;

  BookService(this.title, this.userid, this.serviceid, this.accessToken, this.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: addressList(),
    );
  }

  Widget addressList() {
    var addressOutput;
    return FutureBuilder(
      future: getAddress(),
      builder: (context, addressSnapShot) {
        if (addressSnapShot.data == null) {
          print('The data is in loading state');
          CommonMethods().toast(context, 'data not loaded');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print('The data is loaded!!!!');
          CommonMethods().toast(context, 'The data is loaded!!!!');
          return ListView.builder(
//            itemCount: int.parse(addressSnapShot.data.length),
            itemCount: addressSnapShot.data.length,
            itemBuilder: (context, index) {
              {
                addressOutput = addressSnapShot.data[index];
                print('project snapshot data is: ${addressSnapShot.data}');
                return ListTile(
                  title: Text(addressOutput.address),
                  subtitle: Text(addressOutput.addressid.toString()),
                  onTap: () {
                    CommonMethods().toast(context, 'You tapped on ${addressOutput.address}');
                    },
                );
              }
            },
          );
        }
      },
    );
  }

  Future<void> getAddress() async {
    String getAddressString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "userid":$userid,
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)"
    }""";
    Response getAddressResponse = await NetworkCommon()
        .myDio
        .post("/getAddressList", data: getAddressString);
    var getAddressResponseString = jsonDecode(getAddressResponse.toString());
    var getAddressResponseObject =
    Address.fromJson(getAddressResponseString);// replace with PODO class
    //print("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    print("THE ADDRESS RESPONSE IS $getAddressResponseObject");

    var output = getAddressResponseObject.oUTPUT;

    List address = [];

//    for (int i = 0; i < output.length; i++) {
//      print('                SERVICE NAME IS $i : ${output[i].servicename}             ');
//      address.add(output[i].servicename);
//    }

    print('             THE ADDRESSES ARE $address                 ');

    return output;
  }

}

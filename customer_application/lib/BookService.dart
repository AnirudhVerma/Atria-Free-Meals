import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/Address.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'JSONResponseClasses/ServiceList.dart';
import 'networkConfig.dart';

class BookService extends StatelessWidget {

  final String title;
  final int userid;

  BookService(this.title, this.userid);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: <Widget>[
          Text('Choose a delivery location'),
        ],
      ),
    );
  }

  Widget addressList() {
    var output;
    return FutureBuilder(
      future: getaddress(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.data == null) {
          print('The data is in loading state');
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          print('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data[index];
                print('project snapshot data is: ${servicesSnapShot.data}');
                return ListTile(
                  title: Text('address'),
                  onTap: () {
                    },
                );
              }
            },
          );
        }
      },
    );
  }

  Future<void> getaddress() async {
    String getAddressString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17"
    },
    "userid":$userid

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

    var output = getAddressResponseObject;

    List address = [];

//    for (int i = 0; i < output.length; i++) {
//      print('                SERVICE NAME IS $i : ${output[i].servicename}             ');
//      address.add(output[i].servicename);
//    }

    print('             THE ADDRESSES ARE $address                 ');

    return output;
  }

}

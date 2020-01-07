import 'dart:convert';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/JSONResponseClasses/Address.dart';
import 'package:customer_application/JSONResponseClasses/Bank.dart';
import 'package:customer_application/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer_application/CommonMethods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'networkConfig.dart';

class BookService extends StatelessWidget {
  final String title;
  final int userid;
  final int serviceid;
  final String accessToken;
  final String userName;
  final myBookServiceBloc = new BookServiceBloc();
  final nonDigit = new RegExp(r"(\D+)");
  final myPhoneNumberController = TextEditingController(text: '${GlobalVariables().phoneNumber}');

  BookService(
      this.title, this.userid, this.serviceid, this.accessToken, this.userName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
//      body: addressUI(context),
      body: Center(
        child: BlocBuilder<BookServiceBloc, BookServiceState>(
            bloc: myBookServiceBloc,
            builder: (context, state) {
              if (state is InitialBookServiceState) {
                return addressUI(context);
              }
              if (state is BankListState) {
                return bankListUI(context);
              }
              if (state is EnterRegisteredNumberState){
                return getPhoneNumberUI(context);
              }
              return null;
            }),
      ),
    );
  }

  Stack addressUI(BuildContext context) {
    Future<void> getAddress() async {
      String getBankString = """{
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
          .post("/getAddressList", data: getBankString);
      var getAddressResponseString = jsonDecode(getAddressResponse.toString());
      var getAddressResponseObject =
          Address.fromJson(getAddressResponseString); // replace with PODO class

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

    Widget addressList() {
      var addressOutput;
      return FutureBuilder(
        future: getAddress(),
        builder: (context, addressSnapShot) {
          if (addressSnapShot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
//            itemCount: int.parse(addressSnapShot.data.length),
              shrinkWrap: true,
              itemCount: addressSnapShot.data.length,
              itemBuilder: (context, index) {
                {
                  addressOutput = addressSnapShot.data[index];
                  print('project snapshot data is: ${addressSnapShot.data}');
                  return ListTile(
                    title: Text(addressOutput.address),
                    subtitle: Text(addressOutput.addressid.toString()),
                    onTap: () {
                      CommonMethods().toast(
                          context, 'You tapped on ${addressOutput.address}');
                      myBookServiceBloc.add(FetchBankList());
                    },
                  );
                }
              },
            );
          }
        },
      );
    }

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  child: Text(
                    '1',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Choose an Address',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 20,
              margin: EdgeInsets.all(18),
              child: Center(
                child: Container( child: addressList()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Stack bankListUI(BuildContext context) {
    Future<void> getBankList() async {
      String getBankListString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "serviceid":"3",      
    "pincode":"560092",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)"
    }""";
      Response getBankListResponse = await NetworkCommon()
          .myDio
          .post("/getBankList", data: getBankListString);
      var getBankListResponseString = jsonDecode(getBankListResponse.toString());
      var getBankListResponseObject =
          Bank.fromJson(getBankListResponseString); // replace with PODO class

      var output = getBankListResponseObject.oUTPUT;

      return output;
    }

    Widget bankList() {
      var addressOutput;
      return FutureBuilder(
        future: getBankList(),
        builder: (context, bankSnapShot) {
          if (bankSnapShot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              shrinkWrap: true,
//            itemCount: int.parse(addressSnapShot.data.length),
              itemCount: bankSnapShot.data.length,
              itemBuilder: (context, index) {
                {
                  addressOutput = bankSnapShot.data[index];
                  print('project snapshot data is: ${bankSnapShot.data}');
                  return ListTile(
                    title: Text(addressOutput.bankname),
                    subtitle: Text(addressOutput.bankCode.toString()),
                    onTap: () {
                      myBookServiceBloc.add(RegisteredNumber());
                      CommonMethods().toast(
                          context, 'You tapped on ${addressOutput.toString()}');
                    },
                  );
                }
              },
            );
          }
        },
      );
    }

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  child: Text(
                    '2',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  'Select your Bank',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 20,
              margin: EdgeInsets.all(18),
              child: bankList(),
            ),
          ],
        ),
      ],
    );
  }

  Stack getPhoneNumberUI(BuildContext context) {

      String getBankListString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "serviceid":"5",      
    "pincode":"560092",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)"
    }""";
//      Response getAddressResponse = await NetworkCommon().myDio.post("/getBankList", data: getBankListString);

    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Column(
          children: <Widget>[
            SizedBox(
              height: 16,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                CircleAvatar(
                  child: Text(
                    '3',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Text(
                    'Enter the number linked with your Bank',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 20,
              margin: EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      SizedBox(width: 12,),
                      Text("Use Registered Mobile Number?", style: TextStyle(color: Colors.blue, fontSize: 18),),
                    ],
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      maxLength: 10,
                      obscureText: false,
                      keyboardType: TextInputType.numberWithOptions(),
                      validator: (phoneNumber) {
                        if (phoneNumber.length < 10) {
                          return 'Please enter a valid Phone Number!';
                        }
                        if (nonDigit.hasMatch(phoneNumber)) {
                          return 'Please enter only Numbers!';
                        }
                        return null;
                      },
                      controller: myPhoneNumberController,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          prefixText: '+91 ',
                          prefixStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                          hintText: "Phone Number",
                          suffixIcon: Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          /*border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))*/),
                    ),
                  ),
                  SizedBox(height: 8,),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: ArgonButton(
                      height: 50,
                      width: 350,
                      borderRadius: 5.0,
                      color: Colors.blue,
                      child: Text(
                        "Continue",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700
                        ),
                      ),
                      loader: Container(
                        padding: EdgeInsets.all(10),
                        child: SpinKitRotatingCircle(
                          color: Colors.white,
                          // size: loaderWidth ,
                        ),
                      ),
                      onTap: (startLoading, stopLoading, btnState) {
                        CommonMethods().toast(context, 'The Phone number is ${GlobalVariables().phoneNumber}');
                          startLoading();
                      },
                    ),
                  ),
                  SizedBox(height: 8,)
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  fetchUserAccountDetails() async {
    String getBankListString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${GlobalVariables().phoneNumber}",      
    "bankcode":"01",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)"
    }""";
    Response getBankListResponse = await NetworkCommon()
        .myDio
        .post("/getBankList", data: getBankListString);
    var getBankListResponseString = jsonDecode(getBankListResponse.toString());
    var getBankListResponseObject =
    Bank.fromJson(getBankListResponseString); // replace with PODO class

    var output = getBankListResponseObject.oUTPUT;
  }

  void dispose() {
    myBookServiceBloc.close();
  }
}

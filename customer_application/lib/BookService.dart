import 'dart:convert';
import 'dart:io';
//import 'dart:html';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/JSONResponseClasses/Address.dart';
import 'package:customer_application/JSONResponseClasses/Bank.dart';
import 'package:customer_application/JSONResponseClasses/BankOTPResponse.dart';
import 'package:customer_application/JSONResponseClasses/BookServiceReq.dart';
import 'package:customer_application/JSONResponseClasses/BookServiceResponse.dart';
import 'package:customer_application/JSONResponseClasses/BookingHistoryResponse.dart';
import 'package:customer_application/JSONResponseClasses/UserAccountDetails.dart';
import 'package:customer_application/MainUI.dart';
import 'package:customer_application/bloc.dart';
import 'package:customer_application/repository.dart';
import 'package:dio/dio.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:customer_application/CommonMethods.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'JSONResponseClasses/Branch.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'JSONResponseClasses/TimeSlot.dart';
import 'networkConfig.dart';

class BookService extends StatefulWidget {
  @override
  _BookServiceState createState() => _BookServiceState();
}

/*class _MyBookServiceState extends State<MyBookService>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

}*/

class _BookServiceState extends State<BookService> {
  final String title = GlobalVariables().servicename;
  final int userid = GlobalVariables().myPortalLogin.oUTPUT.user.userid;
  final int serviceid = int.parse(GlobalVariables().serviceid);
  final String accessToken =
      GlobalVariables().myPortalLogin.oUTPUT.token.accessToken;
  final String userName = GlobalVariables().phoneNumber;
  bool _autoValidate = false;
//  final myBookServiceBloc = new BookServiceBloc();
  final myBookServiceBloc = GlobalVariables().myBookServiceBloc;
  final nonDigit = new RegExp(r"(\D+)");
  final GlobalKey<FormState> _phoneNumberKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _OTPKey = GlobalKey<FormState>();
  final myBankPhoneNumberController =
      TextEditingController(text: '${GlobalVariables().phoneNumber}');
  final myBankOTPController = TextEditingController();
  var _myFocusNode = new FocusNode();
  var _onPressed;
  var _onPressedOnTimeSlot = null;
  bool _enabled = false;
  int currentValue = 0;

  final Map<int, Widget> dates = const <int, Widget>{
    0: Text('Today'),
    1: Text('Tomorrow'),
  };

  Map<int, Widget> icons = <int, Widget>{
    0: new TimeSlotWidget(),
    1: new Text("Yo"),
    /*2: Center(
      child: FlutterLogo(
        colors: Colors.cyan,
        size: 200.0,
      ),
    ),*/
  };

//  BookService(this.title, this.userid, this.serviceid, this.accessToken, this.userName);

//  BookService(){};

  @override
  Widget build(BuildContext context) {
    if (_enabled) {
      _onPressed = () {
        Navigator.of(context).pop(false);
        bookService();
      };
    }

    return WillPopScope(
      onWillPop: () {
        GlobalVariables().listOfParams = null;
        return showDialog(
          context: context,
          child: CupertinoAlertDialog(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text('Cancel Booking?'),
            content: Text('Are you sure you want to cancel your Booking?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Cancel',
                  style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
//      body: addressUI(context),
        body: Center(
          child: BlocBuilder<BookServiceBloc, BookServiceState>(
              bloc: myBookServiceBloc,
              builder: (context, state) {
                if (state is InitialBookServiceState) {
                  return  addressUI(context);
                }
                if (state is BankListState) {
                  return bankListUI(context);
                }
                if (state is EnterRegisteredNumberState) {
                  return getPhoneNumberUI(context);
                }
                if (state is EnterBankOTPState) {
                  return enterOTPUI(context);
                }
                if (state is AccountListState) {
                  return userAccountDetailsUI(context);
                }
                if (state is BranchListState) {
                  return branchListUI(context);
                }
                if (state is TimeSlotState) {
                  return selectTimeSlotUI(context);
                }
                if (state is LiamAccountListState) {
                  return selectLiamAccountUI(context);
                }
                if( state is BookingResultState){
                  return Container(child: Text('Booking Result UI'),);
                }
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              }),
        ),
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
    "ts": "${CommonMethods().getTimeStamp()}"
    }""";
      Response getAddressResponse = await NetworkCommon()
          .myDio
          .post("/getAddressList", data: getBankString);
      var getAddressResponseString = jsonDecode(getAddressResponse.toString());
      var getAddressResponseObject =
          Address.fromJson(getAddressResponseString); // replace with PODO class

      CommonMethods().printLog("THE ADDRESS RESPONSE IS $getAddressResponseObject");

      var output = getAddressResponseObject.oUTPUT;

      List address = [];

      CommonMethods().printLog('             THE ADDRESSES ARE $address                 ');

      return getAddressResponseObject;
    }

    Widget addressList() {
      var addressOutput;
      return EnhancedFutureBuilder(
        rememberFutureResult: true,
        future: getAddress(),
        whenNotDone: Center(child: CircularProgressIndicator(),),
        whenDone: (dynamic data) {
          if (data.eRRORCODE !="00") {
            CommonMethods().printLog('some error occured');
            CommonMethods().printLog('project snapshot data is: $data');
            return Center(
              child: Text(
                  '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
              //    child: Text('/*${servicesSnapShot.data.eRRORCODE} : ${servicesSnapShot.data.eRRORMSG}*/'),
            );
          } else {
            return ListView.separated(
//            itemCount: int.parse(addressSnapShot.data.length),
              shrinkWrap: true,
              itemCount: data.oUTPUT.length,
              itemBuilder: (context, index) {
                {
                  addressOutput = data.oUTPUT[index];
                  CommonMethods().printLog('project snapshot data is: ${data}');
                  return ListTile(
                    leading: CircleAvatar(
                      child: new Image(
                          image:
                              new AssetImage('assets/images/address_icon.png')),
                    ),
                    title: Text(addressOutput.address),
                    subtitle: Text(addressOutput.pincode.toString()),
                    onTap: () {
                      addressOutput = data.oUTPUT[index];
                      GlobalVariables().pincode = addressOutput.pincode;
                      GlobalVariables().latitude = addressOutput.latitude;
                      GlobalVariables().longitude = addressOutput.longitude;
                      GlobalVariables().addressid = addressOutput.addressid;
                      GlobalVariables().address = addressOutput.address;
                      myBookServiceBloc.add(FetchBankList());
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                );
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
//              SingleChildScrollView(
//                child: Card(
               Center(
                 child: Container(
//                 margin: EdgeInsets.all(10),
//                   height: 500,
                   constraints: BoxConstraints(
                       maxHeight: 500.0
                   ),
                   child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      elevation: 20,
                      margin: EdgeInsets.all(18),
                     // child: SingleChildScrollView(
                        child: addressList(),
                      //),
//                ),
              ),
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
    "serviceid":"${GlobalVariables().serviceid}",      
    "pincode":"${GlobalVariables().pincode}",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "${CommonMethods().getTimeStamp()}"
    }""";
      Response getBankListResponse = await NetworkCommon()
          .myDio
          .post("/getBankList", data: getBankListString);
      var getBankListResponseString =
          jsonDecode(getBankListResponse.toString());
      var getBankListResponseObject =
          Bank.fromJson(getBankListResponseString); // replace with PODO class

      var output = getBankListResponseObject.oUTPUT;

      return getBankListResponseObject;
//    return getBankListResponseObject;
    }

    Widget bankList() {
      var bankOutput;
      return EnhancedFutureBuilder(
        future: getBankList(),
        rememberFutureResult: true,
        whenNotDone: Center(child: CircularProgressIndicator(),),
        whenDone: (dynamic data) {
          if (data.eRRORCODE != "00") {
            CommonMethods().printLog('some error occured');
            CommonMethods().printLog('project snapshot data is: $data');
            return Center(
              child: Text(
                  '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
//            itemCount: int.parse(addressSnapShot.data.length),
              itemCount: data.oUTPUT.length,
              itemBuilder: (context, index) {
                {
                  bankOutput = data.oUTPUT[index];
                  CommonMethods().printLog('project snapshot data is: $data');
                  return ListTile(
                    leading: CircleAvatar(
                      child: new Image(
                          image: new AssetImage('assets/images/bank_icon.png')),
                    ),
                    title: Text(bankOutput.bankname),
                    subtitle: Text(bankOutput.bankCode.toString()),
                    onTap: () {
                      bankOutput = data.oUTPUT[index];
                      GlobalVariables().bankCode = bankOutput.bankCode;
                      GlobalVariables().bankname = bankOutput.bankname;
                      myBookServiceBloc.add(RegisteredNumber());
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                );
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
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(AddressEvent());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
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
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Form(
          key: _phoneNumberKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      myBookServiceBloc.add(AddressEvent());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      maxRadius: 10,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      myBookServiceBloc.add(FetchBankList());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      maxRadius: 10,
                    ),
                  ),
                  SizedBox(
                    width: 8,
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
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Use Registered Mobile Number?",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        maxLength: 10,
                        obscureText: false,
                        keyboardType: TextInputType.numberWithOptions(),
                        onChanged: (phoneNumber) {
                          if (phoneNumber.length == 10) {
                            FocusScope.of(context).requestFocus(_myFocusNode);
                          }
                        },
                        validator: (phoneNumber) {
                          if (phoneNumber.length < 10) {
                            return 'Please enter a valid Phone Number!';
                          }
                          if (nonDigit.hasMatch(phoneNumber)) {
                            return 'Please enter only Numbers!';
                          }
                          return null;
                        },
                        controller: myBankPhoneNumberController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          prefixText: '+91 ',
                          prefixStyle: TextStyle(
                              fontWeight: FontWeight.bold),
                          hintText: "Phone Number",
                          suffixIcon: Icon(
                            Icons.phone,
                            color: Colors.blue,
                          ),
                          /*border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))*/
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
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
                              fontWeight: FontWeight.w700),
                        ),
                        loader: Container(
                          padding: EdgeInsets.all(10),
                          child: SpinKitRotatingCircle(
                            color: Colors.white,
                            // size: loaderWidth ,
                          ),
                        ),
                        onTap: (startLoading, stopLoading, btnState) async {
//                          startLoading();
//                          _validatePhoneNumberInput();
                          /*CommonMethods().toast(context,
                              'The Phone number is ${GlobalVariables().phoneNumber}');
                          BankOTPResponse myBankOTPResponse = await fetchUserAccountDetails();
                          GlobalVariables().myBankOTPResponse = await fetchUserAccountDetails();
                          if (myBankOTPResponse.eRRORMSG == 'SUCCESS') {
                            myBookServiceBloc.add(EnterBankOTP());
                          } else {
                            CommonMethods()
                                .toast(context, myBankOTPResponse.eRRORMSG);
                          }*/
                          //startLoading();
                          // stopLoading();
                          _validatePhoneInput1();

                          if(_validatePhoneInput1() == 0){
                            startLoading();
                            CommonMethods().toast(context,
                              'The Phone number is ${GlobalVariables().phoneNumber}');
                          BankOTPResponse myBankOTPResponse = await fetchUserAccountDetails();
                          GlobalVariables().myBankOTPResponse = await fetchUserAccountDetails();
                          CommonMethods().printLog('************The problem ${myBankOTPResponse.eRRORMSG}');
                          if(myBankOTPResponse.eRRORMSG != null){
                            if (myBankOTPResponse.eRRORMSG != null && myBankOTPResponse.eRRORMSG == 'SUCCESS') {
                              myBookServiceBloc.add(EnterBankOTP());
                            } else {
                              CommonMethods()
                                  .toast(context, myBankOTPResponse.eRRORMSG);
                            }
                          }
                          else{
                            CommonMethods().toast(context,'Couldn\'t get Response from bank');
                            stopLoading();
                          }
                          }

                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<BankOTPResponse> fetchUserAccountDetails() async {
    String getBankListString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${myBankPhoneNumberController.text}",      
    "bankcode":"${GlobalVariables().bankCode}",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "${CommonMethods().getTimeStamp()}"
    }""";
    Response getBankListResponse = await NetworkCommon()
        .myDio
        .post("/generateOTPBank", data: getBankListString);
    CommonMethods().printLog('************The generateOTPBank string is $getBankListString');
    var getBankOTPResponseString = jsonDecode(getBankListResponse.toString());
    if(getBankOTPResponseString.toString().contains('"code":"ECONNREFUSED"')){
      return showDialog(context: context,builder: (_) {
        return CupertinoAlertDialog(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Text('Error'),
          content: Text('ECONNREFUSED'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'OK',
                style: TextStyle(
                    color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      } );
    }else{
      var getBankOTPResponseObject =
      BankOTPResponse.fromJson(getBankOTPResponseString);

      var output = getBankOTPResponseObject.oUTPUT;
      return getBankOTPResponseObject;
    }
  }

  Stack enterOTPUI(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Form(
          key: _OTPKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      myBookServiceBloc.add(AddressEvent());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      maxRadius: 10,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      myBookServiceBloc.add(FetchBankList());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      maxRadius: 10,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      myBookServiceBloc.add(RegisteredNumber());
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      maxRadius: 10,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  CircleAvatar(
                    child: Text(
                      '4',
                      style: TextStyle(color: Colors.blue[900]),
                    ),
                    backgroundColor: Colors.blue[100],
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      'An OTP has been sent to ${myBankPhoneNumberController.text}',
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
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Enter OTP",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: TextFormField(
                        maxLength: 6,
                        obscureText: true,
                        keyboardType: TextInputType.numberWithOptions(),
                        onChanged: (OTP) {
                          if (OTP.length == 6) {
                            FocusScope.of(context).requestFocus(_myFocusNode);
                          }
                        },
                        validator: (OTP) {
                          if (OTP.length < 6) {
                            return 'Please enter 6 digits OTP!';
                          }
                          if (nonDigit.hasMatch(OTP)) {
                            return 'Please enter only Numbers!';
                          }
                          return null;
                        },
                        controller: myBankOTPController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          prefixText: ' ',
                          prefixStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          hintText: "OTP",
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                          /*border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))*/
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ArgonButton(
                        height: 50,
                        width: 350,
                        borderRadius: 5.0,
                        color: Colors.blue,
                        child: Text(
                          "Proceed",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        loader: Container(
                          padding: EdgeInsets.all(10),
                          child: SpinKitRotatingCircle(
                            color: Colors.white,
                            // size: loaderWidth ,
                          ),
                        ),
                        onTap: (startLoading, stopLoading, btnState) async {

//                          startLoading();
//                          _validateOTPInput();

                          _validateOTPInput1();
                          if(_validateOTPInput1() == 0){
                            CommonMethods().toast(context,
                                'The Entered OTP is ${myBankOTPController.text}');
                            startLoading();
                            GlobalVariables().myUserAccountDetails = await verifyOTPAndGetAccountDetails();
                            if (GlobalVariables().myUserAccountDetails.eRRORMSG == 'SUCCESS'){
                              myBookServiceBloc.add(FetchAccountList());
                            }
                            else{
                              CommonMethods().toast(context, GlobalVariables().myUserAccountDetails.eRRORMSG);
                            }
                          }
                          /*CommonMethods().toast(context,
                              'The Entered OTP is ${myBankOTPController.text}');
                          startLoading1();
                          GlobalVariables().myUserAccountDetails = await verifyOTPAndGetAccountDetails();
                          if (GlobalVariables().myUserAccountDetails.eRRORMSG == 'SUCCESS'){
                            myBookServiceBloc.add(FetchAccountList());
                          }
                          else{
                            CommonMethods().toast(context, GlobalVariables().myUserAccountDetails.eRRORMSG);
                          }*/
//                          stopLoading();
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<UserAccountDetails> verifyOTPAndGetAccountDetails() async {
    String verifyOTPAndGetAccountDetailsString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${myBankPhoneNumberController.text}",      
    "bankcode":"${GlobalVariables().bankCode}",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "${CommonMethods().getTimeStamp()}",
    "OTP":"${myBankOTPController.text}",
    "uniqrefnum":"${GlobalVariables().myBankOTPResponse.oUTPUT[0].uniqrefnum}",
    "bankuniqrefnum":"${GlobalVariables().myBankOTPResponse.oUTPUT[0].bankuniqrefnum}"
    }""";
    CommonMethods().printLog('**************** The get account details call is $verifyOTPAndGetAccountDetailsString');
    Response verifyOTPAndGetAccountDetailsResponse = await NetworkCommon()
        .myDio
        .post("/getAccountDetails", data: verifyOTPAndGetAccountDetailsString);
    var verifyOTPString =
        jsonDecode(verifyOTPAndGetAccountDetailsResponse.toString());
    var verifyOTPResponseObject = UserAccountDetails.fromJson(verifyOTPString);

    return verifyOTPResponseObject;
  }

  Future<Branch> fetchBranches() async {
    String fetchBranchesString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${myBankPhoneNumberController.text}",      
    "bankcode":"${GlobalVariables().bankCode}",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "${CommonMethods().getTimeStamp()}",
    "latitude":"${GlobalVariables().latitude}",
    "longitude":"${GlobalVariables().longitude}",
    "pincode":"${GlobalVariables().pincode}"
    }""";
    Response fetchBranchesStringResponse = await NetworkCommon()
        .myDio
        .post("/getBranchList", data: fetchBranchesString);
    var getBranchesResponseString =
        jsonDecode(fetchBranchesStringResponse.toString());
    var branchListObject = Branch.fromJson(getBranchesResponseString);

    return branchListObject;
  }

  Future<TimeSlot> fetchTimeSlots() async {
    String date = DateTime.now().toString().substring(0, 10);
    final now = DateTime.now();
    final tomorrow = new DateTime(now.year, now.month, now.day + 1);
    date = tomorrow.toString().substring(0, 10);
    String fetchTimeSlotsString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    }, 
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "ts": "${CommonMethods().getTimeStamp()}",
    "pincode":"${GlobalVariables().pincode}",
    "requesteddate":"$date"
    }""";
    Response fetchTimeSlotResponse = await NetworkCommon()
        .myDio
        .post("/getAvailableSlot", data: fetchTimeSlotsString);
    var getTimeSlotResponseString =
        jsonDecode(fetchTimeSlotResponse.toString());
    var timeSlotObject = TimeSlot.fromJson(getTimeSlotResponseString);

    return timeSlotObject;
  }

  Future<BookServiceResponse> bookService() async {
    var requestTime = CommonMethods().getEpochTime();
    String date = DateTime.now().toString().substring(0, 10);

    var jason = json.encode(GlobalVariables().listOfParams);
    //String toBeSent = jason.toString().substring(1, jason.toString().length - 1);

    String bookServiceDynamicString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${myBankPhoneNumberController.text}",  
    "customerid":"${GlobalVariables().myPortalLogin.oUTPUT.user.userid}",
    "customername":"${GlobalVariables().firstResponse.oUTPUT[0].firstname}",
    "requesttime":"$requestTime",
    "DEVICEID": "",
    "serviceid":"$serviceid",
    "servicetype":"${GlobalVariables().servicetype}",
    "servicecategory":"${GlobalVariables().servicecategory}",
    "servicename":"${GlobalVariables().servicename}",
    "servicecharge":"${GlobalVariables().serviceCharge}",
    "bankcode":"${GlobalVariables().bankCode}",
    "bankname":"${GlobalVariables().bankname}",
    "branchcode":"${GlobalVariables().branchcode}",
    "branchname":"${GlobalVariables().branchname}",
    "addressid":"${GlobalVariables().addressid}",
    "address":"${GlobalVariables().address}",
    "lienmarkaccounttype":"NA",
    "lienmarkaccount":"${GlobalVariables().serviceAccount}",
    "serviceaccounttype":"NA",
    "serviceaccount":"${GlobalVariables().serviceAccount}",
    "prefereddate":"$date",
    "slot":"${GlobalVariables().timeSlot}",
    "channel":"iOS",
    "ccagentid":"",
    "authorization":"$accessToken",
    "username":"$userName",
    "ts": "${CommonMethods().getTimeStamp()}",
    "latitude":"${GlobalVariables().latitude}",
    "longitude":"${GlobalVariables().longitude}",
    "pincode":"${GlobalVariables().pincode}",
    "servicecode":"${GlobalVariables().servicecode}",
    "custom_params": $jason
    }""";

   AdditionalData additionalData = AdditionalData(
        clientAppVer:"1.0.0",
        clientApptype:"DSB",
        platform:"ANDROID",
        vendorid:"17",
        clientAppName:"ANIOSCUST"
    );

    BookServiceReq myObj = BookServiceReq(
      additionalData: additionalData,
        mobilenumber:myBankPhoneNumberController.text,
        customerid:GlobalVariables().myPortalLogin.oUTPUT.user.userid.toString(),
        customername:GlobalVariables().firstResponse.oUTPUT[0].firstname,
        requesttime:requestTime.toString(),
        dEVICEID: "",
        serviceid:serviceid.toString(),
        servicetype:GlobalVariables().servicetype,
        servicecategory:GlobalVariables().servicecategory,
        servicename:GlobalVariables().servicename,
        servicecharge:GlobalVariables().serviceCharge,
        bankcode:GlobalVariables().bankCode,
        bankname:GlobalVariables().bankname,
        branchcode:GlobalVariables().branchcode,
        branchname:GlobalVariables() .branchname,
        addressid:GlobalVariables().addressid.toString(),
        address:GlobalVariables().address,
        lienmarkaccounttype:"NA",
        lienmarkaccount:GlobalVariables().serviceAccount,
        serviceaccounttype:"NA",
        serviceaccount:GlobalVariables().serviceAccount,
        prefereddate:date,
        slot:GlobalVariables().timeSlot,
        channel:"iOS",
        ccagentid:"",
        authorization:accessToken,
        username:userName,
        ts: CommonMethods().getTimeStamp(),
        latitude:GlobalVariables().latitude,
        longitude:GlobalVariables().longitude,
        pincode:GlobalVariables().pincode,
        servicecode:GlobalVariables().servicecode,
        customParams:GlobalVariables().listOfParams.toString()

    );


   /* myObj.additionalData = AdditionalData(
        clientAppVer:"1.0.0",
        clientApptype:"DSB",
        platform:"ANDROID",
        vendorid:"17",
        clientAppName:"ANIOSCUST"
    );*/
   /* myObj.additionalData.clientAppName= "ANIOSCUST";

    myObj.additionalData.clientApptype = "DSB" ;

    myObj.additionalData.clientAppVer ="1.0.0" ;
    myObj.additionalData.platform = "ANDROID";

    myObj.additionalData.vendorid ="17" ;*/

   var finalBookServiceReq = jsonEncode(myObj);


    CommonMethods().printLog('******************The book Service String is $bookServiceDynamicString');

    Response bokServiceResponse = await NetworkCommon()
        .myDio
        .post("/bookService", data: finalBookServiceReq);
    var getBranchesResponseString = jsonDecode(bokServiceResponse.toString());
    GlobalVariables().myBookServiceResponseObject =
        BookServiceResponse.fromJson(getBranchesResponseString);

    //REMOVE THIS!!

//    myBookServiceBloc.add(BookingResult());


    if (GlobalVariables().myBookServiceResponseObject.eRRORCODE == '00') {
      showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text('Success'),
          content: Text('Your Booking was Successful'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                GlobalVariables().listOfParams = null;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyMainPage()));
              },
              child: Text(
                'OK',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        child: CupertinoAlertDialog(
          title: Text('Sorry'),
          content:
              Text('${GlobalVariables().myBookServiceResponseObject.eRRORMSG}'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                GlobalVariables().listOfParams = null;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyMainPage()));
              },
              child: Text(
                'OK',
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }

    return GlobalVariables().myBookServiceResponseObject;
  }

  Stack userAccountDetailsUI(BuildContext context) {
    Widget accountList() {
      var accounts;
      return FutureBuilder(
        future: verifyOTPAndGetAccountDetails(),
        builder: (context, AccountSnapShot) {
          if (AccountSnapShot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
//            itemCount: int.parse(addressSnapShot.data.length),
              itemCount: AccountSnapShot.data.oUTPUT[0].accountnumber.length,
              itemBuilder: (context, index) {
                {
                  accounts = AccountSnapShot.data.oUTPUT[0].accountnumber[index];
                  CommonMethods().printLog('project snapshot data is: ${AccountSnapShot.data}');
                  return ListTile(
                    leading: new CircleAvatar(
                      child: new Image(
                          image: new AssetImage(
                              'assets/images/bank_account_icon.png')),
                    ),
                    title: Text(accounts),
                    onTap: () {
                      accounts =
                          AccountSnapShot.data.oUTPUT[0].accountnumber[index];
                      CommonMethods().toast(
                          context, 'You tapped on ${accounts.toString()}');
                      GlobalVariables().serviceAccount = accounts;
                      myBookServiceBloc.add(FetchBranchList());
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                );
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
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(AddressEvent());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchBankList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(RegisteredNumber());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(EnterBankOTP());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  child: Text(
                    '5',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Text(
                    'Select an Account to get service from',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
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
              child: accountList(),
            ),
          ],
        ),
      ],
    );
  }

  Stack branchListUI(BuildContext context) {
    Widget branchList() {
      var branches;
      return EnhancedFutureBuilder(
        future: fetchBranches(),
        rememberFutureResult: true,
        whenNotDone: Center(child: CircularProgressIndicator(),),
        whenDone: (dynamic data) {
          if (data.eRRORCODE !="00") {
            CommonMethods().printLog('some error occured');
            CommonMethods().printLog('project snapshot data is: ${data}');
            return Center(
              child: Text(
                  '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
//            itemCount: int.parse(addressSnapShot.data.length),
              itemCount: data.oUTPUT.length,
              itemBuilder: (context, index) {
                {
                  branches = data.oUTPUT[index];
                  CommonMethods().printLog('project snapshot data is: $data');
                  return ListTile(
                    leading: new CircleAvatar(
                      child: new Image(
                          image:
                              new AssetImage('assets/images/branch_icon.png')),
                    ),
                    title: Text(branches.branchname),
                    onTap: () {
                      branches = data.oUTPUT[index];
                      CommonMethods().toast(context,
                          'You tapped on ${branches.branchname.toString()}');
                      GlobalVariables().branchcode = branches.branchcode;
                      GlobalVariables().branchname = branches.branchname;
                      myBookServiceBloc.add(FetchTimeSlot());
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                );
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
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(AddressEvent());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchBankList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(RegisteredNumber());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(EnterBankOTP());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchAccountList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  child: Text(
                    '6',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Text(
                    'Select your preferred Branch',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
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
              child: branchList(),
            ),
          ],
        ),
      ],
    );
  }

  Stack selectTimeSlotUI(BuildContext context) {
    Widget slotList() {
      var timeSlot;
      return EnhancedFutureBuilder(
        future: Repository().fetchTimeSlots(),
        rememberFutureResult: true,
        whenNotDone: Center(child: CircularProgressIndicator(),),
        whenDone: (dynamic data) {
          if (data.eRRORCODE !="00") {
            CommonMethods().printLog('some error occured');
            CommonMethods().printLog('project snapshot data is: ${data}');
            return Center(
              child: Text(
                  '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
            );
          } else {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: data.oUTPUT.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemBuilder: (context, index) {
                {
                  timeSlot = data.oUTPUT[index].slotnumber;
                  var avalabilityStatus = data.oUTPUT[index].avalabilityStatus;
                  CommonMethods().printLog('project snapshot data is: $data');

                  if(data.oUTPUT[index].avalabilityStatus != 'N')
                 // if(index.isEven)
                  {
                    return MaterialButton(
                      //title: Text(timeSlot),
                      child: Center(
                          child: Text(
                            timeSlot,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          )),
                      color: Colors.blue[400],
                      onPressed: () {
                        timeSlot = data.oUTPUT[index].slotnumber;
                        CommonMethods().toast(
                            context, 'You tapped on ${timeSlot.toString()}');
                        GlobalVariables().timeSlot = timeSlot;
                        myBookServiceBloc.add(FetchLiamAccount());

                      },
                    );
                  }
                  else{
                    return MaterialButton(
                      color: Colors.pink,
                      child: Center(
                          child: Text(
                            timeSlot,
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          )),
                      onPressed: null,
                    );
                  }
                  /*return MaterialButton(
                    //title: Text(timeSlot),
                    child: Center(
                        child: Text(
                          timeSlot,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        )),
                    color: Colors.blue[400],
                    onPressed: () {
                      timeSlot = timeSlotSnapShot.data.oUTPUT[index].slotnumber;
                      CommonMethods().toast(
                          context, 'You tapped on ${timeSlot.toString()}');
                      GlobalVariables().timeSlot = timeSlot;
                      myBookServiceBloc.add(FetchLiamAccount());

                    },
                  );*/
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
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(AddressEvent());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchBankList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(RegisteredNumber());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(EnterBankOTP());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchAccountList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchBranchList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  child: Text(
                    '7',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(
                  width: 16,
                ),
                Flexible(
                  child: Text(
                    'Pick your time',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18,
            ),
            SizedBox(
              width: 300.0,
              child: CupertinoSlidingSegmentedControl<int>(
                children: dates,
                onValueChanged: (int val) {
                  setState(() {
                    currentValue = val;
                  });
                },
                groupValue: currentValue,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 20,
                margin: EdgeInsets.all(18),
                child: Padding(
                  //child: icons[currentValue],
                  child: slotList(),
                  padding: EdgeInsets.all(5.0),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Stack selectLiamAccountUI(BuildContext context) {
    Widget accountList() {
      var accounts;
      return EnhancedFutureBuilder(
        future: verifyOTPAndGetAccountDetails(),
        rememberFutureResult: true,
        whenNotDone: Center(child: CircularProgressIndicator(),),
        whenDone: (dynamic data) {
          if (data.eRRORCODE !="00") {
            CommonMethods().printLog('some error occured');
            CommonMethods().printLog('project snapshot data is: ${data}');
            return Center(
              child: Text(
                  '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
            );
          } else {
            return ListView.separated(
              shrinkWrap: true,
//            itemCount: int.parse(addressSnapShot.data.length),
              itemCount: data.oUTPUT[0].accountnumber.length,
              itemBuilder: (context, index) {
                {
                  accounts = data.oUTPUT[0].accountnumber[index];
                  CommonMethods().printLog('project snapshot data is: $data');
                  return ListTile(
                    leading: new CircleAvatar(
                      child: new Image(
                          image: new AssetImage(
                              'assets/images/bank_account_icon.png')),
                    ),
                    title: Text(accounts),
                    onTap: () {
                      accounts =
                          data.oUTPUT[0].accountnumber[index];
                      CommonMethods().toast(
                          context, 'You tapped on ${accounts.toString()}');
                      GlobalVariables().lianAccount = accounts;
                      showDialog(
                        context: context,
                        child: CupertinoAlertDialog(
                          title: Text('Confirm Booking'),
                          content: Column(
                            children: <Widget>[
                              Text(
                                  'Name : ${GlobalVariables().firstResponse.oUTPUT[0].firstname}'),
                              Text(
                                  'Service Type : ${GlobalVariables().servicetype}'),
                              Text(
                                  'Service Charge : ${GlobalVariables().serviceCharge}'),
                              Text('Bank : ${GlobalVariables().bankname}'),
                              Text('Branch : ${GlobalVariables().branchname}'),
                              Text('Address : ${GlobalVariables().address}'),
                              Text(
                                  'Service Delivery Account : ${GlobalVariables().serviceAccount}'),
                              Text(
                                  'Payment Account : ${GlobalVariables().lianAccount}'),
                              Text(
                                  'Prefered Time : ${GlobalVariables().timeSlot}'),
                              /*Material(
                                child: Checkbox(
                                  value: _enabled,
                                  onChanged: (bool value){
                                    setState((){
                                      _enabled = value;
                                    });
                                  },
                                ),
                              ),*/
                            ],
                          ),
                          /*actions: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                                bookService();
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    color: Colors.blue, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],*/
                          actions: <Widget>[
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                bookService();
                              },
                              child: Text(
                                'Confirm',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      );
//                      bookService();
                    },
                  );
                }
              },
              separatorBuilder: (context, index) {
                return Divider(
                  indent: 16,
                  endIndent: 16,
                );
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
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(AddressEvent());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchBankList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(RegisteredNumber());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(EnterBankOTP());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchAccountList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchBranchList());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                GestureDetector(
                  onTap: () {
                    myBookServiceBloc.add(FetchTimeSlot());
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                CircleAvatar(
                  child: Text(
                    '8',
                    style: TextStyle(color: Colors.blue[900]),
                  ),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(
                  width: 16,
                ),

                SizedBox(
                  width: 16,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                SizedBox(width: 16,),
                Flexible(
                  child: Text(
                    'Almost Done, Select an account to be charged',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
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
              child: accountList(),
            ),
          ],
        ),
      ],
    );
  }

  int _validatePhoneInput1() {
    if (_phoneNumberKey.currentState.validate()) {
      return 0;
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  int _validateOTPInput1(){
    if (_OTPKey.currentState.validate()) {
      return 0;
    }
    else {
      setState(() {
        _autoValidate = true;
        return 1;
      });
    }
  }

  Future<void> _validateOTPInput() async {
    if (_OTPKey.currentState.validate()) {
      CommonMethods()
          .toast(context, 'The Entered OTP is ${myBankOTPController.text}');
      GlobalVariables().myUserAccountDetails =
          await verifyOTPAndGetAccountDetails();
      if (GlobalVariables().myUserAccountDetails.eRRORMSG == 'SUCCESS') {
        myBookServiceBloc.add(FetchAccountList());
      } else {
        CommonMethods()
            .toast(context, GlobalVariables().myUserAccountDetails.eRRORMSG);
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  void dispose() {
    super.dispose();
    myBookServiceBloc.close();
  }

  void whatToDoOnPressed(timeSlot, isEnabled) {
    if(isEnabled == 'N'){
      return null;
    }else
    GlobalVariables().timeSlot = timeSlot;
    myBookServiceBloc.add(FetchLiamAccount());
  }
}


class TimeSlotWidget extends StatefulWidget {

  var date = 0;

  TimeSlotWidget({this.date});

  @override
  _TimeSlotWidgetState createState({date}) => new _TimeSlotWidgetState();
}

class _TimeSlotWidgetState extends State<TimeSlotWidget> {

  @override
  Widget build(BuildContext context) {
    var timeSlot;
    return EnhancedFutureBuilder(
      future: Repository().fetchTimeSlots(),
      rememberFutureResult: true,
      whenNotDone: Center(child: CircularProgressIndicator(),),
      whenDone: (dynamic data) {
        if (data.eRRORCODE !="00") {
          CommonMethods().printLog('some error occured');
          CommonMethods().printLog('project snapshot data is: ${data}');
          return Center(
            child: Text(
                '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
          );
        } else {
          return GridView.builder(
            shrinkWrap: true,
            itemCount: data.oUTPUT.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (context, index) {
              {
                timeSlot = data.oUTPUT[index].slotnumber;
                var avalabilityStatus = data.oUTPUT[index].avalabilityStatus;
                CommonMethods().printLog('project snapshot data is: $data');

                if(data.oUTPUT[index].avalabilityStatus != 'N')
                  // if(index.isEven)
                    {
                  return MaterialButton(
                    //title: Text(timeSlot),
                    child: Center(
                        child: Text(
                          timeSlot,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        )),
                    color: Colors.blue[400],
                    onPressed: () {
                      timeSlot = data.oUTPUT[index].slotnumber;
                      CommonMethods().toast(
                          context, 'You tapped on ${timeSlot.toString()}');
                      GlobalVariables().timeSlot = timeSlot;
                      GlobalVariables().myBookServiceBloc.add(FetchLiamAccount());

                    },
                  );
                }
                else{
                  return MaterialButton(
                    color: Colors.pink,
                    child: Center(
                        child: Text(
                          timeSlot,
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        )),
                    onPressed: null,
                  );
                }
                /*return MaterialButton(
                    //title: Text(timeSlot),
                    child: Center(
                        child: Text(
                          timeSlot,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        )),
                    color: Colors.blue[400],
                    onPressed: () {
                      timeSlot = timeSlotSnapShot.data.oUTPUT[index].slotnumber;
                      CommonMethods().toast(
                          context, 'You tapped on ${timeSlot.toString()}');
                      GlobalVariables().timeSlot = timeSlot;
                      myBookServiceBloc.add(FetchLiamAccount());

                    },
                  );*/
              }
            },
          );
        }
      },
    );
  }

}

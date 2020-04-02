import 'dart:convert';
import 'package:customer_application/CommonMethods.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/JSONResponseClasses/ComplaintList.dart';
import 'package:customer_application/JSONResponseClasses/ComplaintType.dart';
import 'package:customer_application/JSONResponseClasses/EncryptedResponse.dart';
import 'package:customer_application/JSONResponseClasses/FetchUserReq.dart';
import 'package:customer_application/LoadingIndicator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'AesHelper.dart';
import 'JSONResponseClasses/AdditionalData.dart';
import 'JSONResponseClasses/Address.dart';
import 'JSONResponseClasses/Bank.dart';
import 'JSONResponseClasses/BankOTPResponse.dart';
import 'JSONResponseClasses/BookServiceReq.dart';
import 'JSONResponseClasses/BookServiceResponse.dart';
import 'JSONResponseClasses/FirstResponse.dart';
import 'JSONResponseClasses/GeneratedOTP.dart';
import 'JSONResponseClasses/PortalLogin.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'JSONResponseClasses/TimeSlot.dart';
import 'JSONResponseClasses/UserAccountDetails.dart';
import 'JSONResponseClasses/ValidateOTP.dart';
import 'MainUI.dart';
import 'main.dart';
import 'networkConfig.dart';

class Repository {

  static final Repository _singleton = new Repository._internal();

  var resp = null;
  bool dioError = false;

  factory Repository() {
    return _singleton;
  }

  Repository._internal();

  getOTP(String phoneNumber) async {
    try {
      String json = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"

    },
    "mobilenumber":"$phoneNumber"
    }""";

      String fetchUserDetailsString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"iOS",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"$phoneNumber",
    "type":"login",
    "usertype":"C",
    "ts": "${CommonMethods().getTimeStamp()}"
    }""";

     /* String data = """{ "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
                    "username":"$phoneNumber", "data":"${encrypt(fetchUserDetailsString)}" }""";
      CommonMethods().printLog(data);*/

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      CommonMethods().printLog(response);

      NetworkCommon().netWorkInitilize(GlobalVariables().myContext);
      Response response1 = await NetworkCommon()
          .myDio
          .post("/fetchUserDetails", data: fetchUserDetailsString);

/*
      if(resp is DioError){
        print('response1 : ${response1.statusMessage }');
        print('resp : $resp ');

      }*/


      CommonMethods().printLog("THE Fetch User RESPONSE IS :: $response1");

   /*   var encryptedResponse = jsonDecode(response1.toString());
      EncryptedResponse myEncriptedResponse = EncryptedResponse.fromJson(encryptedResponse);

      var myVar = jsonDecode(decrypt(myEncriptedResponse.data).toString());*/

      var myVar = jsonDecode(response1.toString());
      CommonMethods().printLog("THE Fetch User Decrypted RESPONSE IS :: $myVar");

      GlobalVariables().firstResponse = FirstResponse.fromJson(myVar);

      String generateOTPJSON = """{
        "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"$phoneNumber",
    "ts": "${CommonMethods().getTimeStamp()}"
    }""";

      CommonMethods().printLog("RESPONSE CODE :: ${GlobalVariables().firstResponse.eRRORCODE}");
      if (GlobalVariables().firstResponse.eRRORCODE == "00") {
        CommonMethods().printLog('The data is ${CommonMethods().getEncryptedRequestBeforeLogin(generateOTPJSON, phoneNumber)}');
        Response response2 = await NetworkCommon()
            .myDio
            .post("/generateOTP", data: generateOTPJSON);



        CommonMethods().printLog("THE OTP RESPONSE IS :: $response2");
        var myOTPVar = jsonDecode(response2.toString());
        var oTPResponse = GeneratedOTP.fromJson(myOTPVar);
        // userName = oTPResponse.oUTPUT.firstname;
        CommonMethods().printLog('');
        //CommonMethods().printLog('The User Name is ${oTPResponse.oUTPUT.firstname}');
        CommonMethods().printLog('');


        if (oTPResponse.eRRORCODE == "00") {
          /*
          Response response3 = await NetworkCommon()
              .myDio
              .post("/validateOTP", data: validateOTPJSON);
          CommonMethods().printLog("THE OTP VALIDATE RESPONSE IS :: $response3");*/

          // mySignInBloc.add(EnterOTP());
          resp = "Success";
          return "Success";
        } else {
          CommonMethods().printLog('Something went wrong');
          CommonMethods().printLog("Response :: " + response2.toString());
          resp = response2.toString();
          return response2.toString();
        }
      } else {
        CommonMethods().printLog('Something went wrong');
        CommonMethods().printLog("Response :: " + response1.toString());
        resp = response1.toString();
        return response1.toString();
      }
    } catch (e) {
      CommonMethods().printLog(e);
      if(e is DioError){
        CommonMethods().printLog('Something went wrong');
        CommonMethods().printLog("Response :: " + e.error);
        dioError = true;
        resp = e.error;
        return e.error;
      }
    }
  }

  getOTPSignUp(String phoneNumber) async {
    try {
      String fetchUserJSON = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"iOS",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"

    },
    "mobilenumber":"$phoneNumber",
    "type":"signup",
    "usertype":"C"
    }""";

      String generateOTPJSON = """{
        "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"iOS",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"$phoneNumber"
    }""";

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      CommonMethods().printLog(response);

      AdditionalData myAdditionalData = AdditionalData(
          clientAppVer:"1.0.0",
          clientApptype:"DSB",
          platform:"iOS",
          vendorid:"17",
          clientAppName:"ANIOSCUST"
      );

      FetchUserReq myFetchUserReq = FetchUserReq(
        additionalData: myAdditionalData,
        mobilenumber: phoneNumber,
        type: "signup",
        usertype: "C"
      );

      var finalFetchUserDetailsCall = jsonEncode(myFetchUserReq);

      Response fetchUserResonse = await NetworkCommon()
          .myDio
          .post("/fetchUserDetails", data: myFetchUserReq);

      if(fetchUserResonse is DioError){

        CommonMethods().toast(GlobalVariables().myContext, fetchUserResonse.toString());
      }

      var myFetchRespVar = jsonDecode(fetchUserResonse.toString());

      GlobalVariables().firstResponse = FirstResponse.fromJson(myFetchRespVar);

      CommonMethods().printLog(fetchUserResonse.toString());
      CommonMethods().printLog(GlobalVariables().firstResponse.eRRORCODE);
      CommonMethods().printLog(GlobalVariables().firstResponse.eRRORMSG);
      if (GlobalVariables().firstResponse.oUTPUT[0] != null)
        CommonMethods().printLog(GlobalVariables().firstResponse.oUTPUT[0].firstname);

      CommonMethods().printLog(GlobalVariables().firstResponse.toJson().toString());

      if (GlobalVariables().firstResponse.eRRORCODE == "00") {
        Response generateOTPResponse = await NetworkCommon()
            .myDio
            .post("/generateOTP", data: generateOTPJSON);
        var myOTPVar = jsonDecode(generateOTPResponse.toString());
        var oTPResponse = GeneratedOTP.fromJson(myOTPVar);
        if (oTPResponse.eRRORCODE == "00") {
          resp = "Success";
          return "Success";
        } else {
          CommonMethods().printLog('Something went wrong');
          CommonMethods().printLog("Response :: " + fetchUserResonse.toString());
          resp = fetchUserResonse.toString();
          return fetchUserResonse.toString();
        }
        CommonMethods().printLog(fetchUserResonse.toString());
//      displayToast(fetchUserResonse.toString());

      } else {
        CommonMethods().printLog('Something went wrong');
        CommonMethods().printLog("Response :: " + fetchUserResonse.toString());
        resp = fetchUserResonse.toString();
        return fetchUserResonse.toString();
      }
    } catch (e) {
      CommonMethods().printLog(e);
    }
  }

  doOTPSignUp(String phoneNumber, String otp) async {
    try {
      String validateOTPJSON = """{
                "additionalData":
            {
            "client_app_ver":"1.0.0",
            "client_apptype":"DSB",
            "platform":"ANDROID",
            "vendorid":"17",
            "ClientAppName":"ANIOSCUST"
            },
            "mobilenumber":"$phoneNumber",
            "otp":"$otp"
            }""";

      Response validateOTPResponse = await NetworkCommon().myDio.post(
            "/validateOTP",
            data: validateOTPJSON,
          );
      CommonMethods().printLog('The OTP user sent is $otp');
      var myOTPResponse = jsonDecode(validateOTPResponse.toString());
      var validateOTPObject = ValidateOTP.fromJson(myOTPResponse);

      if (validateOTPObject.eRRORCODE == "00") {
        //  mySignUpBloc.add(RegistrationForm());

        resp = "Success";
        return "Success";
      } else {
        CommonMethods().printLog('Something went wrong');
        CommonMethods().printLog("Response :: " + validateOTPResponse.toString());
        resp = validateOTPResponse.toString();
        return validateOTPResponse.toString();
      }
    } catch (e) {
      CommonMethods().printLog(e);
    }
  }

  Future<String> resendOTP(String phoneNumber) async {
    try {
      String generateOTPJSON = """{
                                 "additionalData":
                             {
                             "client_app_ver":"1.0.0",
                             "client_apptype":"DSB",
                             "platform":"ANDROID",
                             "vendorid":"17",
                             "ClientAppName":"ANIOSCUST"
                             },
                             "mobilenumber":"$phoneNumber",
                             "ts":"${CommonMethods().getTimeStamp()}"
                             }""";
      Response resendOTPResponse = await NetworkCommon().myDio.post("/generateOTP", data: generateOTPJSON);
      var myOTPResponse = jsonDecode(resendOTPResponse.toString());
      var validateOTPObject = ValidateOTP.fromJson(myOTPResponse);

      if (validateOTPObject.eRRORCODE == "00") {

        resp = "Success";
        return "Success";
      } else {
        CommonMethods().printLog('Something went wrong');
        CommonMethods().printLog("Response :: " + resendOTPResponse.toString());
        resp = resendOTPResponse.toString();
        return resendOTPResponse.toString();
      }
    } catch (e) {
      CommonMethods().printLog(e);
    }
  }

  doOTPLogin(String phoneNumber, String otp) async {
    try {
      String enteredOTP = otp;

      String portalLogin2 =
      """{"password":"encoded", "username":"{\\"deviceid\\" : \\"\\",\\"ClientAppName\\":\\"ANIOSCUST\\",\\"operatorid\\" : \\"\\",\\"username\\" : \\"$phoneNumber\\",\\"password\\" : \\"$enteredOTP\\",\\"authtype\\" : \\"O\\",\\"rdxml\\" : \\"\\",\\"accNum\\" : \\"\\",\\"AadhaarAuthReq\\" : \\"\\",\\"vendorid\\" : \\"17\\",\\"platform\\" : \\"ANDROID\\",\\"client_apptype\\" : \\"DSB\\",\\"usertypeinfo\\" : \\"C\\",\\"fcm_id\\" : \\"\\",\\"client_app_ver\\" : \\"1.0.0\\",\\"ts\\" : \\"${CommonMethods().getTimeStamp()}\\"}"}""";


      if(GlobalVariables().encryptionEnabled){
        String userNameData = """{"deviceid" : "","ClientAppName":"ANIOSCUST","operatorid" : "","username" : "$phoneNumber","password" : "$enteredOTP","authtype" : "O","rdxml" : "","accNum" : "","AadhaarAuthReq" : "","vendorid" : "17","platform" : "ANDROID","client_apptype" : "DSB","usertypeinfo" : "C","fcm_id" : "","client_app_ver" : "1.0.0","ts" : "${CommonMethods().getTimeStamp()}"}""";

        String userNameDataValue = encrypt(userNameData);

        String webLoginRequest = """{
        "username":"{\\"username\\":\\"$phoneNumber\\",\\"ts\\":\\"${CommonMethods().getTimeStamp()}\\",\\"data\\":\\"$userNameDataValue\\"}",
        "password":"encoded"
        }""";
        portalLogin2 = webLoginRequest;

      }

      Response response3 = await NetworkCommon().myDio.post(
            "/portallogin",
            data: portalLogin2,
          );
      CommonMethods().printLog("The JSON request is :: $portalLogin2");
      CommonMethods().printLog("THE PORTAL LOGIN RESPONSE IS :: $response3");


      var myVar = jsonDecode(response3.toString());

      CommonMethods().printLog("THE Fetch User Decrypted RESPONSE IS :: $myVar");

      var loginResponse = PortalLogin.fromJson(myVar);

      if (loginResponse.eRRORCODE == "00") {
        GlobalVariables().phoneNumber = loginResponse.oUTPUT.user.mobilenumber;
        GlobalVariables().myPortalLogin = loginResponse;
        CommonMethods().printLog("THE LOGIN RESPONSE IS + ${loginResponse.eRRORCODE}");
        CommonMethods().printLog(
            "THE ACCESS TOKEN IS + ${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}");
        resp = "Success";
        return "Success";
      } else {
        CommonMethods().printLog('Something went wrong');
        CommonMethods().printLog("Response :: " + response3.toString());
        resp = response3.toString();
        return response3.toString();
      }
    } catch (e) {
      CommonMethods().printLog(e);
    }
  }

  Future<void> getServices() async {

    //TODO need to change
    String ts= CommonMethods().getTimeStamp();

    String getServicesString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${GlobalVariables().phoneNumber}",

    "ts": "$ts",
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}"

    }""";
    Response getServicesResponse = await NetworkCommon()
        .myDio
        .post("/getServiceList", data: getServicesString);
    var getServicesResponseString = jsonDecode(getServicesResponse.toString());
    var getServicesResponseObject =
    ServiceList.fromJson(getServicesResponseString);
    CommonMethods().printLog("************************ THE SERVICE RESPONSE IS $getServicesResponseObject");
    // CommonMethods().printLog("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");
    if (getServicesResponseObject == null) {
      return 'Something went wrong';
    } else {
      CommonMethods().printLog("THE Get Service RESPONSE IS + ${getServicesResponseObject.eRRORCODE}");
      return getServicesResponseObject;
    }
    /*CommonMethods().printLog("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT.length}");

    var output = getServicesResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      CommonMethods().printLog(
          '                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    CommonMethods().printLog('             THE SERVICES OFFERED ARE $services                 ');

//    return output;
  return getServicesResponseObject;*/
  }

  Future<TimeSlot> fetchTimeSlots(String theDate) async {
    String d;//pass this in parenthesis
    String todaysDate = DateTime.now().toString().substring(0, 10);
    final now = DateTime.now();
    final tomorrow = new DateTime(now.year, now.month, now.day + 1);
    String tomorrowsDate = tomorrow.toString().substring(0, 10);
    String timeSlotDate;
    if(theDate == 'today'){
      timeSlotDate = todaysDate;
    }
    else{
      timeSlotDate  = tomorrowsDate;
    }
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
    "requesteddate":"$timeSlotDate"
    }""";
    Response fetchTimeSlotResponse = await NetworkCommon()
        .myDio
        .post("/getAvailableSlot", data: fetchTimeSlotsString);
    var getTimeSlotResponseString =
    jsonDecode(fetchTimeSlotResponse.toString());
    var timeSlotObject = TimeSlot.fromJson(getTimeSlotResponseString);

    return timeSlotObject;
  }

  registerCustomer(String phoneNumber, String name, String password, String email, String securityQuestion, String securityAnswer, String alternatemob, String address, String latitude, String longitude, String pincode) async {

    String registerUserJSON = '''{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "username":"$phoneNumber",
	  "password":"$password",
	  "name":"$name",
	  "email":"$email",
	  "mobilenumber":"$phoneNumber",
	  "securityq":"$securityQuestion",
	  "securitya":"$securityAnswer",
	  "alteratemob":"$alternatemob",
	  "address": "$address",
    "latitude": "$latitude",
    "longitude": "$longitude",
    "pincode":"$pincode"
    }''';

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      CommonMethods().printLog(response);
    Response registerUserResponse = await NetworkCommon()
        .myDio
        .post("/customerRegistration", data: registerUserJSON);
    if(registerUserResponse.toString().contains('"ERRORCODE": "00"')){
      GlobalVariables().registrationLatitude = null;
      GlobalVariables().registrationLongitude = null;
      GlobalVariables().addressFromLocation = null ;
      GlobalVariables().pinCodeFromLocation = null;
      return('Registration Successful');
    }
    else{
      return ('Couldn\'t Register');
    }
  }

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
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
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

    return output;
  }

  getComplaintTypes() async {
    String getComplaintType = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "ts": "${CommonMethods().getTimeStamp()}"
    }""";
    Response getComplaintTypeResponse = await NetworkCommon()
        .myDio
        .post("/getComplaintType", data: getComplaintType);
    var getComplaintTypeResponseString = jsonDecode(getComplaintTypeResponse.toString());

    ComplaintType.fromJson(getComplaintTypeResponseString);
    return ComplaintType.fromJson(getComplaintTypeResponseString);;
  }

  removeAddress(String addressId) async {

    String removeAddressString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${GlobalVariables().phoneNumber}",
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
  	"addressid":$addressId

    }""";
    Response removeAddressResponse = await NetworkCommon()
        .myDio
        .post("/removeAddress", data: removeAddressString);
    if (removeAddressResponse.toString().contains('"ERRORCODE": "00"')) {
      return 'Address Deleted Successfully';
    } else {
      return 'Couldn\'t delete address,Please try again';
    }
    /*CommonMethods().printLog("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT.length}");

    var output = getServicesResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      CommonMethods().printLog(
          '                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    CommonMethods().printLog('             THE SERVICES OFFERED ARE $services                 ');

//    return output;
  return getServicesResponseObject;*/
  }

  addAddress(String address, String latitude, String longitude, String pinCode) async {

    //TODO need to change
    String ts= CommonMethods().getTimeStamp();

    String addAddressString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${GlobalVariables().phoneNumber}",
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "address": "$address",
    "latitude": "$latitude",
    "longitude": "$longitude",
    "pincode":"$pinCode",
    "ts":"$ts"
    }""";
    Response addAddressResponse = await NetworkCommon()
        .myDio
        .post("/addAddress", data: addAddressString);
    if (addAddressResponse.toString().contains('"ERRORCODE": "00"')) {
      return 'Address Added Successfully';
    } else {
      return 'Couldn\'t Add address,Please try again';
    }


    /*CommonMethods().printLog("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT.length}");

    var output = getServicesResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      CommonMethods().printLog(
          '                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    CommonMethods().printLog('             THE SERVICES OFFERED ARE $services                 ');

//    return output;
  return getServicesResponseObject;*/
  }

  Future<void> fetchAddress() async {
    String getBankString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
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
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "ts": "${CommonMethods().getTimeStamp()}",
    "type":"ALL"
    }""";
    Response getBankListResponse = await NetworkCommon()
        .myDio
        .post("/getBankList", data: getBankListString);
    CommonMethods().printLog('#############The bank list response is ${getBankListResponse.toString()}');
    var getBankListResponseString =
    jsonDecode(getBankListResponse.toString());
    var getBankListResponseObject =
    Bank.fromJson(getBankListResponseString); // replace with PODO class

    var output = getBankListResponseObject.oUTPUT;

    return getBankListResponseObject;
//    return getBankListResponseObject;
  }

  Future<BankOTPResponse>  fetchUserAccountDetails(String bankCode) async {
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
    "bankcode":"$bankCode",
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "ts": "${CommonMethods().getTimeStamp()}"
    }""";
    CommonMethods().printLog('************The generateOTPBank string is $getBankListString');
    Response getBankListResponse = await NetworkCommon()
        .myDio
        .post("/generateOTPBank", data: getBankListString);
    CommonMethods().printLog('************The generateOTPBank  reposnse string is ${getBankListResponse.toString()}');
    var getBankOTPResponseString = jsonDecode(getBankListResponse.toString());
    if(getBankOTPResponseString.toString().contains('"code":"ECONNREFUSED"')){
      NetworkCommon().showMyDialog('Error', 'ECONNREFUSED');
    }else{
      var getBankOTPResponseObject =
      BankOTPResponse.fromJson(getBankOTPResponseString);

      var output = getBankOTPResponseObject.oUTPUT;
      return getBankOTPResponseObject;
    }
  }

  Future<UserAccountDetails> verifyOTPAndGetAccountDetails(String OTP) async {
    String verifyOTPAndGetAccountDetailsString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${GlobalVariables().phoneNumber}",      
    "bankcode":"${GlobalVariables().bankCode}",
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "ts": "${CommonMethods().getTimeStamp()}",
    "OTP":"$OTP",
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

  Future<void> logout() async {
    return showDialog(
      context: GlobalVariables().myContext,
      child: CupertinoAlertDialog(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(20.0))),
        title: Text('Do you want to Logout from account ${GlobalVariables().phoneNumber}?'),
        content: Text('We\'d hate to see you leave...'),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(GlobalVariables().myContext).pop(false);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ),
          FlatButton(
            onPressed: () async {
              Navigator.push(GlobalVariables().myContext, CupertinoPageRoute(builder: (context) => LoadingIndicator()));
              String logoutString = """{
                          "additionalData":
                    {
                    "client_app_ver":"1.0.0",
                    "client_apptype":"DSB",
                    "platform":"ANDROID",
                    "vendorid":"17",
                    "ClientAppName":"ANIOSCUST"
                    },
                    "ts": "${CommonMethods().getTimeStamp()}",
                    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
                    "username":"${GlobalVariables().phoneNumber}"
                
                    }""";
              Response logoutResponse = await NetworkCommon()
                  .myDio
                  .post("/logout", data: logoutString);
              CommonMethods().printLog(logoutResponse.toString());
              if (logoutResponse.toString().contains('"ERRORCODE":"00')) {
                CommonMethods().printLog('logout success');
                Navigator.of(GlobalVariables().myContext).pop();
//                    Navigator.of(context).pop();
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
              }
              Navigator.of(GlobalVariables().myContext).pop();
              Navigator.push(GlobalVariables().myContext,
                  MaterialPageRoute(builder: (context) => MyHomePage()));
            },
            child: Text(
              'Logout',
              style:
              TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    ) ??
        false;

    /*showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: CupertinoAlertDialog(
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text('Do you want to Logout from  account $phoneNumber?'),
                content: Text(' We\'d hate to see you leave...'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                  ),
                  FlatButton(
                    onPressed: () async {
                      String logoutString = """{
                          "additionalData":
                    {
                    "client_app_ver":"1.0.0",
                    "client_apptype":"DSB",
                    "platform":"ANDROID",
                    "vendorid":"17"
                    },
                    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
                    "authorization":"$accessToken",
                    "username":"$phoneNumber"

                    }""";
                      Response logoutResponse = await NetworkCommon()
                          .myDio
                          .post("/logout", data: logoutString);
                      CommonMethods().printLog(logoutResponse.toString());
                      if (logoutResponse
                          .toString()
                          .contains('"ERRORCODE":"00')) {
                        CommonMethods().printLog('logout success');
                        Navigator.of(context).pop();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {}
        );*/
  }

  Future<BookServiceResponse> bookService([BuildContext context]) async {
    var requestTime = CommonMethods().getEpochTime();
    String date = DateTime.now().toString().substring(0, 10);

    var jason = json.encode(GlobalVariables().listOfParams);
    //String toBeSent = jason.toString().substring(1, jason.toString().length - 1);



    AdditionalData additionalData = AdditionalData(
        clientAppVer:"1.0.0",
        clientApptype:"DSB",
        platform:"ANDROID",
        vendorid:"17",
        clientAppName:"ANIOSCUST"
    );

    BookServiceReq myObj = BookServiceReq(
        additionalData: additionalData,
        mobilenumber:GlobalVariables().phoneNumber,
        customerid:GlobalVariables().myPortalLogin.oUTPUT.user.userid.toString(),
        customername:GlobalVariables().firstResponse.oUTPUT[0].firstname,
        requesttime:requestTime.toString(),
        dEVICEID: "",
        serviceid:GlobalVariables().serviceid,
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
        authorization:GlobalVariables().myPortalLogin.oUTPUT.token.accessToken,
        username:GlobalVariables().phoneNumber,
        ts: CommonMethods().getTimeStamp(),
        latitude:GlobalVariables().latitude,
        longitude:GlobalVariables().longitude,
        pincode:GlobalVariables().pincode,
        servicecode:GlobalVariables().servicecode,
        customParams:GlobalVariables().listOfParams

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


//  CommonMethods().printLog('******************The book Service String is $bookServiceDynamicString');

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
        context: GlobalVariables().myContext,
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
        context: GlobalVariables().myContext,
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

  Future<ComplaintList> getComplaintList(String complaintType) async {
    String getComplaintType = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "ts": "${CommonMethods().getTimeStamp()}",
    "ComplaintType":"$complaintType"
    }""";
    Response getComplaintTypeResponse = await NetworkCommon()
        .myDio
        .post("/getComplaintList", data: getComplaintType);
    var getComplaintTypeResponseString = jsonDecode(getComplaintTypeResponse.toString());

    return ComplaintList.fromJson(getComplaintTypeResponseString);
  }

}

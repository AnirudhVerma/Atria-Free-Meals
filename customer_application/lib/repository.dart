import 'dart:convert';
import 'package:customer_application/GlobalVariables.dart';
import 'package:dio/dio.dart';
import 'JSONResponseClasses/Address.dart';
import 'JSONResponseClasses/FirstResponse.dart';
import 'JSONResponseClasses/GeneratedOTP.dart';
import 'JSONResponseClasses/PortalLogin.dart';
import 'JSONResponseClasses/ServiceList.dart';
import 'JSONResponseClasses/ValidateOTP.dart';
import 'networkConfig.dart';

class Repository {
  static final Repository _singleton = new Repository._internal();

  var resp = null;

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
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"

    },
    "mobilenumber":"$phoneNumber",
    "type":"login",
    "usertype":"C"
    }""";

      print("Resquest :: " + fetchUserDetailsString);

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      print(response);

      NetworkCommon().netWorkInitilize(GlobalVariables().myContext);
      Response response1 = await NetworkCommon()
          .myDio
          .post("/fetchUserDetails", data: fetchUserDetailsString);
      print("THE Fetch User RESPONSE IS :: $response1");

      var myVar = jsonDecode(response1.toString());

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
    "mobilenumber":"$phoneNumber"
    }""";

      print("RESPONSE CODE :: ${GlobalVariables().firstResponse.eRRORCODE}");
      if (GlobalVariables().firstResponse.eRRORCODE == "00") {
        Response response2 = await NetworkCommon()
            .myDio
            .post("/generateOTP", data: generateOTPJSON);
        print("THE OTP RESPONSE IS :: $response2");
        var myOTPVar = jsonDecode(response2.toString());
        var oTPResponse = GeneratedOTP.fromJson(myOTPVar);
        // userName = oTPResponse.oUTPUT.firstname;
        print('');
        //print('The User Name is ${oTPResponse.oUTPUT.firstname}');
        print('');

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
    "otp":"123456"
    }""";

        if (oTPResponse.eRRORCODE == "00") {
          /*
          Response response3 = await NetworkCommon()
              .myDio
              .post("/validateOTP", data: validateOTPJSON);
          print("THE OTP VALIDATE RESPONSE IS :: $response3");*/

          // mySignInBloc.add(EnterOTP());
          resp = "Success";
          return "Success";
        } else {
          print('Something went wrong');
          print("Response :: " + response2.toString());
          resp = response2.toString();
          return response2.toString();
        }
      } else {
        print('Something went wrong');
        print("Response :: " + response1.toString());
        resp = response1.toString();
        return response1.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  getOTPSignUp(String phoneNumber) async {
    try {
      String fetchUserJSON = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
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
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"$phoneNumber"
    }""";

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      print(response);
      Response fetchUserResonse = await NetworkCommon()
          .myDio
          .post("/fetchUserDetails", data: fetchUserJSON);

      var myFetchRespVar = jsonDecode(fetchUserResonse.toString());

      GlobalVariables().firstResponse = FirstResponse.fromJson(myFetchRespVar);

      print(fetchUserResonse.toString());
      print(GlobalVariables().firstResponse.eRRORCODE);
      print(GlobalVariables().firstResponse.eRRORMSG);
      if (GlobalVariables().firstResponse.oUTPUTOBJECT != null)
        print(GlobalVariables().firstResponse.oUTPUTOBJECT.firstname);

      print(GlobalVariables().firstResponse.toJson());

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
          print('Something went wrong');
          print("Response :: " + fetchUserResonse.toString());
          resp = fetchUserResonse.toString();
          return fetchUserResonse.toString();
        }
        print(fetchUserResonse.toString());
//      displayToast(fetchUserResonse.toString());

      } else {
        print('Something went wrong');
        print("Response :: " + fetchUserResonse.toString());
        resp = fetchUserResonse.toString();
        return fetchUserResonse.toString();
      }
    } catch (e) {
      print(e);
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
      print('The OTP user sent is $otp');
      var myOTPResponse = jsonDecode(validateOTPResponse.toString());
      var validateOTPObject = ValidateOTP.fromJson(myOTPResponse);

      if (validateOTPObject.eRRORCODE == "00") {
        //  mySignUpBloc.add(RegistrationForm());

        resp = "Success";
        return "Success";
      } else {
        print('Something went wrong');
        print("Response :: " + validateOTPResponse.toString());
        resp = validateOTPResponse.toString();
        return validateOTPResponse.toString();
      }
    } catch (e) {
      print(e);
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
                             "mobilenumber":"$phoneNumber"
                             }""";




      Response resendOTPResponse = await NetworkCommon().myDio.post("/generateOTP", data: generateOTPJSON);


      var myOTPResponse = jsonDecode(resendOTPResponse.toString());
      var validateOTPObject = ValidateOTP.fromJson(myOTPResponse);

      if (validateOTPObject.eRRORCODE == "00") {

        resp = "Success";
        return "Success";
      } else {
        print('Something went wrong');
        print("Response :: " + resendOTPResponse.toString());
        resp = resendOTPResponse.toString();
        return resendOTPResponse.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  doOTPLogin(String phoneNumber, String otp) async {
    try {
      String enteredOTP = otp;

      String portalLogin2 =
          """{"password":"encoded", "username":"{\\"deviceid\\" : \\"\\",\\"ClientAppName\\":\\"ANIOSCUST\\",\\"operatorid\\" : \\"\\",\\"username\\" : \\"$phoneNumber\\",\\"password\\" : \\"$enteredOTP\\",\\"authtype\\" : \\"O\\",\\"rdxml\\" : \\"\\",\\"accNum\\" : \\"\\",\\"AadhaarAuthReq\\" : \\"\\",\\"vendorid\\" : \\"17\\",\\"platform\\" : \\"ANDROID\\",\\"client_apptype\\" : \\"DSB\\",\\"usertypeinfo\\" : \\"C\\",\\"fcm_id\\" : \\"\\",\\"client_app_ver\\" : \\"1.0.0\\",\\"ts\\" : \\"Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)\\"}"}""";

      Response response3 = await NetworkCommon().myDio.post(
            "/portallogin",
            data: portalLogin2,
          );
      print("The JSON request is :: $portalLogin2");
      print("THE PORTAL LOGIN RESPONSE IS :: $response3");

      var myResponse = jsonDecode(response3.toString());
      var loginResponse = PortalLogin.fromJson(myResponse);

      if (loginResponse.eRRORCODE == "00") {
        GlobalVariables().phoneNumber = loginResponse.oUTPUT.user.mobilenumber;
        GlobalVariables().myPortalLogin = loginResponse;
        print("THE LOGIN RESPONSE IS + ${loginResponse.eRRORCODE}");
        print(
            "THE ACCESS TOKEN IS + ${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}");
        resp = "Success";
        return "Success";
      } else {
        print('Something went wrong');
        print("Response :: " + response3.toString());
        resp = response3.toString();
        return response3.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getServices() async {

    //TODO need to change
    String ts= "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)";


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
    print("************************ THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");




    if (getServicesResponseObject == null) {


      return 'Something went wrong';

    } else {
      print("THE Get Service RESPONSE IS + ${getServicesResponseObject.eRRORCODE}");
      return getServicesResponseObject;
    }



    print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT.length}");

    var output = getServicesResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      print(
          '                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    print('             THE SERVICES OFFERED ARE $services                 ');

//    return output;
  return getServicesResponseObject;
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
//      print(response);
    Response registerUserResponse = await NetworkCommon()
        .myDio
        .post("/customerRegistration", data: registerUserJSON);
    if(registerUserResponse.toString().contains('"ERRORCODE": "00"')){
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

    print('             THE ADDRESSES ARE $address                 ');

    return output;
  }

}

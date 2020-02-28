import 'package:customer_application/JSONResponseClasses/BankOTPResponse.dart';
import 'package:customer_application/JSONResponseClasses/BookServiceResponse.dart';
import 'package:customer_application/JSONResponseClasses/FirstResponse.dart';
import 'package:customer_application/JSONResponseClasses/PortalLogin.dart';
import 'package:customer_application/JSONResponseClasses/SelectedService.dart';
import 'package:customer_application/JSONResponseClasses/ServiceList.dart';
import 'package:customer_application/JSONResponseClasses/UserAccountDetails.dart';
import 'package:flutter/src/widgets/framework.dart';

class GlobalVariables{
  bool encryptionEnabled = true;
  String accessToken = '90';
  String otherString;
  FirstResponse firstResponse = new FirstResponse();
  BankOTPResponse myBankOTPResponse = new BankOTPResponse();
  UserAccountDetails myUserAccountDetails = new UserAccountDetails();
  SelectedService userSelectedService = new SelectedService();
  ServiceList myServiceList = new ServiceList();
  PortalLogin myPortalLogin = new PortalLogin();
  BookServiceResponse myBookServiceResponseObject = new BookServiceResponse();
  List<Map> listOfParams;
  String phoneNumber;
  String serviceid;
  String servicename;
  String servicetype;
  String servicecategory;
  String serviceCharge;
  String pincode;
  String bankCode;
  String bankname;
  String branchcode;
  String branchname;
  int addressid;
  String servicecode;
  String lianAccount;
  String serviceAccount;
  String timeSlot;
  String address;
  String latitude;
  String longitude;
  String registrationLongitude;
  String registrationLatitude;
  String pinCodeFromLocation;
  String addressFromLocation;

  static final GlobalVariables myGlobalVariables = new GlobalVariables._internal();

  BuildContext myContext;

  factory GlobalVariables() {
    return myGlobalVariables;
  }

  GlobalVariables._internal();

}
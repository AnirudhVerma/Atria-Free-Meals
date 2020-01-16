import 'package:customer_application/JSONResponseClasses/BankOTPResponse.dart';
import 'package:customer_application/JSONResponseClasses/FirstResponse.dart';
import 'package:customer_application/JSONResponseClasses/PortalLogin.dart';
import 'package:customer_application/JSONResponseClasses/SelectedService.dart';
import 'package:customer_application/JSONResponseClasses/ServiceList.dart';
import 'package:customer_application/JSONResponseClasses/UserAccountDetails.dart';

class GlobalVariables{
  String accessToken = '90';
  String otherString;
  FirstResponse firstResponse = new FirstResponse();
  BankOTPResponse myBankOTPResponse = new BankOTPResponse();
  UserAccountDetails myUserAccountDetails = new UserAccountDetails();
  SelectedService userSelectedService = new SelectedService();
  ServiceList myServiceList = new ServiceList();
  PortalLogin myPortalLogin = new PortalLogin();
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

  static final GlobalVariables myGlobalVariables = new GlobalVariables._internal();

  factory GlobalVariables() {
    return myGlobalVariables;
  }

  GlobalVariables._internal();

}
import 'package:customer_application/JSONResponseClasses/BankOTPResponse.dart';
import 'package:customer_application/JSONResponseClasses/FirstResponse.dart';
import 'package:customer_application/JSONResponseClasses/UserAccountDetails.dart';

class GlobalVariables{
  String token = '90';
  String otherString;
  FirstResponse firstResponse = new FirstResponse();
  BankOTPResponse myBankOTPResponse = new BankOTPResponse();
  UserAccountDetails myUserAccountDetails = new UserAccountDetails();
  String pin;
  String phoneNumber;

  static final GlobalVariables myGlobalVariables = new GlobalVariables._internal();

  factory GlobalVariables() {
    return myGlobalVariables;
  }

  GlobalVariables._internal();

}
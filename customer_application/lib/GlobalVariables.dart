import 'package:customer_application/JSONResponseClasses/FirstResponse.dart';

class GlobalVariables{
  String token = '90';
  String otherString;
  FirstResponse firstResponse = new FirstResponse();
  String pin;
  String phoneNumber;

  static final GlobalVariables myGlobalVariables = new GlobalVariables._internal();

  factory GlobalVariables() {
    return myGlobalVariables;
  }

  GlobalVariables._internal();

}
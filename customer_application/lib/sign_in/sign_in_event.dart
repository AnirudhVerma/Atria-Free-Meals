import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignInEvent extends Equatable {}

class DoSignInWithPIN extends SignInEvent{
  final String userId;
  final String PIN;

  DoSignInWithPIN({this.userId, this.PIN});

  @override
  List<Object> get props => [userId,PIN];
}

class DoSignInwithOTP extends SignInEvent{
  final String phoneNumber;

  DoSignInwithOTP({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];

}


class EnterOTP extends SignInEvent{
  EnterOTP();
  @override
  List<Object> get props => null;
}




class EventResendOTP extends SignInEvent{
  final String phoneNumber;
  EventResendOTP({this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber];
}

class DoOTPSignIN extends SignInEvent{
  final String phoneNumber;
  DoOTPSignIN({this.phoneNumber});
  @override
  List<Object> get props => [phoneNumber];
}

class ValidateOTPSignIN extends SignInEvent{
  final String phoneNumber;
  final String otp;
  ValidateOTPSignIN({this.phoneNumber,this.otp});
  @override
  List<Object> get props => [phoneNumber,otp];
}
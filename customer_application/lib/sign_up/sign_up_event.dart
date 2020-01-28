import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignUpEvent extends Equatable{}

class GetOTP extends SignUpEvent {


  GetOTP();

  @override
  List<Object> get props => null;
}

class DoOTPSignUP extends SignUpEvent {
  final String phoneNumber;

  DoOTPSignUP({this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}

class EnterSignUpOTP extends SignUpEvent {

  EnterSignUpOTP();

  @override
  List<Object> get props => null;
}

class RegistrationForm extends SignUpEvent{
  RegistrationForm();
  @override
  List<Object> get props => null;
}

class DoOTPSignUp extends SignUpEvent{
  final String phoneNumber;
  final String otp;
  DoOTPSignUp({this.phoneNumber, this.otp});
  @override
  List<Object> get props => [phoneNumber,otp];
}
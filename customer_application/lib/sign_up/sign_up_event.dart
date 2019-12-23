import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignUpEvent extends Equatable{}

class GetOTP extends SignUpEvent {
  final String phoneNumber;

  GetOTP({this.phoneNumber});

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
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class SignUpState extends Equatable {}

class InitialSignUpState extends SignUpState {
  @override
  List<Object> get props => null;
}

class EnterPhoneNumberState extends SignUpState {
  @override
  List<Object> get props => null;
}

class RegistrationFormState extends SignUpState{
  @override
  List<Object> get props => null;
}

class EnterOTPSignUpState extends SignUpState{
  @override
  List<Object> get props => null;
}
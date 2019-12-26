import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SignInState extends Equatable {}

class InitialSignInState extends SignInState {
  @override
  List<Object> get props => null;
}

class LoadingSignInState extends SignInState {
  @override
  List<Object> get props => null;
}

class ErrorSignInState extends SignInState {
  final String errorMessage;
   ErrorSignInState(this.errorMessage);
  @override
  List<Object> get props => [errorMessage];
}

class OTPSignInState extends SignInState {
  @override
  List<Object> get props => null;
}

class EnterOTPState extends SignInState{
  @override
  List<Object> get props => null;
}


class showProgressBar extends SignInState{
  @override
  List<Object> get props => null;
}

class ErrorState extends SignInState{

  final String errorResp;

  ErrorState({this.errorResp});

  @override
  List<Object> get props => [errorResp];

}


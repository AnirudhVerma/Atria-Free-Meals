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

class LoadedSignInState extends SignInState {

  final String loginResponse;

  LoadedSignInState(this.loginResponse);

  @override
  List<Object> get props => [loginResponse];
}

class ErrorSignInState extends SignInState {
  @override
  List<Object> get props => null;
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


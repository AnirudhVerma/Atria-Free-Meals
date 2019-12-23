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


import 'dart:async';
import 'package:bloc/bloc.dart';
import '../bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  @override
  SignUpState get initialState => InitialSignUpState();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    yield InitialSignUpState();
    if(event is RegistrationForm){
      yield RegistrationFormState();
    }
    if(event is EnterSignUpOTP){
      yield EnterOTPSignUpState();
    }

    // TODO: Add Logic
  }
}

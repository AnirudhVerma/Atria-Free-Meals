import 'dart:async';
import 'package:bloc/bloc.dart';
import '../CommonMethods.dart';
import '../bloc.dart';
import '../repository.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  @override
  SignUpState get initialState => InitialSignUpState();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    yield InitialSignUpState();
    if(event is GetOTP){
      yield InitialSignUpState();
    }
    if(event is RegistrationForm){
      yield RegistrationFormState();
    }
    if(event is EnterSignUpOTP){
      yield EnterOTPSignUpState();
    }
    if (event is DoOTPSignUP) {

      yield showProgressBarSignUp();

      String resp = await Repository().getOTPSignUp(event.phoneNumber);
      CommonMethods().printLog('repository().resp : ${Repository().resp }');
      CommonMethods().printLog('resp : $resp ');

      if(Repository().resp == 'Success'){

        yield EnterOTPSignUpState();

      }
      else{
        yield ErrorStateSignUp(errorResp: Repository().resp ); // CommonMethods().printLog the toast message
      }

    }

    if(event is DoOTPSignUp){

      yield showProgressBarSignUp();

      String resp = await Repository().doOTPSignUp(event.phoneNumber, event.otp);
      CommonMethods().printLog('repository().resp : ${Repository().resp }');
      CommonMethods().printLog('resp : $resp ');

      if(Repository().resp == 'Success'){

        yield RegistrationFormState();

      }
      else{
        yield ErrorStateSignUpOtp(errorResp: Repository().resp ); // CommonMethods().printLog the toast message
      }

    }

    // TODO: Add Logic flushbar
  }
}

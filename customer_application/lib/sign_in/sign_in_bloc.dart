import 'package:customer_application/repository.dart';
import '../CommonMethods.dart';
import '../bloc.dart';
import 'dart:async';
import 'package:bloc/bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {



  @override
  SignInState get initialState => InitialSignInState();

  @override
  Stream<SignInState> mapEventToState(
      SignInEvent event,
      ) async* {
    yield LoadingSignInState();
    if (event is DoSignInWithPIN) {
      try {
        String userId = event.userId;
        String PIN = event.PIN;

        yield InitialSignInState();
      } catch (e) {
        yield ErrorSignInState('error Message');
        print(e);
      }
    }
    if (event is DoSignInwithOTP) {
      yield OTPSignInState();
    }
    if (event is EnterOTP) {
      yield EnterOTPState();
    }
    if (event is DoOTPSignIN) {

      yield showProgressBar(); //Comment this

      String resp = await Repository().getOTP(event.phoneNumber);
      print('repository().resp : ${Repository().resp }');
      print('resp : $resp ');

      if(Repository().resp == 'Success'){

        yield EnterOTPState();


      }
      else{

        yield ErrorState(errorResp: Repository().resp, stateScreen: "1"); // print the toast message
      }

    }

    if (event is ValidateOTPSignIN) {

      yield showProgressBar(); //Comment this

      String resp = await Repository().doOTPLogin(event.phoneNumber,event.otp);
      print('repository().resp : ${Repository().resp }');
      print('resp : $resp ');

      if(Repository().resp == 'Success'){

        yield LoginSuccessState();

      }
      else{
        yield ErrorState(errorResp: Repository().resp, stateScreen:"2" ); // print the toast message
      }

    }
    // TODO: Add Logic
  }
}

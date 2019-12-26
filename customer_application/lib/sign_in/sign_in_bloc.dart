import 'package:customer_application/repository.dart';

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
        yield ErrorSignInState();
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

      yield showProgressBar();

      String resp = await repository().getOTP(event.phoneNumber);
      print('repository().resp : ${repository().resp }');
      print('resp : $resp ');



      if(repository().resp == 'Success'){

        yield EnterOTPState();

      }
      else{
        yield ErrorState(errorResp: repository().resp );

      }


    }
    // TODO: Add Logic
  }
}

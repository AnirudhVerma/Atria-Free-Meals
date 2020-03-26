import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/repository.dart';
import 'package:dio/dio.dart';
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
        CommonMethods().printLog(e);
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

      try {
        String resp = await Repository().getOTP(event.phoneNumber);

        CommonMethods().printLog('repository().resp : ${Repository().resp }');
        CommonMethods().printLog('resp : $resp ');
      } catch (e) {
        CommonMethods().printLog(e);
      }

      if(Repository().resp == 'Success'){

        yield EnterOTPState();


      }
      else{

        yield ErrorState(errorResp: Repository().resp, stateScreen: "1"); // CommonMethods().printLog the toast message
      }

    }
    if (event is EventResendOTP) {

//      yield showProgressBar(); //Comment this

      String resp = await Repository().resendOTP(event.phoneNumber);
      CommonMethods().printLog('repository().resp : ${Repository().resp }');
      CommonMethods().printLog('resp : $resp ');

      if(Repository().resp == 'Success'){


        CommonMethods().toast(GlobalVariables().myContext, 'Resend OTP Request Sent');


      }
      else{

       // yield ErrorState(errorResp: Repository().resp, stateScreen: "1");
        CommonMethods().toast(GlobalVariables().myContext, Repository().resp);
      }

    }


    if (event is ValidateOTPSignIN) {

      yield showProgressBar(); //Comment this

      String resp = await Repository().doOTPLogin(event.phoneNumber,event.otp);
      CommonMethods().printLog('repository().resp : ${Repository().resp }');
      CommonMethods().printLog('resp : $resp ');
      CommonMethods().toast(GlobalVariables().myContext, 'resp : $resp ');

      if(Repository().resp == 'Success'){

       /* try {
          GlobalVariables().complaintTypes = await Repository().getComplaintTypes();
        } catch (e) {
          CommonMethods().printLog(e);
        }*/
        yield LoginSuccessState();

      }
      else{
        yield ErrorState(errorResp: Repository().resp, stateScreen:"2" ); // CommonMethods().CommonMethods().printLogLog the toast message
      }

    }
    // TODO: Add Logic
  }
}

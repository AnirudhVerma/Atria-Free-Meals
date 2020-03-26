import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/bloc.dart';
import 'package:customer_application/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'CommonMethods.dart';
import 'JSONResponseClasses/BankOTPResponse.dart';
import 'book_service/book_service_bloc.dart';

class BookServiceNewFlow extends StatefulWidget {
  @override
  _BookServiceNewFlowState createState() => _BookServiceNewFlowState();
}

class _BookServiceNewFlowState extends State<BookServiceNewFlow> {

  final nfBloc = new BookServiceNewBloc();
  final GlobalKey<FormState> _myOTPKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final myBankOTPController = TextEditingController();
  BankOTPResponse myBankOTPResponse;

  @override
  void dispose() {
    // TODO: implement dispose
    nfBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          child: CupertinoAlertDialog(
            title: Text('Cancel Booking?'),
            content: Text('Are you sure you want to cancel your Booking?'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  'Cancel',
                  style:
                  TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book Service'),
        ),
//      body: addressUI(context),
        body: Center(
          child: BlocBuilder<BookServiceNewBloc, BookServiceNewState>(
              bloc: new BookServiceNewBloc(),
              builder: (context, state) {
                if (state is InitialBookServiceNewState) {
                  return  enterOTPUI(context);
                }
                /*if (state is BankListState) {
                  return bankListUI(context);
                }
                if (state is EnterRegisteredNumberState) {
                  return getPhoneNumberUI(context);
                }
                if (state is EnterBankOTPState) {
                  return enterOTPUI(context);
                }
                if (state is AccountListState) {
                  return userAccountDetailsUI(context);
                }
                if (state is BranchListState) {
                  return branchListUI(context);
                }
                if (state is TimeSlotState) {
                  return selectTimeSlotUI(context);
                }
                if (state is LiamAccountListState) {
                  return selectLiamAccountUI(context);
                }
                if( state is BookingResultState){
                  return Container(child: Text('Booking Result UI'),);
                }*/
                if( state is ProgressIndicatorState){
                  return  Container(
                    //color: Colors.lightBlue,
                    child: Center(
                      //child: Loading(indicator: BallPulseIndicator(), size: 100.0,color: Colors.blue),
                      child: Column(
                        children: <Widget>[
                          SpinKitWave(color: Colors.blue,size: 50,),
                          Container(height: 20,),
                          Text('Please wait while we confirm your Request')
                        ],
                      ),
                    ),
                  );
                }
                /*if(state is AccountState){
                  return selectAccountUI(context);
                }*/
                return null;
              }),
        ),
      ),
    );
  }

  Stack enterOTPUI(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        Form(
          key: _myOTPKey,
          autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Hero(
                tag: GlobalVariables().bankname,
                child:
                CircleAvatar(
                  child: new Image(
                      image: new AssetImage('assets/images/bank_icon.png')),maxRadius: 20,
                ),
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 16,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    maxRadius: 10,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Text(
                      'An OTP has been sent to ${GlobalVariables().phoneNumber}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                elevation: 20,
                margin: EdgeInsets.all(18),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          width: 12,
                        ),
                        Text(
                          "Enter OTP",
                          style: TextStyle(color: Colors.blue, fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: new TextFormField(
                        maxLength: 6,
                        obscureText: true,
                        keyboardType: TextInputType.numberWithOptions(),
                        onChanged: (OTP) {
                          if (OTP.length == 6) {
                            FocusScope.of(context).requestFocus(GlobalVariables().myFocusNode);
                          }
                        },
                        validator: (OTP) {
                          if (OTP.length < 6) {
                            return 'Please enter 6 digits OTP!';
                          }
                          if (GlobalVariables().nonDigit.hasMatch(OTP)) {
                            return 'Please enter only Numbers!';
                          }
                          return null;
                        },
                        controller: myBankOTPController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16.0),
                          prefixText: ' ',
                          prefixStyle: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          hintText: "OTP",
                          suffixIcon: Icon(
                            Icons.lock,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: ArgonButton(
                        height: 50,
                        width: 350,
                        borderRadius: 5.0,
                        color: Colors.blue,
                        child: Text(
                          "Proceed",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        loader: Container(
                          padding: EdgeInsets.all(10),
                          child: SpinKitRotatingCircle(
                            color: Colors.white,
                            // size: loaderWidth ,
                          ),
                        ),
                        onTap: (startLoading, stopLoading, btnState) async {

//                          startLoading();
//                          _validateOTPInput();

//                          _validateOTPInput1();
                          if(_validateOTPInput1() == 0 && btnState == ButtonState.Idle){
                            CommonMethods().toast(context,
                                'The Entered OTP is ${myBankOTPController.text}');
                            startLoading();
                            btnState = ButtonState.Busy;
                            GlobalVariables().myUserAccountDetails = await Repository().verifyOTPAndGetAccountDetails(myBankOTPController.text);
                            if (GlobalVariables().myUserAccountDetails.eRRORMSG == 'SUCCESS'){
//                              myBookServiceBloc.add(FetchAccountList());
                            }
                            else{
                              CommonMethods().toast(context, GlobalVariables().myUserAccountDetails.eRRORMSG);
                              btnState = ButtonState.Idle;
                              stopLoading();
                            }
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text('Did not recieve OTP'),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Spacer(flex: 1,),
              SizedBox(height: 10),
              /*ArgonTimerButton(
                elevation: 5.0,
                color: Colors.redAccent,
                initialTimer: 30,
                // Optional
                height: 50,
                width: MediaQuery.of(context).size.width * 0.45,
                minWidth: MediaQuery.of(context).size.width * 0.30,
                borderRadius: 30.0,
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                loader: (_timeLeft) {
                  return Text(
                    "Wait | $_timeLeft  ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  );
                },
                onTap: (startTimer, btnState) async {
                  if (btnState == ButtonState.Idle) {
                    myBankOTPResponse = await Repository().fetchUserAccountDetails(GlobalVariables().phoneNumber);
                    if(myBankOTPResponse.toString().contains('"ERRORCODE":"00')){
                      CommonMethods()
                          .toast(context, 'Resend OTP request sent Successfully');
                    }
                    else{
                      CommonMethods()
                          .toast(context, 'Couldn\'t send request, please try again');
                    }
//                              startTimer(30);
                  }
                  if (btnState == ButtonState.Busy) {
                    CommonMethods()
                        .toast(context, 'Please wait for the timer to stop to resend OTP');
                  }
                },
              ),*//**/
              SizedBox(height: 40),
            ],
          ),
        ),
      ],
    );
  }

  Stack selectAccountUI(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: WaveClipperTwo(),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            height: 200,
          ),
        ),
        ListView.builder(
          itemCount: GlobalVariables().myUserAccountDetails.oUTPUT.length,
          itemBuilder: (context, index) {
            {
              var output = GlobalVariables().myUserAccountDetails.oUTPUT[index];
              return Card(
                child: ListTile(
                  title: Text(output.accountnumber[index].toString()),
                  leading: new CircleAvatar(
                    child: new Image(
                        image: new AssetImage(
                            'assets/images/bank_account_icon.png')),
                  ),
                  onTap: () {
                    // Do something
                  },
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6)),
              );
            }
          },
        )
      ],
    );
  }

  int _validateOTPInput1(){
    if (_myOTPKey.currentState.validate()) {
      return 0;
    }
    else {
      setState(() {
        _autoValidate = true;
        return 1;
      });
    }
  }

}

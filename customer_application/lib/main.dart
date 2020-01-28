import 'dart:convert';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:customer_application/CommonMethods.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/JSONResponseClasses/FirstResponse.dart';
import 'package:customer_application/JSONResponseClasses/PortalLogin.dart';
import 'package:customer_application/MainUI.dart';
import 'package:customer_application/MyMapsApp.dart';
import 'package:customer_application/SignUpUI.dart';
import 'package:customer_application/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'JSONResponseClasses/GeneratedOTP.dart';
import 'SizeConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SizeRoute.dart';
import 'JSONResponseClasses/ValidateOTP.dart';
import 'networkConfig.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

/*Future<void> main() async {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  bool jailBroken = await FlutterJailbreakDetection.jailbroken;
  if(jailBroken){
    AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      title: Text('This device is JailBroken'),
      content: Text('The app will now quit'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: Text('Quit'),
        ),
      ],
    );
  }
  else{
    runApp(MyApp());
  }
}*/

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final navKey = new GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    //NetworkCommon().netWorkInitilize(context);
  //  GlobalVariables().myContext = context;
    return MaterialApp(
//      title: 'DSB Customer',
      navigatorKey: MyApp.navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'HelveticaNeueLight',
      ),
      home: BlocProvider(
//          builder: (context) => SignInBloc(),
//          child: MyHomePage(title: 'DSB Customer')),
          builder: (context) => SignInBloc(),
          child: MyHomePage()),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

//  final String title;
  static final navKey = new GlobalKey<NavigatorState>();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _autoValidate = false;
  bool notVisible = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final myController = TextEditingController();
  final myOTPController = TextEditingController();
  final nonDigit = new RegExp(r"(\D+)");
  final mySignInBloc = new SignInBloc();
  String thePhoneNumber;
  String userName;
  var _myFocusNode = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    GlobalVariables().myContext = MyApp.navKey.currentState.overlay.context;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().initialize(context);

    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: false,
      /*appBar: AppBar(
        title: Text(widget.title),
      ),*/
      body: /*buildCenterInitial(),*/ Center(
        child: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: BlocBuilder<SignInBloc, SignInState>(
              bloc: mySignInBloc,
              builder: (context, state) {
                if (state is InitialSignInState) {
//            return buildCenterInitialPIN();
//          return myListView();
                  return buildCenterOTP();
                }
                if (state is LoadingSignInState) {
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                if (state is ErrorSignInState) {
                  return Center(child: Text('Login UnSuccessful'));
                }
                if (state is OTPSignInState) {
                  return buildCenterOTP();
                }
                if (state is EnterOTPState) {
                  return buildCenterEnterOTP();
                }
                if (state is showProgressBar) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is ErrorState) {
                  var data = state.errorResp;
                  if (state.errorResp == null) {
                    data = "OOPS, something went wrong";
                  }
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(data),
                        MaterialButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(18.0),
                          ),
                          child: Text(
                            'Retry',
                            style: TextStyle(
                                color: Colors.white,
                            fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            mySignInBloc.add(DoSignInwithOTP());
                          },
                        ),
                      ],
                  );
                }
                return null;
              }),
        ),
      ),
    );
  }

  Container buildCenterInitialPIN() {
    return Container(
      alignment: Alignment.center,
      //  color: Colors.grey[200],
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/myBackground.png'),
          fit: BoxFit.cover,
        ),
        gradient: RadialGradient(
          // Where the linear gradient begins and ends
//            begin: Alignment.topRight,
//            end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          radius: 0.1,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.blue[400],
            Colors.blue[300],
            Colors.blue[200],
            Colors.blue[50],
          ],
        ),
      ),
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 20,
        margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 2),
        // previous-10   0.8     SizeConfig.blockSizeHorizontal
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 3.5),
              //previous-36     SizeConfig.blockSizeHorizontal * 1.5
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
//                  SizedBox(height: 35.0),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                      child: Image(
                        image: AssetImage('assets/images/blue_door.png'),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    Text(
                      " Door-Step Banking",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.blue,
                        fontFamily: 'HelveticaNeue',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    /*Text(
                        "DOOR-STEP BANKING",

                        style: TextStyle(fontSize: SizeConfig.permanentBlockSize * 2.5 ,
                            color: Colors.blue,
                            fontWeight: FontWeight.normal),
                      ),*/
                    SizedBox(
                      height: 10.0,
                    ),
                    signinTextRow(),
                    SizedBox(
                      height: 10.0,
                    ),
                    phoneNumberInput(),
                    SizedBox(
                      height: 15.0,
                      child: Container(
//                      color: Colors.blue,
                          ),
                    ),
                    pinInput(),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[Text("Forgot Pin?")],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    loginWithPINRow(),
                    SizedBox(
                      height: 15.0,
                    ),
//                  signUpRow(),
                    workingRow(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        " -OR- ",
                        style: TextStyle(
                            //fontSize: SizeConfig.permanentBlockSize * 1.5 ,
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
//                              BlocProvider.of<SignInBloc>(context);
                          mySignInBloc.add(DoSignInwithOTP());
                        },
                        child: Text(
                          " Sign-in with OTP ",
                          style: TextStyle(
                              //fontSize: SizeConfig.permanentBlockSize * 1.5 ,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container buildCenterOTP() {
    return Container(
      alignment: Alignment.center,
      //  color: Colors.grey[200],
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/myBackground.png'),
          fit: BoxFit.cover,
        ),
        gradient: RadialGradient(
          // Where the linear gradient begins and ends
//            begin: Alignment.topRight,
//            end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          radius: 0.1,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.blue[400],
            Colors.blue[300],
            Colors.blue[200],
            Colors.blue[50],
          ],
        ),
      ),
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 20,
        margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),  // previous 2
        // previous-10   0.8     SizeConfig.blockSizeHorizontal
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4), // previous 2.5
            //previous-36     SizeConfig.blockSizeHorizontal * 1.5
            child: Form(
              key: _formKey,
              autovalidate: _autoValidate,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
//                  SizedBox(height: 35.0),
                  Text(
                    ' Door Step Banking',
                    style: TextStyle(
                      fontSize: 26,
                      color: Colors.blue,
                      fontFamily: 'HelveticaNeue',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                    child: Image(
                      image: AssetImage('assets/images/blue_door.png'),
                      height: 100,
                      width: 100,
                    ),
                  ),
                  /*Text(
                        "DOOR-STEP BANKING",
                        style: TextStyle(fontSize: SizeConfig.permanentBlockSize * 2.5 ,
                            color: Colors.blue,
                            fontWeight: FontWeight.normal),
                      ),*/
                  SizedBox(
                    height: 10.0,
                  ),
                  signinTextRow(),
                  SizedBox(
                    height: 10.0,
                  ),
                  phoneNumberInput(),
//                    SizedBox(
//                      height: 15.0,
//                    ),
//                    OTPInput(),
                  SizedBox(
                    height: 15.0,
                  ),
                  loginWithOTPRow(),
                  SizedBox(
                    height: 15.0,
                  ),
//                  signUpRow(),
                  workingRow(),
                  SizedBox(
                    height: 20.0,
                  ),
               /*   Center(
                    child: Text(
                      " -OR- ",
                      style: TextStyle(
                          fontSize: 18,
                          //previous SizeConfig.permanentBlockSize * 1.5
                          color: Colors.black,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        mySignInBloc.add(DoSignInWithPIN());
                      },
                      child: Text(
                        " Sign-in with PIN ",
                        style: TextStyle(
                            //fontSize: SizeConfig.permanentBlockSize * 1.5 ,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildCenterEnterOTP() {
    return Container(
      alignment: Alignment.center,
      //  color: Colors.grey[200],
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/myBackground.png'),
          fit: BoxFit.cover,
        ),
        gradient: RadialGradient(
          // Where the linear gradient begins and ends
//            begin: Alignment.topRight,
//            end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          radius: 0.1,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            // Colors are easy thanks to Flutter's Colors class.
            Colors.blue[400],
            Colors.blue[300],
            Colors.blue[200],
            Colors.blue[50],
          ],
        ),
      ),
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 20,
        margin: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
        // previous-10   0.8     SizeConfig.blockSizeHorizontal
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 4),
              //previous-36     SizeConfig.blockSizeHorizontal * 1.5
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
//                  SizedBox(height: 35.0),
                    Text(
                      " Door-Step Banking",
                      style: TextStyle(
                        fontSize: 26,
                        color: Colors.blue,
                        fontFamily: 'HelveticaNeue',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 50.0),
                      child: Image(
                        image: AssetImage('assets/images/blue_door.png'),
                        height: 100,
                        width: 100,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    OTPPhoneNumberTextRow(),
                    SizedBox(
                      height: 10.0,
                    ),
                    OTPInput(),
                    SizedBox(
                      height: 15.0,
                    ),
                    //loginWithOTPRow(),
                    Center(
                      child: ArgonTimerButton(
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
                          "Resend OTP",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        loader: (timeLeft) {
                          return Text(
                            "Wait | $timeLeft  ",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          );
                        },
                        onTap: (startTimer, btnState) {
                          if (btnState == ButtonState.Idle) {
                            String generateOTPJSON = """{
                                 "additionalData":
                             {
                             "client_app_ver":"1.0.0",
                             "client_apptype":"DSB",
                             "platform":"ANDROID",
                             "vendorid":"17",
                             "ClientAppName":"ANIOSCUST"
                             },
                             "mobilenumber":"${GlobalVariables().phoneNumber}"
                             }""";
  //                          NetworkCommon().netWorkInitilize(context);
                            NetworkCommon()
                                  .myDio
                                  .post("/generateOTP", data: generateOTPJSON);
//                            generateOTP(myController.text);
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
//                  signUpRow(),
                    workingRow(),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        " -OR- ",
                        style: TextStyle(
                            fontSize: 18,
                            //previous SizeConfig.permanentBlockSize * 1.5
                            color: Colors.black,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          mySignInBloc.add(DoSignInWithPIN());
                        },
                        child: Text(
                          " Sign-in with PIN ",
                          style: TextStyle(
                              //fontSize: SizeConfig.permanentBlockSize * 1.5 ,
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  /*DELETE myListView*/

/*  ListView myListView() {
    return ListView(
      children: <Widget>[
        Container(
          height: 490,
          decoration: BoxDecoration(
              boxShadow: [
                new BoxShadow(
                  color: Colors.black26,
                  offset: new Offset(0.0, 2.0),
                  blurRadius: 25.0,
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32))),
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(16),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  'Welcome to keells.',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 16, top: 8),
                child: Text(
                  'Let\'s get started',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 32, bottom: 8),
                child: TextField(
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    hintText: 'Name',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'E-Mail Address',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: 18),
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.green, shape: BoxShape.circle),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pushNamed(context, '/grocerry/verify');
                      },
                      icon: Icon(Icons.arrow_forward),
                    ),
                  )),
            ],
          ),
        ),
      ],
    );
  }*/



  Row workingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Don't have an account? "),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                CupertinoPageRoute(builder: (context) => MySignUpPage()));
          },
          child: Text(
            "Sign up!",
            style: TextStyle(color: Colors.green),
          ),
        ),
      ],
    );
  }

  void getOTP(String phoneNumber) async {
    try {
      String json = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17"

    },
    "mobilenumber":"$phoneNumber"
    }""";

      String fetchUserDetailsString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"

    },
    "mobilenumber":"$phoneNumber",
    "type":"login"
    }""";


      print('Context is not null ${context.toString()}');
      print("Resquest111 :: " + fetchUserDetailsString);

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      print(response);
     // NetworkCommon().netWorkInitilize(context);
      Response response1 =
          await NetworkCommon().myDio.post("/fetchUserDetails", data: fetchUserDetailsString);

      Map<String, dynamic> map = jsonDecode(response1.toString());
      var myVar = jsonDecode(response1.toString());
      var firstResponse = FirstResponse.fromJson(myVar);
      userName = firstResponse.oUTPUTOBJECT.firstname;

      String generateOTPJSON = """{
        "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"$phoneNumber"
    }""";


      print("RESPONSE CODE :: ${firstResponse.eRRORCODE}");
      if (firstResponse.eRRORCODE == "00") {
        Response response2 = await NetworkCommon()
            .myDio
            .post("/generateOTP", data: generateOTPJSON);
        print("THE GENERATE OTP RESPONSE IS :: $response2");
        var myOTPVar = jsonDecode(response2.toString());
        var oTPResponse = GeneratedOTP.fromJson(myOTPVar);
        // userName = oTPResponse.oUTPUT.firstname;

        String validateOTPJSON = """{
        "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"$phoneNumber",
    "otp":"123456"
    }""";

        if (oTPResponse.eRRORCODE == "00") {
          /*
          Response response3 = await NetworkCommon()
              .myDio
              .post("/validateOTP", data: validateOTPJSON);
          print("THE OTP VALIDATE RESPONSE IS :: $response3");*/
          mySignInBloc.add(EnterOTP());
        }
      } else {
        print('Something went wrong');
      }

//        var parsedJson = json.decode(response1);

      print("Response :: " + response1.toString());
      Fluttertoast.showToast(
          msg: response1.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white);
    } catch (e) {
      print(e);
      showDialog(context: context,
          builder: (context) => AlertDialog(
            title: Text('Error in Main'),
            content: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                  child: Text('OK'),
                  onPressed: (){
                    Navigator.pop(context);
                  }

              ),
            ],
          ));
    }
  }

  generateOTP(String phoneNumber) async {
    String generateOTPJSON = """{
        "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"$phoneNumber"
    }""";
    Response response2 =
        await NetworkCommon().myDio.post("/generateOTP", data: generateOTPJSON);
    print('GENERATE OTP RESPONSE IS $response2');
  }

  Future navigateTosignUp(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MySignUpPage()));
  }

  Widget phoneNumberInput() {
    return TextFormField(
      maxLength: 10,
      obscureText: false,
      keyboardType: TextInputType.numberWithOptions(),
        onChanged: (phoneNumber){
        if(phoneNumber.length == 10){
          FocusScope.of(context).requestFocus(_myFocusNode);
        }
        },
      validator: (phoneNumber) {
        if (phoneNumber.length < 10) {
          return 'Please enter a valid Phone Number!';
        }
        if (nonDigit.hasMatch(phoneNumber)) {
          return 'Please enter only Numbers!';
        }
        return null;
      },
      controller: myController,
//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          prefixText: '+91 ',
          prefixStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          hintText: "Phone Number",
          suffixIcon: Icon(
            Icons.phone,
            color: Colors.blue,
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget OTPInput() {
    return TextFormField(
      maxLength: 6,
      obscureText: false,
      keyboardType: TextInputType.numberWithOptions(),
      onChanged: (OTP){
        if(OTP.length == 6){
          FocusScope.of(context).requestFocus(_myFocusNode);
        }
      },
      validator: (OTP) {
        if (nonDigit.hasMatch(OTP)) {
          return 'Please enter only Numbers!';
        }
        return null;
      },
      controller: myOTPController,
//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          prefixStyle:
              TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          hintText: "Enter OTP",
          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              Icons.send,
              color: Colors.blue,
            ),
            onPressed: () async {
              String phoneNumber = myController.text;
              String OTP = myOTPController.text;
              String validateOTPJSON = """{
                    "additionalData":
                {
                "client_app_ver":"1.0.0",
                "client_apptype":"DSB",
                "platform":"ANDROID",
                "vendorid":"17",
                "ClientAppName":"ANIOSCUST"
                },
                "mobilenumber":"$phoneNumber",
                "otp":"${myOTPController.text}"
                }""";

              String enteredOTP = myOTPController.text;

              String portalLogin2 =
                  """{"password":"encoded", "username":"{\\"deviceid\\" : \\"\\",\\"ClientAppName\\":\\"ANIOSCUST\\",\\"operatorid\\" : \\"\\",\\"username\\" : \\"$phoneNumber\\",\\"password\\" : \\"$enteredOTP\\",\\"authtype\\" : \\"O\\",\\"rdxml\\" : \\"\\",\\"accNum\\" : \\"\\",\\"AadhaarAuthReq\\" : \\"\\",\\"vendorid\\" : \\"17\\",\\"platform\\" : \\"ANDROID\\",\\"client_apptype\\" : \\"DSB\\",\\"usertypeinfo\\" : \\"C\\",\\"fcm_id\\" : \\"\\",\\"client_app_ver\\" : \\"1.0.0\\",\\"ts\\" : \\"Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)\\"}"}""";

              Response response3 = await NetworkCommon().myDio.post(
                    "/portallogin",
                    data: portalLogin2,
                  );
              print("The JSON request is :: $portalLogin2");
              print("THE PORTAL LOGIN RESPONSE IS :: $response3");

              var myResponse = jsonDecode(response3.toString());
              var loginResponse = PortalLogin.fromJson(myResponse);
              GlobalVariables().phoneNumber = loginResponse.oUTPUT.user.mobilenumber;
              GlobalVariables().myPortalLogin = loginResponse;            // TODO: fetch mobile number from from login response instead of creating a separate variable
              CommonMethods().toast(context, loginResponse.eRRORMSG);
              print("THE LOGIN RESPONSE IS + ${loginResponse.eRRORCODE}");
              print("THE ACCESS TOKEN IS + ${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}");
              print('');

              if (loginResponse.eRRORCODE == "00") {
                Fluttertoast.showToast(
                    msg: "Login Successful!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        builder: (context) => MyMainPage(
                              /*title: 'Welcome $userName!',
                              phoneNumber: phoneNumber,
                              userid: loginResponse.oUTPUT.user.userid,  // TODO: stop sending userid from one widget to other
                              accessToken:
                                  loginResponse.oUTPUT.token.accessToken,*/
                            )));
              } else {
                Fluttertoast.showToast(
                    msg: "Login not Successful ${loginResponse.eRRORMSG}",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              /*var myOTPValidation = jsonDecode(response3.toString());
              var oTPResponse = ValidateOTP.fromJson(myOTPValidation);
              print("THE VALIDATION RESPONSE IS + ${oTPResponse.eRRORCODE}");
              if (oTPResponse.eRRORCODE == "00") {
                Fluttertoast.showToast(
                    msg: "LOGIN SUCCESSFUL!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.blue,
                    textColor: Colors.white);
              }*/
            },
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget pinInput() {
    return TextFormField(
      obscureText: notVisible,
      maxLength: 6,
      keyboardType: TextInputType.numberWithOptions(),
      validator: (pin) {
        if (pin.length < 6) {
          return 'Please enter a 6 digit pin!';
        }
        if (nonDigit.hasMatch(pin)) {
          return 'Please Enter only Numbers!';
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "       PIN",

//          suffixIcon: Icon(
//            Icons.lock,
//            color: Colors.blue,
//          ),

          suffixIcon: IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              Icons.lock,
              color: Colors.blue,
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                if (notVisible == true) {
                  notVisible = false;
                } else if (notVisible == false) {
                  notVisible = true;
                }
              });
            },
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget loginWithPINButton() {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: SizeConfig.blockSizeHorizontal * 70,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => MySignUpPage()));

//            BlocProvider.of<SignInBloc>(context).add(DoSignIn(userId: " ", OTP: " ")); // this is the one!!

            Fluttertoast.showToast(
                msg: MediaQuery.of(context).orientation.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIos: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white);
            _validateInputs();

            /*return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(myController.text),
                );
              },
            );*/
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => MySignUpPage()),
//            );
          },
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget loginWithOTPButton() {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: SizeConfig.blockSizeHorizontal * 70,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (context) => MySignUpPage()));

//            BlocProvider.of<SignInBloc>(context).add(DoSignIn(userId: " ", OTP: " ")); // this is the one!!

            _validateInputs();

            /*return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(myController.text),
                );
              },
            );*/
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => MySignUpPage()),
//            );
          },
          child: Text(
            "Get OTP",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget enterOTPButton() {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: SizeConfig.blockSizeHorizontal * 70,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            _validateInputs();

            /*return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text(myController.text),
                );
              },
            );*/

          },
          child: Text(
            "Get OTP",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget enterArgonOTPButton() {
    return ArgonButton(
      elevation: 5.0,
      minWidth: SizeConfig.blockSizeHorizontal * 70,
      borderRadius: 30.0,
      color: Colors.blue,
      padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      child: Text(
        "Get OTP",
        style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700
        ),
      ),
      loader: Container(
        padding: EdgeInsets.all(10),
        child: SpinKitRotatingCircle(
          color: Colors.white,
          // size: loaderWidth ,
        ),
      ),
      onTap: (startLoading, stopLoading, btnState) {
        startLoading();
        _validateInputs();
      },
    );
  }


  Widget loginWithPINRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        SizedBox(width: 230.0,),
        Container(
            child: Align(
                alignment: Alignment.center, child: loginWithPINButton())),
      ],
    );
  }

  Widget loginWithOTPRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        SizedBox(width: 230.0,),
        Container(
            child: Align(alignment: Alignment.center, child: enterOTPButton())),
      ],
    );
  }

  Widget enterOTPRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
//        SizedBox(width: 230.0,),
        Container(
            child: Align(
                alignment: Alignment.center, child: loginWithOTPButton())),
      ],
    );
  }

  Widget loginRow2() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        loginWithPINButton(),
      ],
    );
  }

  Widget signUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Text(
            "Don't have an account?",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            /*return showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  // Retrieve the text the user has entered by using the
                  // TextEditingController.
                  content: Text('Sign-Up Dude!!'),
                );
              },
            );*/
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MySignUpPage()));
            child:
            new Text(
              "Sign-Up",
              style: TextStyle(color: Colors.green),
            );
          },
        ),
      ],
    );
  }

  Widget signinTextRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "  Sign-In to Continue",
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
      ],
    );
  }

  Widget OTPPhoneNumberTextRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          "  We've sent an OTP to ${myController.text}",
          style: TextStyle(
              fontSize: 16,
              fontFamily: 'HelveticaNeue',
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
      ],
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables

      String phoneNumber = myController.text;
      mySignInBloc.add(DoOTPSignIN(phoneNumber: phoneNumber));

//      _formKey.currentState.save();
    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
    mySignInBloc.close();
  }
}

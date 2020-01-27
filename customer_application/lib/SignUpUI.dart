import 'dart:convert';
import 'package:customer_application/CommonMethods.dart';
import 'package:customer_application/JSONResponseClasses/ValidateOTP.dart';
import 'package:customer_application/MyMapsApp.dart';
import 'package:customer_application/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'JSONResponseClasses/GeneratedOTP.dart';
import 'SizeConfig.dart';
import 'networkConfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:crypto/crypto.dart';

/*void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          builder: (context) => SignUpBloc(),
          child: MySignUpPage(title: 'DSB Customer')),
    );
  }
}*/

class MySignUpPage extends StatefulWidget {
  MySignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MySignUpPageState createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  final myController = TextEditingController();
  final myPINController = TextEditingController();
  final myNameController = TextEditingController();
  final myAddressController = TextEditingController();
  final myOTPController = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _registrationFormKey = GlobalKey<FormState>();
  final nonAlphabet = new RegExp(r"(\W+)");
  final nonDigit = new RegExp(r"(\D+)");
  bool notVisible = true;
  final mySignUpBloc = new SignUpBloc();
  static var myItems = [
    'Question One',
    'Question Two',
    'Question Three',
    'Question Four',
    'Question Five'
  ];
  var _myFocusNode = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Sign-Up!'),
      ),
      body: /*buildCenterInitial(),*/ Center(
        child: BlocBuilder<SignUpBloc, SignUpState>(
            bloc: mySignUpBloc,
            builder: (context, state) {
              if (state is InitialSignUpState) {
                return getOTPUI();
              }
              if (state is RegistrationFormState) {
                return registrationFormUI();
              }
              if (state is EnterOTPSignUpState) {
                return enterOTPUI();
              }
              return null;
            }),
      ),
//      floatingActionButton: FloatingActionButton(onPressed: () {},
//        child: loginButton(),
//      ),
//      floatingActionButton: FloatingActionButton(
//        onPressed: null,
//        tooltip: 'Increment',
//        child: Icon(Icons.add),
//      ), // This trailing comma makes auto-formatting nicer for build methods.here!!!!!
    );

    /*return Container(
      child: Column(
        children: <Widget>[
          Center(
            child:
                BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
              if (state is EnterPhoneNumberState) {
                return getOTPUI();
              }
              if (state is InitialSignUpState) {
                return getOTPUI();
              }
              return null;
                 */ /*return Scaffold(
                   appBar: AppBar(
                     title: Text("Default UI"),
                ),
              );*/ /*

            }),
          ),
          Center(
            child: Text("Centre Text"),
          )
        ],
      ),
    );*/
  }

  Container getOTPUI() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/myBackground.png'),
          fit: BoxFit.cover,
        ),
        gradient: RadialGradient(
          // Where t/*decoration: BoxDecoration(
          //            image: DecorationImage(
          //              image: AssetImage('assets/images/myBackground.png'),
          //              fit: BoxFit.cover,
          //            ),*/he linear gradient begins and ends
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
      //  color: Colors.grey[200],

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
                key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      " Sign-Up!",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    phoneNumberInput(),
                    SizedBox(height: 10),
                    OTPButton(),
                    SizedBox(height: 10),

                    /*nameInput(),
                    SizedBox(height: 10),
                    addressInput(),
                    SizedBox(height: 10),
                    alternatePhoneNumberInput(),
                    SizedBox(height: 10),
                    passwordInput(),
                    SizedBox(height: 10),
                    Text('Security Question',),
                    dropDown(),*/
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container enterOTPUI() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/myBackground.png'),
          fit: BoxFit.cover,
        ),
        gradient: RadialGradient(
          // Where t/*decoration: BoxDecoration(
          //            image: DecorationImage(
          //              image: AssetImage('assets/images/myBackground.png'),
          //              fit: BoxFit.cover,
          //            ),*/he linear gradient begins and ends
//            begin: Alignment.topRight,
//            end: Alignment.bottomLeft,
          // Add one stop for each color. Stops should increase from 0 to 1
          radius: 0.1,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.blue[400],
            Colors.blue[300],
            Colors.blue[200],
            Colors.blue[50],
          ],
        ),
      ),
      //  color: Colors.grey[200],

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
                key: _formKey1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 10),
                    Text(
                      " Enter OTP",
                      style: TextStyle(
                          fontSize: 24,
                          color: Colors.blue,
                          fontFamily: 'HelveticaNeue',
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          " We've sent an OTP to ${myController.text}",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'HelveticaNeue',
                              fontWeight: FontWeight.bold,
                              color: Colors.blueAccent),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    OTPInput(),
                    SizedBox(height: 10),
                    validateOTPButton(),
                    SizedBox(height: 10),

                    /*nameInput(),
                    SizedBox(height: 10),
                    addressInput(),
                    SizedBox(height: 10),
                    alternatePhoneNumberInput(),
                    SizedBox(height: 10),
                    passwordInput(),
                    SizedBox(height: 10),
                    Text('Security Question',),
                    dropDown(),*/
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Container registrationFormUI() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/myBackground.png'),
          fit: BoxFit.cover,
        ),
        gradient: RadialGradient(
          radius: 0.1,
          stops: [0.1, 0.5, 0.7, 0.9],
          colors: [
            Colors.blue[400],
            Colors.blue[300],
            Colors.blue[200],
            Colors.blue[50],
          ],
        ),
      ),
      //  color: Colors.grey[200],
          child : Card(
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
                    key: _registrationFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Text('Sign-up :  ${myController.text}',
                            style: TextStyle(
                                fontSize: 22,
//                            fontFamily: 'HelveticaNeue',
                                fontWeight: FontWeight.bold,
                                color: Colors.blue)),
                        SizedBox(height: 20),
                        nameInput(),
                        SizedBox(height: 10),
                        addressInput(),
                        SizedBox(height: 10),
                        alternatePhoneNumberInput(),
                        SizedBox(height: 10),
                        pinInput(),
                        SizedBox(height: 10),
                        confirmPinInput(),
                        SizedBox(height: 10,),
                        emailInput(),
                        SizedBox(height: 10,),
                        Text('Select a Security Question',),
                        dropDown(),
                        SizedBox(height: 10,),
                        securityAnswerInput(),
                        SizedBox(height: 10,),
                        CupertinoButton(child: Text('Add Address'), onPressed: () {
                          Navigator.push(context, CupertinoPageRoute(builder: (context) => MyMapsApp()));
                        },),
                        SizedBox(height: 10,),
                        signUpButton(),
                      ],
                    ),
                  )),
            ),
          ),
    );
  }

  String dropdownValue = myItems[1];

  @override
  Widget build1(BuildContext context) {
    return Scaffold(
      body: Center(
        child: dropDown(),
      ),
    );
  }

  Widget dropDown() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: DropdownButton<String>(
          value: dropdownValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.blue),
          isExpanded: true,
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String newValue) {
            setState(() {
              dropdownValue = newValue;
            });
          },
          items: myItems.map<DropdownMenuItem<String>>((String value1) {
            return DropdownMenuItem<String>(
              value: value1,
              child: Text(value1),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myController.dispose();
    mySignUpBloc.close();
  }

  Widget emailInput() {
    return TextField(
      obscureText: false,

//      style: style,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(16.0),
            hintText: "E-Mail",
            suffixIcon: Icon(
              Icons.mail,
              color: Colors.blue,
            ),
            border:
            OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget nameInput() {
    return TextFormField(
      obscureText: false,
      validator: (name) {
        if (nonAlphabet.hasMatch(name)) {
          return 'Please enter only Alphabets!';
        }
        return null;
      },

//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "Name",
          suffixIcon: Icon(
            Icons.person,
            color: Colors.blue,
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget securityAnswerInput() {
    return TextFormField(
      obscureText: false,
        keyboardType: TextInputType.numberWithOptions(),
      validator: (name) {
        if (nonAlphabet.hasMatch(name)) {
          return 'Please enter only Alphabets!';
        }
        return null;
      },

//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "Security Answer",
          suffixIcon: Icon(
            Icons.security,
            color: Colors.blue,
          ),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget addressInput() {
    return TextFormField(
      obscureText: false,
//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "Address",
          suffixIcon: Icon(
            Icons.place,
            color: Colors.blue,
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
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
        if (OTP.length < 6) {
          return 'Please enter 6 digit OTP!';
        }
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
          hintText: "OTP",
          suffixIcon: Icon(
            Icons.lock,
            color: Colors.blue,
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget alternatePhoneNumberInput() {
    return TextFormField(
      maxLength: 10,
      obscureText: false,
      keyboardType: TextInputType.numberWithOptions(),
      validator: (phoneNumber) {
        if (phoneNumber.length < 10) {
          return 'Please enter a valid Phone Number!';
        }
        if (nonDigit.hasMatch(phoneNumber)) {
          return 'Please enter only Numbers!';
        }
        if (myController.text == phoneNumber) {
          return 'Please Enter Alternate Phone Number!';
        }
        return null;
      },
//      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "Alternate Phone Number",
          suffixIcon: Icon(
            Icons.phone,
            color: Colors.blue,
          ),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(30.0))),
    );
  }

  Widget pinInput() {
    return TextFormField(
      maxLength: 6,
      obscureText: notVisible,
      keyboardType: TextInputType.numberWithOptions(),
      validator: (password) {
        if (password.length < 8) {
          return 'Password must be atlesast 8 characters!';
        }
        return null;
      },
      controller: myPINController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "Pin",
          suffixIcon: IconButton(
            icon: Icon(
              Icons.lock,
              color: Colors.blue,
            ),
            onPressed: () {
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

  Widget confirmPinInput() {
    return TextFormField(
      maxLength: 6,
      obscureText: notVisible,
      keyboardType: TextInputType.numberWithOptions(),
      validator: (password) {
        if (password.length < 8) {
          return 'Password must be atlesast 8 characters!';
        }
        if (password != myPINController.text){
          return 'PIN\'s don\'t match';
        }
        return null;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(16.0),
          hintText: "Confirm Pin",
          suffixIcon: IconButton(
            icon: Icon(
              Icons.lock,
              color: Colors.blue,
            ),
            onPressed: () {
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

  void displayToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white);
  }

  Widget OTPButton() {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.blue,
        child: MaterialButton(
//          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {
            _validateInputs();

//            if (myController.text.length == 10) {
//              getOTP(myController.text);
//            }
//            else{
//              displayToast("Please Enter Valid Number");
//            }

//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => MyApp2()),
//            );
          },
          child: Text(
            "GET OTP",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ));
  }

  Widget validateOTPButton() {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.blue,
        child: MaterialButton(
//          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () async {
            //Implement Logic

            String validateOTPJSON = """{
                "additionalData":
            {
            "client_app_ver":"1.0.0",
            "client_apptype":"DSB",
            "platform":"ANDROID",
            "vendorid":"17",
            "ClientAppName":"ANIOSCUST"
            },
            "mobilenumber":"${myController.text}",
            "otp":"${myOTPController.text}"
            }""";

            Response validateOTPResponse = await NetworkCommon().myDio.post(
                  "/validateOTP",
                  data: validateOTPJSON,
                );
            print('The OTP user sent is ${myOTPController.text}');
            var myOTPResponse = jsonDecode(validateOTPResponse.toString());
            var validateOTPObject = ValidateOTP.fromJson(myOTPResponse);

            if (validateOTPObject.eRRORCODE == "00") {
              /*
          Response response3 = await NetworkCommon()
              .myDio
              .post("/validateOTP", data: validateOTPJSON);
          print("THE OTP VALIDATE RESPONSE IS :: $response3");*/

              mySignUpBloc.add(RegistrationForm());
            } else {
              CommonMethods().toast(context, validateOTPObject.eRRORMSG);
              /*Fluttertoast.showToast(
                  msg: "${validateOTPObject.eRRORMSG}",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.blue,
                  textColor: Colors.white);*/
            }

//            if (myController.text.length == 10) {
//              getOTP(myController.text);
//            }
//            else{
//              displayToast("Please Enter Valid Number");
//            }

//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => MyApp2()),
//            );
          },
          child: Text(
            "Verify OTP",
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ));
  }

  void getOTP(String phoneNumber) async {
    try {
      String fetchUserJSON = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"

    },
    "mobilenumber":"$phoneNumber",
    "type":"signup"
    }""";

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

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      print(response);
      Response fetchUserResonse = await NetworkCommon()
          .myDio
          .post("/fetchUserDetails", data: fetchUserJSON);
      Response generateOTPResponse = await NetworkCommon()
          .myDio
          .post("/generateOTP", data: generateOTPJSON);
      var myOTPVar = jsonDecode(generateOTPResponse.toString());
      var oTPResponse = GeneratedOTP.fromJson(myOTPVar);
      if (oTPResponse.eRRORCODE == "00") {
        /*
          Response response3 = await NetworkCommon()
              .myDio
              .post("/validateOTP", data: validateOTPJSON);
          print("THE OTP VALIDATE RESPONSE IS :: $response3");*/

//        final SignUpBloc = BlocProvider.of<SignUpBloc>(context);
        mySignUpBloc.add(EnterSignUpOTP());
      }
      print(fetchUserResonse.toString());
      displayToast(fetchUserResonse.toString());
    } catch (e) {
      print(e);
    }
  }

  void registerCustomer(String phoneNumber, String name, String password, String email, String securityQuestion, String securityAnswer, String alternatemob, String address, String latitude, String longitude, String pincode) async {
      String registerUserJSON = '''{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"

    },
    "username":"$phoneNumber",
	  "password":"$password",
	  "name":"$name",
	  "email":"$email",
	  "mobilenumber":"$phoneNumber",
	  "securityq":"$securityQuestion",
	  "securitya":"$securityAnswer",
	  "alteratemob":"$alternatemob",
	  "address": "$address",
    "latitude": "$latitude",
    "longitude": "$longitude",
    "pincode":"$pincode"

    }''';

//      Response response = await Dio().post("http://192.168.0.135:30000/kiosk/doorstep/generateOTP", data: formData);
//      print(response);
      Response registerUserResponse = await NetworkCommon()
          .myDio
          .post("/customerRegistration", data: registerUserJSON);

  }

  Widget signUpButton() {
    return Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: SizeConfig.blockSizeHorizontal * 70,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {

            //Replace with registrationFormValidate inputs

            _validateInputs();

            if(_registrationFormKey.currentState.validate()){
            //  make register user api call
            //  registerCustomer(phoneNumber, name, password, email, securityQuestion, securityAnswer, alternatemob, address, latitude, longitude, pincode);
            }
            else{
              setState(() {});
            }

          },
          child: Text(
            "Sign-Up!",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ));
  }

  void _validateInputs() {
    if (_formKey1.currentState.validate()) {
//    If all data are correct then save data to out variables
      getOTP(myController.text);
    } else {
//    If all data are not valid then start auto validation.
      setState(() {});
    }
  }

  /*@override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("My Title"),
      ),
      body: Row(
        mainAxisAlignment : MainAxisAlignment.start,
        mainAxisSize : MainAxisSize.max,
        crossAxisAlignment : CrossAxisAlignment.center,

        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: "Name"
            ),
          ),
        ],
      ),

      */ /*floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),*/ /* // This trailing comma makes auto-formatting nicer for build methods.here!!!!!
    );
  }*/

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
  }
}

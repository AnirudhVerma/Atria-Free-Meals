import 'dart:convert';

import 'package:customer_application/BookService.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/JSONResponseClasses/FirstResponse.dart';
import 'package:customer_application/JSONResponseClasses/ServiceList.dart';
import 'package:customer_application/ManageAddress.dart';
import 'package:customer_application/bloc.dart';
import 'package:customer_application/main.dart';
import 'package:customer_application/repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'CompletedServicesDialog.dart';
import 'OnGoingServiceDialog.dart';
import 'SizeConfig.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:customer_application/CommonMethods.dart';
import 'networkConfig.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const Color _colorOne = Color(0x33000000);
const Color _colorTwo = Color(0x24000000);
const Color _colorThree = Color(0x1F000000);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Main Screen',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyMainPage(title: 'DSB Customer'));
  }
}

class MyMainPage extends StatefulWidget {
  MyMainPage({Key key, title}) : super(key: key);

  final String title =
      'Welcome ${GlobalVariables().myPortalLogin.oUTPUT.user.name}!';
  final int userid = GlobalVariables().myPortalLogin.oUTPUT.user.userid;
  final String phoneNumber = GlobalVariables().phoneNumber;
  final String accessToken =
      GlobalVariables().myPortalLogin.oUTPUT.token.accessToken;

  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  int _currentIndex = 0;
  PageController _pageController;
  String title;
  String phoneNumber = GlobalVariables().phoneNumber;
  String accessToken = GlobalVariables().myPortalLogin.oUTPUT.token.accessToken;
  int userid = GlobalVariables().myPortalLogin.oUTPUT.user.userid;

//  FirstResponse myUserData = FirstResponse().myFirstResponse;
  FirstResponse fr = new FirstResponse();

  _MyMainPageState();

  GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  final Map<int, Widget> services = const <int, Widget>{
    0: Text('Completed'),
    1: Text('On-Going'),
  };

  Map<int, Widget> icons = <int, Widget>{
    0: new CompletedServicesDialog(),
    1: /*Center(
      child: Center(child: Center(child: new OnGoingServiceDialog())),),*/
        new OnGoingServiceDialog(),
    /*2: Center(
      child: FlutterLogo(
        colors: Colors.cyan,
        size: 200.0,
      ),
    ),*/
  };

  int currentValue = 0;

  Future<void> logout() async {
    return showDialog(
          context: context,
          child: CupertinoAlertDialog(
//            shape: RoundedRectangleBorder(
//                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text('Do you want to Logout from account $phoneNumber?'),
            content: Text('We\'d hate to see you leave...'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ),
              FlatButton(
                onPressed: () async {
                  String logoutString = """{
                          "additionalData":
                    {
                    "client_app_ver":"1.0.0",
                    "client_apptype":"DSB",
                    "platform":"ANDROID",
                    "vendorid":"17",
                    "ClientAppName":"ANIOSCUST"
                    },
                    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
                    "authorization":"$accessToken",
                    "username":"$phoneNumber"
                
                    }""";
                  Response logoutResponse = await NetworkCommon()
                      .myDio
                      .post("/logout", data: logoutString);
                  print(logoutResponse.toString());
                  if (logoutResponse.toString().contains('"ERRORCODE":"00')) {
                    print('logout success');
                    Navigator.of(context).pop();
//                    Navigator.of(context).pop();
//                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));
                  }
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyHomePage()));
                },
                child: Text(
                  'Logout',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ) ??
        false;

    /*showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: CupertinoAlertDialog(
//                shape: RoundedRectangleBorder(
//                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                title: Text('Do you want to Logout from  account $phoneNumber?'),
                content: Text(' We\'d hate to see you leave...'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('No', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
                  ),
                  FlatButton(
                    onPressed: () async {
                      String logoutString = """{
                          "additionalData":
                    {
                    "client_app_ver":"1.0.0",
                    "client_apptype":"DSB",
                    "platform":"ANDROID",
                    "vendorid":"17"
                    },
                    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
                    "authorization":"$accessToken",
                    "username":"$phoneNumber"
                
                    }""";
                      Response logoutResponse = await NetworkCommon()
                          .myDio
                          .post("/logout", data: logoutString);
                      print(logoutResponse.toString());
                      if (logoutResponse
                          .toString()
                          .contains('"ERRORCODE":"00')) {
                        print('logout success');
                        Navigator.of(context).pop();
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {}
        );*/
  }

  Widget servicesWidget() {
    var output;
    return FutureBuilder(
      future: Repository().getServices(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.hasError) {
          print('some error occured');
          print('project snapshot data is: ${servicesSnapShot.data}');
          return Center(
            child: Text(
                '/*ERROR OCCURED, Please retry ${servicesSnapShot.data} : ${servicesSnapShot.data}*/'),
            //    child: Text('/*${servicesSnapShot.data.eRRORCODE} : ${servicesSnapShot.data.eRRORMSG}*/'),
          );
        } else if (servicesSnapShot.data == null &&
            servicesSnapShot.connectionState == ConnectionState.waiting) {
          print('The data is in loading state');
          print('project snapshot data is: ${servicesSnapShot.data}');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
//          print('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.oUTPUT.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data.oUTPUT[index];
                print(
                    'project snapshot data is: ${servicesSnapShot.data.oUTPUT}');
                return Card(
                  child: ListTile(
                    title: Text(output.servicename),
                    subtitle: Text('Service Charge : ${output.serviceCharge}'),
                    leading: CircleAvatar(
                      child: new Image(
                          image:
                              new AssetImage(getIconPath(output.servicecode))),
                    ),
                    onTap: () {
                      output = servicesSnapShot.data.oUTPUT[index];
                      /*print('******************** THE OUTPUT IS ${output.toString()}');
                      GlobalVariables().userSelectedService = output;*/ //unable to instantiate the userSelecteeService
                      GlobalVariables().serviceid = output.serviceid;
                      GlobalVariables().servicename = output.servicename;
                      GlobalVariables().servicetype = output.servicetype;
                      GlobalVariables().servicecategory =
                          output.servicecategory;
                      GlobalVariables().serviceCharge = output.serviceCharge;
                      GlobalVariables().servicecode = output.servicecode;
                      CommonMethods().toast(context, output.servicecode);
                      print(
                          '******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
                      String servicename;
                      if (output.servicecode == 'ACCSTMT') {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return MyDialog();
                            });
                      } else if (output.servicecode == 'CHQCTL') {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return MyChequeDialog();
                            });
                      }
                      /*Navigator.push(
                          context,
                          new CupertinoPageRoute(
                              builder: (context) =>
                                  BookService( )));*/
                    },
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                );
              }
            },
          );
        }
      },
    );
  }

  String getIconPath(String serviceCode) {
    if (serviceCode == 'CHQCTL') {
      return 'assets/images/cheque.png';
    }
    if (serviceCode == 'ACCSTMT') {
      return 'assets/images/bank-statement.png';
    }
  }

  /*Future<void> getServices() async {
    String getServicesString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "mobilenumber":"${GlobalVariables().phoneNumber}",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}"

    }""";
    Response getServicesResponse = await NetworkCommon()
        .myDio
        .post("/getServiceList", data: getServicesString);
    var getServicesResponseString = jsonDecode(getServicesResponse.toString());
    var getServicesResponseObject =
        ServiceList.fromJson(getServicesResponseString);
    print("************************ THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT.length}");

    var output = getServicesResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      print(
          '                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    print('             THE SERVICES OFFERED ARE $services                 ');

    return output;
    print(accessToken);
    print(getServicesResponse);
  }*/

  /*static Widget bookingHistoryWidget() {
    var output;
    return FutureBuilder(
      future: getBookingHistory(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.data == null) {
          print('The data is in loading state');
          print('project snapshot data is: ${servicesSnapShot.data}');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
//          print('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data[index];
                print('project snapshot data is: ${servicesSnapShot.data}');
                return ListTile(
                  title: Text(output.servicename),
                  subtitle: Text('Service Charge : ${output.serviceCharge}'),
                  onTap: () {
                    output = servicesSnapShot.data[index];
                    */ /*print('******************** THE OUTPUT IS ${output.toString()}');
                    GlobalVariables().userSelectedService = output;*/ /*                   //unable to instantiate the userSelectedService
                    */ /*GlobalVariables().serviceid = output.serviceid;
                    GlobalVariables().servicename = output.servicename;
                    GlobalVariables().servicetype = output.servicetype;
                    GlobalVariables().servicecategory = output.servicecategory;
                    GlobalVariables().serviceCharge = output.serviceCharge;
                    GlobalVariables().servicecode = output.servicecode;*/ /*
                    print('******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
                    String servicename;
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) =>
                                BookService()));
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  static Future<void> getBookingHistory() async {
    String getBookingHistoryString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "username":"${GlobalVariables().phoneNumber}",
    "DEVICEID": "",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token}",
    "username":"${GlobalVariables().phoneNumber}",
    "startindex":1,
   	"limit":10
    }""";

    Response getBookingHistoryResponse = await NetworkCommon()
        .myDio
        .post("/getBookingHistory", data: getBookingHistoryString);
    var getBookingHistoryResponseString = jsonDecode(getBookingHistoryResponse.toString());
    var getBookingHistoryResponseObject =
    ServiceList.fromJson(getBookingHistoryResponseString);
    //print("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    print("THE SERVICE RESPONSE IS ${getBookingHistoryResponseObject.oUTPUT.length}");

    var output = getBookingHistoryResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      print(
          '                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    print('             THE SERVICES OFFERED ARE $services                 ');

    return output;
    //print(accessToken);
  }*/

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Welcome ${GlobalVariables().firstResponse.oUTPUTOBJECT.firstname}!'),
          automaticallyImplyLeading: false,
        ),
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Select a Service',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Expanded(child: servicesWidget()),
                  ],
                ),
              ),
              Container(
                  child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  SizedBox(
                    width: 500.0,
                    child: CupertinoSegmentedControl<int>(
                      children: services,
                      onValueChanged: (int val) {
                        setState(() {
                          currentValue = val;
                        });
                      },
                      groupValue: currentValue,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 32.0,
                        horizontal: 16.0,
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white,
                          borderRadius: BorderRadius.circular(3.0),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              offset: Offset(0.0, 3.0),
                              blurRadius: 5.0,
                              spreadRadius: -1.0,
                              color: _colorOne,
                            ),
                            BoxShadow(
                              offset: Offset(0.0, 6.0),
                              blurRadius: 10.0,
                              spreadRadius: 0.0,
                              color: _colorTwo,
                            ),
                            BoxShadow(
                              offset: Offset(0.0, 1.0),
                              blurRadius: 18.0,
                              spreadRadius: 0.0,
                              color: _colorThree,
                            ),
                          ],
                        ),
                        child: icons[currentValue],
                      ),
                    ),
                  ),
                ],
              )
                  /*CupertinoSegmentedControl<int>(
                  children: services,
                  onValueChanged: (int val){
                    setState(() {
                      currentValue = val;
                    });
                  },
                  groupValue: currentValue,
                ),*/
                  ),
              Container(
                color: Colors.blue,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Center(
                          child: Text(
                        'Need Help?',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      )),
                    ),
                    ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Image(
                            image: new AssetImage('assets/images/123392.png')),
                      ),
                      title: Text('Cancel and Re-schedule Servie'),
                    ),
                    ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Image(
                            image: new AssetImage('assets/images/1698558.png')),
                      ),
                      title: Text('FAQ'),
                    ),
                    ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Image(
                            image: new AssetImage('assets/images/1458279.png')),
                      ),
                      title: Text('Terms & Conditions'),
                    ),
                    ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Image(
                            image: new AssetImage('assets/images/1698540.png')),
                      ),
                      title: Text('Prvacy Policy'),
                    ),
                    ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Image(
                            image: new AssetImage('assets/images/1997427.png')),
                      ),
                      title: Text('Lodge Grivence'),
                    ),
                    ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Image(
                            image: new AssetImage('assets/images/199086.png')),
                      ),
                      title: Text('Track Grivence'),
                    ),
                    ListTile(
                      leading: new CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: new Image(
                            image: new AssetImage('assets/images/1716885.png')),
                      ),
                      title: Text('App Info'),
                    ),
                  ],
                ),
              ),
              Container(
                //color: Colors.purple,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/blue_door.png'),
                                fit: BoxFit.scaleDown,
                              ),
                            ),
                          ),
                          Text(
                            'DoorStep Banking',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,

                                fontSize: 18),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      "https://i.imgur.com/BoN9kdC.png")))),
                      SizedBox(
                        height: 20,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5,),
                              Text('Name'),
                              Spacer(flex: 1,),
                              Text('${GlobalVariables().myPortalLogin.oUTPUT.user.name}', style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(flex: 1,),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5,),
                              Text('Phone Number'),
                              Spacer(flex: 1,),
                              Text('${GlobalVariables().myPortalLogin.oUTPUT.user.mobilenumber}', style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(flex: 1,),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5,),
                              Text('Alternate PhoneNumber'),
                              Spacer(flex: 1,),
                              Text('${GlobalVariables().myPortalLogin.oUTPUT.user.alternatenumber}', style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(flex: 1,),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.mail,
                                color: Colors.blue,
                              ),
                              SizedBox(width: 5,),
                              Text('Email'),
                              Spacer(flex: 1,),
                              Text('${GlobalVariables().myPortalLogin.oUTPUT.user.email}', style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(flex: 1,),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) => ManageAddress()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 5,),
                                Text('Address'),
                                Spacer(flex: 1,),
                                Text('Manage Address', style: TextStyle(fontWeight: FontWeight.bold),),
                                Spacer(flex: 1,),
                              ],
                            ),
                          ),
                        ),
                        elevation: 1,
                      ),
                      SizedBox(height: 5,),
                      Center(
                          child: CupertinoButton(
                        child: Text(
                          'LOGOUT',style: TextStyle(color: Colors.white),
                        ),
                        onPressed: logout,
                        color: Colors.red,
                      )),
                      Center(
                          child: CupertinoButton(
                            child: Text(
                              'LOGOUT',style: TextStyle(color: Colors.red),
                            ),
                            onPressed: logout,

                          )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          onItemSelected: (index) {
            setState(() => _currentIndex = index);
            _pageController.jumpToPage(index);
          },
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text('Home'),
                activeColor: Colors.blueGrey,
                inactiveColor: Colors.blue,
                icon: Icon(Icons.home)),
            BottomNavyBarItem(
                title: Text('My Services'),
                activeColor: Colors.red,
                inactiveColor: Colors.blue,
                icon: Icon(Icons.apps)),
            /*BottomNavyBarItem(
                title: Text('OnGoing Services'),
                activeColor: Colors.green,
                inactiveColor: Colors.blue,
                icon: Icon(Icons.chat_bubble)),*/
            BottomNavyBarItem(
                title: Text('Support'),
                activeColor: Colors.blue,
                inactiveColor: Colors.blue,
                icon: Icon(Icons.help)),
            BottomNavyBarItem(
                title: Text('Profile'),
                activeColor: Colors.purple,
                inactiveColor: Colors.blue,
                icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }

/*bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: 4,
          onTap: changePage,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        elevation: 8,
//        fabLocation: BubbleBottomBarFabLocation.end,
        //new
        hasNotch: true,
        //new
        hasInk: true,
        //new, gives a cute ink effect
//          inkColor: Colors.black12 //optional, uses theme color if not specified
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.red,
              icon: Icon(
                Icons.home,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurple,
              icon: Icon(
                Icons.access_time,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.deepPurple,
              ),
              title: Text("My Services")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.folder_open,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.folder_open,
                color: Colors.indigo,
              ),
              title: Text("OnGoing")),
          BubbleBottomBarItem(
              backgroundColor: Colors.green,
              icon: Icon(
                Icons.menu,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: Colors.green,
              ),
              title: Text("Help")),
          BubbleBottomBarItem(
              backgroundColor: Colors.blue,
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              activeIcon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              title: Text("Profile"))
        ],
      ),*/

}

/*
class OnGoingServiceDialog extends StatefulWidget {
  @override
  _OnGoingServiceDialogState createState() => new _OnGoingServiceDialogState();
}

class _OnGoingServiceDialogState extends State<OnGoingServiceDialog> {

  @override
  Widget build(BuildContext context) {
    var output;
    return FutureBuilder(
      future: getBookingHistory(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.data == null) {
          print('The data is in loading state');
          print('project snapshot data is: ${servicesSnapShot.data}');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
//          print('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data[index];
                print('project snapshot data is: ${servicesSnapShot.data}');
                return ListTile(
                  title: Text(output.servicename),
                  subtitle: Text('Service Charge : ${output.serviceCharge}'),
                  onTap: () {
                    output = servicesSnapShot.data[index];
                    */
/*print('******************** THE OUTPUT IS ${output.toString()}');
                    GlobalVariables().userSelectedService = output;*/ /*
                   //unable to instantiate the userSelecteeService
                    */
/*GlobalVariables().serviceid = output.serviceid;
                    GlobalVariables().servicename = output.servicename;
                    GlobalVariables().servicetype = output.servicetype;
                    GlobalVariables().servicecategory = output.servicecategory;
                    GlobalVariables().serviceCharge = output.serviceCharge;
                    GlobalVariables().servicecode = output.servicecode;*/ /*

                    print('******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
                    String servicename;
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) =>
                                BookService()));
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Future<void> getBookingHistory() async {
    String getBookingHistoryString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17",
    "ClientAppName":"ANIOSCUST"
    },
    "username":"${GlobalVariables().phoneNumber}",
    "DEVICEID": "",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
    "userid":${GlobalVariables().myPortalLogin.oUTPUT.user.userid},
    "authorization":"${GlobalVariables().myPortalLogin.oUTPUT.token.accessToken}",
    "username":"${GlobalVariables().phoneNumber}",
    "startindex":1,
   	"limit":10
    }""";

    Response getBookingHistoryResponse = await NetworkCommon()
        .myDio
        .post("/getBookingHistory", data: getBookingHistoryString);
    var getBookingHistoryResponseString = jsonDecode(getBookingHistoryResponse.toString());
    var getBookingHistoryResponseObject =
    ServiceList.fromJson(getBookingHistoryResponseString);
    //print("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    print("THE SERVICE RESPONSE IS ${getBookingHistoryResponseObject.oUTPUT.length}");

    var output = getBookingHistoryResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      print(
          '                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    print('             THE SERVICES OFFERED ARE $services                 ');

    return output;
    //print(accessToken);
  }

}
*/

class MyDialog extends StatefulWidget {
  @override
  _MyDialogState createState() => new _MyDialogState();
} //TODO: Use Imported Class instead

class _MyDialogState extends State<MyDialog> {
  String _date = "Not set";
  String _toDate = 'Not Set';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('Request Account Statement',  style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            'Request Account Statement',
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            //padding: EdgeInsets.all(15.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showDatePicker(
                            context,
                            theme: DatePickerTheme(
                              containerHeight: 210.0,
                            ),
                            onChanged: (date) {
                              print('confirm $date');
                              _date =
                                  '${date.year} - ${date.month} - ${date.day}';
                              setState(() {
                                _date =
                                    '${date.year} - ${date.month} - ${date.day}';
                              });
                            },
                            showTitleActions: true,
                            minTime: DateTime(2000, 1, 1),
                            maxTime: DateTime(2022, 12, 31),
                            onConfirm: (date) {
                              print('confirm $date');
                              _date =
                                  '${date.year} - ${date.month} - ${date.day}';
                              setState(() {
                                _date =
                                    '${date.year} - ${date.month} - ${date.day}';
                              });
                            },
                            currentTime: DateTime.now(),
                            locale: LocaleType.en,
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                " From",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          " $_date",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 20.0,
                        width: 500,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true,
                              minTime: DateTime(2000, 1, 1),
                              maxTime: DateTime(2022, 12, 31),
                              onConfirm: (date) {
                            print('confirm $date');
                            _toDate =
                                '${date.year} - ${date.month} - ${date.day}';
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                " To",
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.date_range,
                                          size: 18.0,
                                          color: Colors.blue,
                                        ),
                                        Text(
                                          " $_toDate",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18.0),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                minWidth: 100,
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  /* ... */
                },
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                minWidth: 100,
                color: Colors.blue,
                child: Text(
                  'PROCEED',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (_date == 'Not set' || _toDate == 'Not set') {
                    CommonMethods().toast(context, 'Please Select Date');
                  } else {
                    Navigator.push(
                        context,
                        new CupertinoPageRoute(
                            builder: (context) => BookService()));
                  }
                  /* ... */
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MyChequeDialog extends StatefulWidget {
  @override
  _MyChequeDialogState createState() => new _MyChequeDialogState();
}

class _MyChequeDialogState extends State<MyChequeDialog> {
  String _date = "Not set";
  String _toDate = 'Not Set';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // title: Text('Request Account Statement',  style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(6))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 15,
          ),
          Text(
            'Pickup Cheque Instrument',
            style: TextStyle(
                color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15,
          ),
          Center(
            //padding: EdgeInsets.all(15.0),
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text('      Leaf Count'),
                          dropDown(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            'Credit Slip Filled',
                          ),
                          booleanDropDown(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                minWidth: 100,
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  /* ... */
                },
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                minWidth: 100,
                color: Colors.blue,
                child: Text(
                  'PROCEED',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      new CupertinoPageRoute(
                          builder: (context) => BookService()));
                  /* ... */
                },
              ),
              /*MaterialButton(
                minWidth:120,
                color: Colors.blue,
                child: Text('PROCEED', style: TextStyle(color: Colors.white),),
              ),*/
            ],
          ),
        ],
      ),
    );
  }

  String dropdownValue = myItems[1];
  static var myItems = ['One', 'Two', 'Three', 'Four', 'Five'];

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
          isExpanded: false,
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

  String slipValue = yesNO[1];
  static var yesNO = [
    'Yes',
    'No',
  ];

  Widget booleanDropDown() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: DropdownButton<String>(
          value: slipValue,
          icon: Icon(Icons.arrow_downward),
          iconSize: 24,
          elevation: 16,
          style: TextStyle(color: Colors.blue),
          isExpanded: false,
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String newValue) {
            setState(() {
              slipValue = newValue;
            });
          },
          items: yesNO.map<DropdownMenuItem<String>>((String value1) {
            return DropdownMenuItem<String>(
              value: value1,
              child: Text(value1),
            );
          }).toList(),
        ),
      ),
    );
  }
}

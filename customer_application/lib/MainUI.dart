import 'dart:convert';

import 'package:customer_application/BookService.dart';
import 'package:customer_application/CreateDropDown.dart';
import 'package:customer_application/CreateGrievanceUI.dart';
import 'package:customer_application/CreateHorizontalDropDown.dart';
import 'package:customer_application/CustomParamsDialog.dart';
import 'package:customer_application/GlobalVariables.dart';

//import 'package:customer_application/JSONResponseClasses/FirstResponse.dart';
import 'package:customer_application/JSONResponseClasses/ServiceList.dart';
import 'package:customer_application/ManageAddress.dart';
import 'package:customer_application/NewFlowMain.dart';
import 'package:customer_application/bloc.dart';
import 'package:customer_application/main.dart';
import 'package:customer_application/repository.dart';
import 'package:dio/dio.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'CompletedServicesDialog.dart';
import 'JSONResponseClasses/ComplaintList.dart';
import 'JSONResponseClasses/ComplaintType.dart';
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
  static List<Map> myList;
  Map<int, Widget> grievanceTypes1 = new Map();
//  FirstResponse myUserData = FirstResponse().myFirstResponse;
//  FirstResponse fr = new FirstResponse();

  _MyMainPageState();

  final Map<int, Widget> grivence = const <int, Widget>{
    0: Text('Completed'),
    1: Text('On-Going'),
  };

  /*GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
*/
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    intialiseComplaintList();
  }

  intialiseComplaintList() async {
//    GlobalVariables().myComplaintList = await Repository().getComplaintList();
//    CommonMethods().printLog(GlobalVariables().myComplaintList.toString());
//    myList = convertOutputToMap2(GlobalVariables().myComplaintList.oUTPUT);
//  GlobalVariables().complaintTypes = await Repository().getComplaintTypes();

  for(int i = 0; i < GlobalVariables().complaintTypes.oUTPUT.length; i++){
    grievanceTypes1.putIfAbsent(i, () => Text(GlobalVariables().complaintTypes.oUTPUT[i].complaintType));
  }
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
    1: new OnGoingServiceDialog(),
    /*2: Center(
      child: FlutterLogo(
        colors: Colors.cyan,
        size: 200.0,
      ),
    ),*/
  };

  Map<int, Widget> grievanceUI = <int, Widget>{
    0: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 20,
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 300,
              ),
//            CreateDropDown(myJson: convertOutputToMap2(GlobalVariables().myComplaintList.oUTPUT),),
             /* EnhancedFutureBuilder(
                rememberFutureResult: true,
                future: Repository().getComplaintList(),
                whenNotDone: CircularProgressIndicator(),
                whenDone: (dynamic data){
                  return CreateDropDown(myJson: myList);
                },
              ),*/
              /*StreamBuilder(
                stream: Repository().getComplaintList().asStream().asBroadcastStream(),
                builder: (context, complaintListSnapshot){
                  if (!complaintListSnapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }else
                  return CreateDropDown(myJson: myList);
                },
              ),*/
              new TextField(
                expands: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Booking ID',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              new TextField(
                expands: false,
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Remarks',
                )
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: CupertinoButton(
                child: Text(
                  'Lodge Grievance',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: Repository().logout,
                color: Colors.blue,
              )),
            ],
          ),
        )),
    1: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 20,
        margin: EdgeInsets.all(18),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 300,
              ),
//            CreateDropDown(myJson: convertOutputToMap2(GlobalVariables().myComplaintList.oUTPUT),),
              TextField(
                expands: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Booking ID',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              new TextField(
                expands: false,
                maxLines: 5,
                minLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Remarks',
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                  child: CupertinoButton(
                child: Text(
                  'Lodge Grievance',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: Repository().logout,
                color: Colors.blue,
              )),
            ],
          ),
        )),
    2: CreateGrievanceUI(),
  };

  final Map<int, Widget> grievanceTypes = const <int, Widget>{
    0: Text('System'),
    1: Text('Service'),
    2: Text('Others'),
  };

  int currentValue = 0;
  int currentValueGrievance = 0;

  Widget servicesWidget1() {
    ///TODO: Delete This
    var output;
    return FutureBuilder(
      future: Repository().getServices(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.hasError) {
          CommonMethods().printLog('some error occured');
          CommonMethods()
              .printLog('project snapshot data is: ${servicesSnapShot.data}');
          return Center(
            child: Text(
                '/*ERROR OCCURED, Please retry ${servicesSnapShot.data} : ${servicesSnapShot.data}*/'),
            //    child: Text('/*${servicesSnapShot.data.eRRORCODE} : ${servicesSnapShot.data.eRRORMSG}*/'),
          );
        } else if (servicesSnapShot.data == null &&
            servicesSnapShot.connectionState == ConnectionState.waiting) {
          CommonMethods().printLog('The data is in loading state');
          CommonMethods()
              .printLog('project snapshot data is: ${servicesSnapShot.data}');
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
//          CommonMethods().printLog('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.oUTPUT.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data.oUTPUT[index];
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
                      /*CommonMethods().printLog('******************** THE OUTPUT IS ${output.toString()}');
                      GlobalVariables().userSelectedService = output;*/ //unable to instantiate the userSelecteeService
                      GlobalVariables().serviceid = output.serviceid;
                      GlobalVariables().servicename = output.servicename;
                      GlobalVariables().servicetype = output.servicetype;
                      GlobalVariables().servicecategory =
                          output.servicecategory;
                      GlobalVariables().serviceCharge = output.serviceCharge;
                      GlobalVariables().servicecode = output.servicecode;
                      CommonMethods().printLog(
                          '******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
                      String servicename;
                      return showDialog(
                          context: context,
                          builder: (_) {
                            return CustomParamsDialog(
                              selectedService: output,
                            );
                          });
                      /*if (output.servicecode == 'ACCSTMT') {
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
                      }*/
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

  Widget servicesWidget() {
    var output;
    return EnhancedFutureBuilder(
      future: Repository().getServices(),
      rememberFutureResult: true,
      whenNotDone: Center(child: CircularProgressIndicator()),
      whenDone: (dynamic data) {
        if (data == null) {
          return Center(
            child: Text(
                '/*ERROR OCCURED, Please retry the data was null\n This may happen due to error in connecting with server*/'),
            //    child: Text('/*${servicesSnapShot.data.eRRORCODE} : ${servicesSnapShot.data.eRRORMSG}*/'),
          );
        }
        if (data.eRRORCODE == null || data.eRRORCODE != "00") {
          CommonMethods().printLog('some error occured');
          CommonMethods().printLog('project snapshot data is: $data');
          return Center(
            child: Text(
                '/*ERROR OCCURED, Please retry ${data.eRRORCODE} : ${data.eRRORMSG}*/'),
            //    child: Text('/*${servicesSnapShot.data.eRRORCODE} : ${servicesSnapShot.data.eRRORMSG}*/'),
          );
        } else {
          return ListView.builder(
            itemCount: data.oUTPUT.length,
            itemBuilder: (context, index) {
              {
                output = data.oUTPUT[index];
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
                      output = data.oUTPUT[index];
                      /*CommonMethods().printLog('******************** THE OUTPUT IS ${output.toString()}');
                      GlobalVariables().userSelectedService = output;*/ //unable to instantiate the userSelecteeService
                      GlobalVariables().serviceid = output.serviceid;
                      GlobalVariables().servicename = output.servicename;
                      GlobalVariables().servicetype = output.servicetype;
                      GlobalVariables().servicecategory =
                          output.servicecategory;
                      GlobalVariables().serviceCharge = output.serviceCharge;
                      GlobalVariables().servicecode = output.servicecode;
                      CommonMethods().printLog(
                          '******************** THE SERVICE ID IS ${GlobalVariables().serviceid}');
                      String servicename;
                      if (output.customParams.length != 0) {
                        return showDialog(
                            context: context,
                            builder: (_) {
                              return CustomParamsDialog(
                                selectedService: output,
                              );
                            });
                      } else {
                        GlobalVariables().myBookServiceBloc =
                            new BookServiceBloc();
                        return Navigator.push(
                            context,
                            new CupertinoPageRoute(
                                builder: (context) => BookService()));
                      }
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
      whenNone: Center(
        child: Text('/*ERROR OCCURED, Please retry */'),
        //    child: Text('/*${servicesSnapShot.data.eRRORCODE} : ${servicesSnapShot.data.eRRORMSG}*/'),
      ),
    );
  }

  String getIconPath(String serviceCode) {
    if (serviceCode == 'CHQCTL') {
      return 'assets/images/cheque.png';
    }
    if (serviceCode == 'ACCSTMT') {
      return 'assets/images/bank-statement.png';
    } else {
      return 'assets/images/dices.png';
    }
  }

  List<Map> convertOutputToMap(List<OUTPUT1> ml) {
    List<Map> _myJson = [
      {"name": "1", "value": "1"},
      {"name": "2", "value": "2"},
      {"name": "3", "value": "3"},
      {"name": "4", "value": "4"},
      {"name": "5", "value": "Five"}
    ];

    var myMap = new Map();
    List<Map> listOfMap = [];
    for (var listObject in ml) {
      Map myMap1 = new Map();
      myMap1['complaintType'] = listObject.complaintType;
      myMap1['complaintType'] = listObject.complaintType;
      listOfMap.add(myMap1);
//      myMap.clear();
      myMap1 = null;
    }
//    listOfMap.add(myMap);
    return listOfMap;
  }

    List<Map> convertOutputToMap2(List<OUTPUT2> ml) {
    List<Map> _myJson = [
      {"name": "1", "value": "1"},
      {"name": "2", "value": "2"},
      {"name": "3", "value": "3"},
      {"name": "4", "value": "4"},
      {"name": "5", "value": "Five"}
    ];

    var myMap = new Map();
    List<Map> listOfMap = [];
    for (var listObject in ml) {
      Map myMap1 = new Map();
      myMap1['complaintType'] = listObject.complaintList;
      listOfMap.add(myMap1);
//      myMap.clear();
      myMap1 = null;
    }
//    listOfMap.add(myMap);
    return listOfMap;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Welcome ${GlobalVariables().firstResponse.oUTPUT[0].firstname}!',
            style: TextStyle(
            fontWeight: FontWeight.bold
          ),),
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: <Widget>[
              /*Container(
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
              ),*/
              Container(child: Column(
                children: <Widget>[
                  Expanded(child: new NewFlowMain()),
                ],
              ),),
              Container(
                  child: Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                  ),
                  SizedBox(
                    width: 300.0,
                    child: CupertinoSlidingSegmentedControl<int>(
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
                /*child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                    ),
                    SizedBox(
                      width: 300.0,
                      child: CupertinoSlidingSegmentedControl<int>(
                        children: grievanceTypes1,
                        onValueChanged: (int val) {
                          setState(() {
                            currentValueGrievance = val;
                          });
                        },
                        groupValue: currentValueGrievance,
                      ),
                    ),
                    grievanceUI[currentValueGrievance],
                  ],
                ),*/
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
                          /*child: FadeInImage.assetNetwork(
                        placeholder: 'assets/images/1716885.png',
                        image: 'https://i.imgur.com/BoN9kdC.png',
                      ),*/
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
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Name                          '),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                '${GlobalVariables().myPortalLogin.oUTPUT.user.name}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Phone Number             '),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                '${GlobalVariables().myPortalLogin.oUTPUT.user.mobilenumber}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.phone,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Alternate PhoneNumber'),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                '${GlobalVariables().myPortalLogin.oUTPUT.user.alternatenumber}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Icon(
                                Icons.mail,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text('Email                         '),
                              Spacer(
                                flex: 1,
                              ),
                              Text(
                                '${GlobalVariables().myPortalLogin.oUTPUT.user.email}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ),
                        elevation: 1,
                      ),
                      Card(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 5, bottom: 5),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => ManageAddress()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(
                                  Icons.location_on,
                                  color: Colors.blue,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text('Address                  '),
                                Spacer(
                                  flex: 1,
                                ),
                                Text(
                                  'Manage Address',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Spacer(
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 1,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: CupertinoButton(
                        child: Text(
                          'LOGOUT',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: Repository().logout,
                        color: Colors.red,
                      )),
                      SizedBox(
                        height: 10,
                      ),
                      /*Center(
                          child: CupertinoButton(
                            child: Text(
                              'LOGOUT',style: TextStyle(color: Colors.red),
                            ),
                            onPressed: logout,

                          )),*/
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
                title: Text('    Home'),
                activeColor: Colors.blue,
                inactiveColor: Colors.blueGrey,
                icon: Icon(Icons.home)),
            BottomNavyBarItem(
                title: Text('My Services'),
                activeColor: Colors.blue,
                inactiveColor: Colors.blueGrey,
                icon: Icon(Icons.apps)),
            /*BottomNavyBarItem(
                title: Text('OnGoing Services'),
                activeColor: Colors.green,
                inactiveColor: Colors.blue,
                icon: Icon(Icons.chat_bubble)),*/
            BottomNavyBarItem(
                title: Text('  Support'),
                activeColor: Colors.blue,
                inactiveColor: Colors.blueGrey,
                icon: Icon(Icons.help)),
            BottomNavyBarItem(
                title: Text('   Profile'),
                activeColor: Colors.blue,
                inactiveColor: Colors.blueGrey,
                icon: Icon(Icons.person)),
          ],
        ),
      ),
    );
  }
}
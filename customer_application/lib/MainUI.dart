import 'dart:convert';

import 'package:customer_application/JSONResponseClasses/ServiceList.dart';
import 'package:customer_application/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'SizeConfig.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:customer_application/CommonMethods.dart';
import 'networkConfig.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  MyMainPage({Key key, this.title, this.phoneNumber, this.accessToken})
      : super(key: key);

  final String title;

  final String phoneNumber;
  final String accessToken;

  @override
  _MyMainPageState createState() =>
      _MyMainPageState(title, phoneNumber, accessToken);
}

class _MyMainPageState extends State<MyMainPage> {
  int _currentIndex = 0;
  PageController _pageController;
  String title;
  String phoneNumber;
  String accessToken;

  _MyMainPageState(this.title, this.phoneNumber, this.accessToken);

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
                  if (logoutResponse.toString().contains('"ERRORCODE":"00')) {
                    print('logout success');
                    Navigator.of(context).pop();
                  }
                  Navigator.of(context).pop();
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
      future: getServices(),
      builder: (context, servicesSnapShot) {
        if (servicesSnapShot.data == null) {
          print('The data is in loading state');
          return Center(
            child: CupertinoActivityIndicator(),
          );
        } else {
          print('The data is loaded!!!!');
          return ListView.builder(
            itemCount: servicesSnapShot.data.length,
            itemBuilder: (context, index) {
              {
                output = servicesSnapShot.data[index];
                print('project snapshot data is: ${servicesSnapShot.data}');
                return ListTile(
                  title: Text(output.servicename),
                  subtitle: Text('Service Charge : ${output.serviceCharge}'),
                  onTap: () {},
                );
              }
            },
          );
        }
      },
    );
  }

  Future<void> getServices() async {
    String getServicesString = """{
          "additionalData":
    {
    "client_app_ver":"1.0.0",
    "client_apptype":"DSB",
    "platform":"ANDROID",
    "vendorid":"17"
    },
    "mobilenumber":"$phoneNumber",
    "ts": "Mon Dec 16 2019 13:19:41 GMT + 0530(India Standard Time)",
    "authorization":"$accessToken",
    "username":"$phoneNumber"

    }""";
    Response getServicesResponse = await NetworkCommon()
        .myDio
        .post("/getServiceList", data: getServicesString);
    var getServicesResponseString = jsonDecode(getServicesResponse.toString());
    var getServicesResponseObject =
        ServiceList.fromJson(getServicesResponseString);
    //print("THE SERVICE RESPONSE IS $getServicesResponseObject");
    // print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT[0].serviceCharge}");

    print("THE SERVICE RESPONSE IS ${getServicesResponseObject.oUTPUT.length}");

    var output = getServicesResponseObject.oUTPUT;

    List services = [];

    for (int i = 0; i < output.length; i++) {
      print('                SERVICE NAME IS $i : ${output[i].servicename}             ');
      services.add(output[i].servicename);
    }

    print('             THE SERVICES OFFERED ARE $services                 ');

    return output;
    print(accessToken);
    print(getServicesResponse);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
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
                child: servicesWidget(),
              ),
              Container(
//                color: Colors.red,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 11.0,
                  ),
                ),
              ),
              Container(
                color: Colors.green,
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
                color: Colors.purple,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    new Container(
                        width: 190.0,
                        height: 190.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: new NetworkImage(
                                    "https://i.imgur.com/BoN9kdC.png")))),
                    Container(
                      margin: const EdgeInsets.all(30.0),
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                      ),
                      child: Text(
                        "Name",
                        style: TextStyle(fontSize: 30.0),
                      ),
                    ),
                    Center(
                        child: RaisedButton(
                      child: Text(
                        'LOGOUT',
                      ),
                      textColor: Colors.white,
                      onPressed: logout,
                      color: Colors.blue,
                    )),
                  ],
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
            BottomNavyBarItem(
                title: Text('OnGoing Services'),
                activeColor: Colors.green,
                inactiveColor: Colors.blue,
                icon: Icon(Icons.chat_bubble)),
            BottomNavyBarItem(
                title: Text('Help & Support'),
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

import 'dart:async';

import 'package:customer_application/CommonMethods.dart';
import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/SignUpUI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'main.dart';

class MyMapsApp extends StatefulWidget {
  @override
  _MyMapsAppState createState() => _MyMapsAppState();
}

class _MyMapsAppState extends State<MyMapsApp> {
  Completer<GoogleMapController> _controller = Completer();

  Position _currentPosition;
  String _currentAddress;
  String rLatitude;
  String rLongitude;


  static const LatLng _center = const LatLng(20.5937, 78.9629);

  final Map<String, Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);

    List<Placemark> placemark = await Geolocator().placemarkFromPosition(currentLocation);
    print('Latitude is ${currentLocation.latitude}');

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'Your Location'),
        draggable: true,
      );
      _markers["Current Location"] = marker;

    });
      print('The current location is ${_markers["Current Location"]}');
    _currentPosition = Position.fromMap(_markers[0]);
//    _getAddressFromLatLng();

  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await Geolocator().placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _getLocation,
          tooltip: 'Get Current Location',
          child: Icon(Icons.location_on),
        ),
        appBar: AppBar(
          title: Text('Choose an Address'),
          backgroundColor: Colors.green[700],
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              flex: 80,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 5.0,
                ),
                markers: _markers.values.toSet(),
              ),
            ),
            Expanded(
              flex: 14,
//              child: MaterialButton(child: Text('Choose', style: TextStyle(color: Colors.white),),color: Colors.blue,),
              child: Center(
                child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.blue,
                    child: Row(
                      children: <Widget>[
                        SizedBox(width: 30,),
                        MaterialButton(
                          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                          onPressed: () {
                            GlobalVariables().registrationLatitude = rLatitude;
                            GlobalVariables().registrationLongitude = rLongitude;
                            if(GlobalVariables().registrationLatitude == null && GlobalVariables().registrationLongitude == null){
                          Navigator.pop(context);
                            }
                            else{
                              CommonMethods().toast(context, "Please Select an Address");
                            }
                            },
                          child: Text(
                            "Select this Address",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
              )
            )
          ],
        ),
      ),
    );
  }
}
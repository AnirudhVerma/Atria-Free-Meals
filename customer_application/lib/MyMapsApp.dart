import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMapsApp extends StatefulWidget {
  @override
  _MyMapsAppState createState() => _MyMapsAppState();
}

class _MyMapsAppState extends State<MyMapsApp> {
  Completer<GoogleMapController> _controller = Completer();

  Position _currentPosition;
  String _currentAddress;

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
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 5.0,
          ),
          markers: _markers.values.toSet(),
        ),
      ),
    );
  }
}
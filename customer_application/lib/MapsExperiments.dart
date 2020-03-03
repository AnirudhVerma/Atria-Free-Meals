import 'package:customer_application/GlobalVariables.dart';
import 'package:customer_application/repository.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io' show Platform;
import 'CommonMethods.dart';

/*void main() => runApp(MyMapsExperimentsApp());

class MyMapsExperimentsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation Google Maps Demo',
      home: MyMapsExperimentsMap(),
    );
  }
}*/

class MyMapsExperimentsMap extends StatefulWidget {

  final int fromPage;

  MyMapsExperimentsMap(this.fromPage);

  @override
  State<MyMapsExperimentsMap> createState() => MyMapsExperimentsMapSampleState();
}

class MyMapsExperimentsMapSampleState extends State<MyMapsExperimentsMap> {

  String rLatitude;
  String rLongitude;

  final addressController = TextEditingController(text: '  Loading...');

  @override
  void initState(){
    super.initState();
    _getLocation();
  }

  final Map<String, Marker> _markers = {};

  void _getLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    CommonMethods().printLog('Latitude is ${currentLocation.latitude}');

    rLatitude = currentLocation.latitude.toString();
    rLongitude = currentLocation.longitude.toString();
    GlobalVariables().registrationLatitude = rLatitude;
    GlobalVariables().registrationLongitude = rLongitude;

    final coordinates = new Coordinates(currentLocation.latitude,currentLocation.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    GlobalVariables().addressFromLocation = first.addressLine;
    GlobalVariables().pinCodeFromLocation = first.postalCode;

    CommonMethods().printLog('Postal Code is ${first.postalCode}');
    CommonMethods().printLog(('Address Line is ${first.addressLine}'));

    CommonMethods().printLog('Global Address is ${GlobalVariables().addressFromLocation}');
    CommonMethods().printLog('Global pincode is ${GlobalVariables().pinCodeFromLocation}');
    CommonMethods().printLog('Global latitude is ${GlobalVariables().registrationLatitude}');
    CommonMethods().printLog('Global longitude is ${GlobalVariables().addressFromLocation}');

    setState(() {
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
//        infoWindow: InfoWindow(title: 'Your Location',snippet: 'This is your location'),
      );
      _markers["Current Location"] = marker;
      addressController.text = first.addressLine;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      /*floatingActionButton: FloatingActionButton(
        onPressed: _getLocation,
        tooltip: 'Get Location',
        child: Icon(Icons.flag),
      ),*/
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 77,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(20.5937, 78.9629),
                zoom: 5,
              ),
              myLocationButtonEnabled: false,
              markers: _markers.values.toSet(),
            ),
          ),
          Expanded(
              flex: 20,
//              child: MaterialButton(child: Text('Choose', style: TextStyle(color: Colors.white),),color: Colors.blue,),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        obscureText: false,
                        controller: addressController,
                      ),
                    ),
                    Center(
                      child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          color: Colors.blue,
                          child: MaterialButton(
                            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            onPressed: () {
                              if(widget.fromPage == 0){
                                GlobalVariables().registrationLatitude = rLatitude;     //DELETE
                                GlobalVariables().registrationLongitude = rLongitude;   //DELETE
                                if (GlobalVariables().registrationLatitude == null ||
                                    GlobalVariables().registrationLongitude == null ||
                                    GlobalVariables().addressFromLocation == null ||
                                    GlobalVariables().pinCodeFromLocation == null
                                ) {
                                  CommonMethods()
                                      .toast(context, "Please Select an Address");
                                }
                                else{
                                  CommonMethods().toast(context, 'Address Addes Successfully');
                                  Navigator.pop(context);
                                }

                              }
                              else if(widget.fromPage == 1){

                                if (GlobalVariables().registrationLatitude == null ||
                                    GlobalVariables().registrationLongitude == null ||
                                    GlobalVariables().addressFromLocation == null ||
                                    GlobalVariables().pinCodeFromLocation == null
                                ) {
                                  CommonMethods()
                                      .toast(context, "Address not Selected");
                                }
                                else{
                                  Future<dynamic> addAddressResponse = Repository().addAddress(GlobalVariables().addressFromLocation, GlobalVariables().registrationLatitude, GlobalVariables().registrationLongitude, GlobalVariables().pinCodeFromLocation);
                                  GlobalVariables().registrationLatitude = null;
                                  GlobalVariables().registrationLongitude = null;
                                  GlobalVariables().addressFromLocation = null ;
                                  GlobalVariables().pinCodeFromLocation = null;
                                  CommonMethods().printLog('*******************The address response is $addAddressResponse');
                                  CommonMethods().toast(context, addAddressResponse.toString());
                                  Navigator.pop(context, () {
                                    setState(() {});
                                  });
                                }

                              }
                            },
                            child: Text(
                              "Add this Address",
                              style: TextStyle(color: Colors.white, fontSize: 18),
                              textAlign: TextAlign.center,
                            ),
                          )),
                    ),
                  ],
                ),
              ))
        ],
      )
    );
  }
}
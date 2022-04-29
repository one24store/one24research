import 'dart:async';

import 'package:flutter/material.dart';

import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var Latitude;
  var Longitude;
  Location location = Location();
  LocationData? currentposition;

  //var counter = 1;
  late GoogleMapController _controller;
  var count = 0;

  late LatLng _initialcameraposition;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Column(
          children: [
            (currentposition == null)
                ? Container(
                    color: Colors.blue,
                    height: 100,
                  )
                : SafeArea(
                    child: Text('lat is ${Latitude} ' +
                        '\n' +
                        'long is ${Longitude}' +
                        '\n' +
                        'Count is $count'),
                  ),
            ElevatedButton(
                onPressed: () {
                  move_camera();
                },
                child: Text('press')),
            (currentposition == null)
                ? Container(
                    color: Colors.green,
                    height: 100,
                  )
                : Expanded(
                    child: Container(
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                            target: _initialcameraposition, zoom: -15),
                        onMapCreated: _onMapCreated,
                        mapType: MapType.satellite,
                        myLocationEnabled: true,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    currentposition = await location.getLocation();
    Latitude = currentposition?.latitude;
    Longitude = currentposition?.longitude;
    location.enableBackgroundMode(enable: true);

    setState(() {
      _initialcameraposition = LatLng(Latitude, Longitude);
      count += 1;
    });

    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.latitude}");
      setState(() {
        count += 1;
        Latitude = currentLocation.latitude;
        Longitude = currentLocation.longitude;
        _initialcameraposition = LatLng(Latitude, Longitude);
      });
    });
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void move_camera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(51.509865, -0.118092), zoom: 20),
    ));
  }
}

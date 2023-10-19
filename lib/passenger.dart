import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'driver.dart';

class passenger extends StatefulWidget {
  const passenger({super.key});

  @override
  State<passenger> createState() => _passengerState();
}

class _passengerState extends State<passenger> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Position ?_currentPosition;
  late StreamSubscription<Position> _positionStreamSubscription;
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      await Permission.location.request();
      getCurrentLocation();
    }else{
      openAppSettings();
      print("Please gurant permissioj");
    }
  }
  Future<Position?> getCurrentLocation() async {
    Position position;
    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(position);
      _currentPosition = Position(latitude:position.latitude, longitude: position.longitude, timestamp: DateTime.now(), accuracy: position.accuracy,
          altitude: position.altitude, altitudeAccuracy: position.altitudeAccuracy, heading: position.heading, headingAccuracy: position.headingAccuracy, speed: position.speed, speedAccuracy: position.speedAccuracy); // Initial position
      _initLocationTracking();
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    getloaction ();
  }

  void _initLocationTracking() {
    _positionStreamSubscription = Geolocator.getPositionStream().listen((position) {
      setState(() {
        _currentPosition = position;
        // Upload the user's location to Firebase Realtime Database
        uploadLocationToFirebase(position.latitude, position.longitude);
      });
    });
  }

  void uploadLocationToFirebase(double latitude, double longitude) {
    // Replace 'users' with the appropriate Firebase Realtime Database path
    databaseReference.child('users').update({
      'user2': {
        'latitude': latitude,
        'longitude': longitude,
      },
    });
  }
  var data;
  getloaction (){
    databaseReference.child('users/user1').onValue.listen(( event) {
      if (event.snapshot.value != null) {
        print(data);
        setState(() {
          data = event.snapshot.value;
        });
      }
    });
  }
  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Latitude: ${data!=null?data["latitude"]:""}'),
            Text('Longitude: ${data!=null? data["longitude"]:""}'),
          ],
        ),
      ),
    );
  }
}
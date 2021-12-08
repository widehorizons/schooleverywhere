import 'dart:async';
import '../config/flavor_config.dart';

import '../Constants/StringConstants.dart';
import '../SharedPreferences/Prefs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../Style/theme.dart';
import 'package:location/location.dart' as prefix;
import 'package:flutter/services.dart';

import '../Modules/Bus.dart';
import '../Modules/User.dart';
import 'LoginPage.dart';

class BusPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BusPageState();
  }
}

class _BusPageState extends State<BusPage> {
  final DBRef = FirebaseDatabase.instance.reference();
  User? loggedBus;
  late Timer timer;

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  late prefix.LocationData currentLocation;
  prefix.Location _locationService = new prefix.Location();
  late GoogleMapController _mapController;
  int _markerIdCounter = 0;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation2("Yes");

    getLoggedBus();
    timer = Timer.periodic(
        Duration(seconds: 20), (Timer t) => _getCurrentLocation2("Yes"));
  }

  Future<void> getLoggedBus() async {
    loggedBus = await getUserData() as User;
    // setState(() {});
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _onMapCreated(GoogleMapController controller) async {
    this._mapController = controller;
    MarkerId markerId = MarkerId(_markerIdVal());
    LatLng position = LatLng(
        currentLocation != null ? currentLocation.latitude! : 0.0,
        currentLocation != null ? currentLocation.longitude! : 0.0);
    Marker marker = Marker(
      markerId: markerId,
      position: position,
      draggable: true,
    );
    if (this.mounted) {
      setState(() {
        _markers[markerId] = marker;
      });
    }
    Future.delayed(Duration(milliseconds: 200), () async {
      //SendToFirebaseDatabase(position.latitude,position.longitude);
      this._mapController = controller;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(FlavorConfig.instance.values.schoolName!),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              backgroundImage:
                  AssetImage('FlavorConfig.instance.values.imagePath!'),
            )
          ],
        ),
        actions: <Widget>[
          new IconButton(
            icon: Icon(FontAwesomeIcons.doorOpen),
            onPressed: () {
              removeUserData();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
        backgroundColor: AppTheme.appColor,
      ),
      body: GoogleMap(
        markers: Set<Marker>.of(_markers.values),
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onCameraMove: (CameraPosition position) {
          if (_markers.length > 0) {
            MarkerId markerId = MarkerId(_markerIdVal());
            Marker? marker = _markers[markerId];
            Marker updatedMarker = marker!.copyWith(
              positionParam: position.target,
            );
            if (this.mounted) {
              setState(() {
                _markers[markerId] = updatedMarker;
              });
            }
          }
        },
        compassEnabled: true,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  void _getCurrentLocation2(String strSendToFirebaseDatabase) async {
    var location = new Location();
    try {
      currentLocation = await location.getLocation();

      setState(() {
        moveCameraToMyLocation(
            currentLocation.latitude!, currentLocation.longitude!);
      });
      if (strSendToFirebaseDatabase == "Yes") {
        SendToFirebaseDatabase(
            currentLocation.latitude!, currentLocation.longitude!);
      }
      //rebuild the widget after getting the current location of the user
    } on Exception {
      currentLocation = "" as LocationData;
    }

    prefix.LocationData myLocation;
    try {
      myLocation = await _locationService.getLocation();
      print('myLocation $myLocation');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void moveCameraToMyLocation(double lat, double lon) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(lat, lon),
          zoom: 17.0,
        ),
      ),
    );
  }

  void SendToFirebaseDatabase(double latitude, double longitude) {
    DBRef.child(loggedBus!.id!)
        .set({'latitude': latitude, 'longitude': longitude});
  }
/*  void UpdateFirebaseDatabase()
  {
    DBRef.child("1").update({
      'id':'ID2',
      'Data':'Samaple data2'
    });

  }*/
}

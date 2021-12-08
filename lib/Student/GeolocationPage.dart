import 'dart:async';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class GeolocationPage extends StatefulWidget {
  final String routeid;
  final String periodid;
  final String parentSection;
  final String parentAcademicYear;

  const GeolocationPage(
      {required this.routeid,
      required this.periodid,
      required this.parentSection,
      required this.parentAcademicYear});

  @override
  State<StatefulWidget> createState() {
    return new _GeolocationPageState();
  }
}

class _GeolocationPageState extends State<GeolocationPage> {
  final db = FirebaseDatabase.instance.reference();
  late String driverId;
  late LatLng position;
  late double axisone;
  late double axistwo;
  late double x;
  late double y;

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(45.521563, -122.677433);

//  prefix.LocationData currentLocation;
//  prefix.Location _locationService = new prefix.Location();
  late GoogleMapController _mapController;
  int _markerIdCounter = 0;

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  @override
  void initState() {
    super.initState();
    syncGetDriver();
    _getCurrentLocation2();
  }

  Future<void> syncGetDriver() async {
    EventObject eventObject = await GetDriver(
        widget.routeid.toString(),
        widget.periodid.toString(),
        widget.parentAcademicYear.toString(),
        widget.parentSection.toString());
    if (eventObject.success!) {
      Map? data = eventObject.object as Map?;
      String toto = data!['driver'];
      setState(() {
        driverId = toto;
        print("id driver:" + driverId.toString());
        db.child(driverId).once().then((DataSnapshot snapshot) {
          print("tetete  : ${snapshot.value}");
          Map<dynamic, dynamic> values = {"data": snapshot.value};
          values.forEach((key, values) {
            axisone = values["latitude"];
            axistwo = values["longitude"];
            setState(() {
              x = axisone;
              y = axistwo;
              _getCurrentLocation2();
            });
          });
        });
      });
    } else {
      String? msg = eventObject.object as String?;
      /*  Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  void _onMapCreated(GoogleMapController controller) async {
    this._mapController = controller;
    MarkerId markerId = MarkerId(_markerIdVal());
    print("x:" + x.toString() + " " + "y:" + y.toString());
    position = LatLng(x != null ? x : 0.0, y != null ? y : 0.0);
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

  @override
  Widget build(BuildContext context) {
    if (driverId != null) {
      db.child(driverId).onChildChanged.listen((Event event) {
        // print("EVENT: : ${event.snapshot.value}");
//        Map<dynamic, dynamic> values = event.snapshot.value;
//        values.forEach((key, values) {
//        axisone = values["latitude"];
//        axistwo = values["longitude"];
//        print(axisone.toString() + "   " + axistwo.toString());
//        setState(() {
//          x = axisone;
//          y = axistwo;
//          _getCurrentLocation2();
//        });
//        });
        if (event.snapshot.key == "latitude") {
          axisone = event.snapshot.value;
          if (this.mounted) {
            setState(() {
              //print("x new value:" + axisone.toString() + "y new value:" + axistwo.toString());
              x = axisone;
              y = axistwo;
              _getCurrentLocation2();
            });
          }
        } else if (event.snapshot.key == "longitude") {
          axistwo = event.snapshot.value;
          if (this.mounted) {
            setState(() {
              // print("y new value:" + axistwo.toString() + "x new value:" + axisone.toString());
              x = axisone;
              y = axistwo;
              _getCurrentLocation2();
            });
          }
        }
      });
    }
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

  void _getCurrentLocation2() async {
    setState(() {
      moveCameraToMyLocation(x != null ? x : 0.0, y != null ? y : 0.0);
    }); //rebuild the widget after getting the current location of the user
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
}

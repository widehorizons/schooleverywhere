import 'package:expandable/expandable.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';

import '../Pages/LoginPage.dart';
import 'PreviousMaintenanceLocation.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class MaintenanceLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MaintenanceLocationState();
  }
}

class _MaintenanceLocationState extends State<MaintenanceLocation> {
  Staff? loggedStaff;
  String? placeValue, problemValue, buildingValue, subPlaceValue, deviceValue;

  bool placeSelected = false,
      buildingSelected = false,
      subPlaceSelected = false,
      deviceSelected = false,
      problemSelected = false,
      isLoading = false;

  TextEditingController descriptionController = new TextEditingController();

  Map buildingOptions = new Map();
  Map placeOptions = new Map();
  Map subPlaceOptions = new Map();
  Map deviceOptions = new Map();
  Map problemOptions = new Map();
  initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    syncBuildingAndProblemOptions();
  }

  Future<void> syncBuildingAndProblemOptions() async {
    EventObject objectEventBuildingAndProblem =
        await getBuildingAndProblemOptions();
    if (objectEventBuildingAndProblem.success!) {
      Map? data = objectEventBuildingAndProblem.object as Map?;
      List<dynamic> buildingList = data!['buildingId'];
      Map buildingMap = new Map();
      for (int i = 0; i < buildingList.length; i++) {
        buildingMap[data['buildingId'][i]] = data['buildingName'][i];
      }
      List<dynamic> problemList = data['problemId'];
      Map problemMap = new Map();
      for (int i = 0; i < problemList.length; i++) {
        problemMap[data['problemId'][i]] = data['problemName'][i];
      }
      setState(() {
        buildingOptions = buildingMap;
        problemOptions = problemMap;
      });
    } else {
      String? msg = objectEventBuildingAndProblem.object as String?;
      /*   Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncPlaceOptions() async {
    EventObject objectEventPlace =
        await getMaintenancePlaceOptions(buildingValue!);
    if (objectEventPlace.success!) {
      Map? toto = objectEventPlace.object as Map?;
      List<dynamic> x = toto!['placeId'];
      Map placeMap = new Map();
      for (int i = 0; i < x.length; i++) {
        placeMap[toto['placeId'][i]] = toto['placeName'][i];
      }
      setState(() {
        placeOptions = placeMap;
      });
    } else {
      String? msg = objectEventPlace.object as String?;
      /* Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncSubPlaceOptions() async {
    EventObject objectEventSubPlace =
        await getMaintenanceSubPlaceOptions(buildingValue!, placeValue!);
    if (objectEventSubPlace.success!) {
      Map? toto = objectEventSubPlace.object as Map?;
      List<dynamic> x = toto!['subPlaceId'];
      Map subPlaceMap = new Map();
      for (int i = 0; i < x.length; i++) {
        subPlaceMap[toto['subPlaceId'][i]] = toto['subPlaceName'][i];
      }
      setState(() {
        subPlaceOptions = subPlaceMap;
      });
    } else {
      String? msg = objectEventSubPlace.object as String?;
      /* Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncDeviceNameOptions() async {
    EventObject objectEventDevice = await getMaintenanceDeviceOptions(
        buildingValue!, placeValue!, subPlaceValue!);
    if (objectEventDevice.success!) {
      Map? toto = objectEventDevice.object as Map?;
      List<dynamic> x = toto!['deviceId'];
      Map deviceMap = new Map();
      for (int i = 0; i < x.length; i++) {
        deviceMap[toto['deviceId'][i]] = toto['deviceName'][i];
      }
      setState(() {
        deviceOptions = deviceMap;
      });
    } else {
      String? msg = objectEventDevice.object as String?;
      /*  Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncAddMaintenanceProblem() async {
    isLoading = true;
    if (buildingValue != null &&
        placeValue != null &&
        subPlaceValue != null &&
        deviceValue != null &&
        problemValue != null) {
      EventObject objectEventAdd = await addMaintenanceProblem(
          buildingValue!,
          placeValue!,
          subPlaceValue!,
          deviceValue!,
          descriptionController.text,
          problemValue!,
          loggedStaff!.academicYear!,
          loggedStaff!.id!,
          loggedStaff!.section!);
      setState(() {
        Navigator.of(context).pop();
        if (objectEventAdd.success!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MaintenanceLocation()),
          );
          /*    Flushbar(
            title: "Success",
            message: "Added",
            icon: Icon(Icons.done_outline),
            backgroundColor: AppTheme.appColor,
            duration: Duration(seconds: 2),
          )
            ..show(context);*/
          Fluttertoast.showToast(
              msg: "Added",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          String? msg = objectEventAdd.object as String?;
          /*   Flushbar(
            title: "Failed",
            message: msg.toString(),
            icon: Icon(Icons.close),
            backgroundColor: AppTheme.appColor,
            duration: Duration(seconds: 3),
          )
            ..show(context);*/
          Fluttertoast.showToast(
              msg: msg.toString(),
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } else {
      /*     Flushbar(
        title: "Failed",
        message: 'Please Fill All Required Data',
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: "Please Fill All Required Data",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => MaintenanceLocation()));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => PreviousMaintenanceLocation(
                      loggedStaff!.id!,
                      loggedStaff!.academicYear!,
                      loggedStaff!.section!)));
          break;
      }
    });
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final building = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: buildingValue,
          hint: Text("Select Building"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              buildingSelected = true;
              buildingValue = newValue!;
              placeOptions.clear();
              placeValue = '';
              placeSelected = false;
              subPlaceOptions.clear();
              subPlaceValue = '';
              subPlaceSelected = false;
              deviceOptions.clear();
              deviceValue = '';
              deviceSelected = false;
              syncPlaceOptions();
            });
          },
          items: buildingOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );

    final place = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: placeValue,
          hint: Text("Select Place"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              placeSelected = true;
              placeValue = newValue!;
              subPlaceOptions.clear();
              subPlaceValue = '';
              subPlaceSelected = false;
              deviceOptions.clear();
              deviceValue = '';
              deviceSelected = false;
              syncSubPlaceOptions();
            });
          },
          items: placeOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );

    final subPlace = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: subPlaceValue,
          hint: Text("Select Sub Place"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              subPlaceSelected = true;
              subPlaceValue = newValue!;
              deviceOptions.clear();
              deviceValue = '';
              deviceSelected = false;
              syncDeviceNameOptions();
            });
          },
          items: subPlaceOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );

    final deviceName = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: deviceValue,
          hint: Text("Select Device"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              deviceSelected = true;
              deviceValue = newValue!;
            });
          },
          items: deviceOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );

    final problem = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: problemValue,
          hint: Text("Select Problem"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              problemSelected = true;
              problemValue = newValue!;
            });
          },
          items: problemOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );

    final description = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        maxLines: null,
        keyboardType: TextInputType.text,
        controller: descriptionController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Your Description',
          border: OutlineInputBorder(),
        ),
      ),
    );

    final addButton = !isLoading
        ? Padding(
            padding: EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: MediaQuery.of(context).size.width * .25),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () {
                syncAddMaintenanceProblem();
              },
              padding: EdgeInsets.all(12),
              color: AppTheme.appColor,
              child: Text('ADD', style: TextStyle(color: Colors.white)),
            ),
          )
        : loadingSign;

    final body = Center(
      widthFactor: 2,
      child: Container(
        width: MediaQuery.of(context).size.width * .75,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: building,
            ),
            buildingSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: place,
                  )
                : Container(),
            placeSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: subPlace,
                  )
                : Container(),
            subPlaceSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: deviceName,
                  )
                : Container(),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: problem,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: description,
            ),
            problemSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: addButton,
                  )
                : Container(),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(FlavorConfig.instance.values.schoolName!),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: loggedStaff!.type!,
                        sectionid: loggedStaff!.section!,
                        Id: "",
                        Academicyear: "")));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    AssetImage('${FlavorConfig.instance.values.imagePath!}'),
              ),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: body,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            label: 'New Problem',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.low_priority),
            label: 'Previous',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.appColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(loggedStaff!.type!, loggedStaff!.id!);
            removeUserData();
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
//          Navigator.pop(context);
            Navigator.of(context).pushReplacement(
                new MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child: Icon(
            FontAwesomeIcons.doorOpen,
            color: AppTheme.floatingButtonColor,
            size: 30,
          ),
          backgroundColor: Colors.transparent,
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0),
          )),
    );
  }
}

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../config/flavor_config.dart';
import '../Modules/Staff.dart';
import '../Pages/StaffPage.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../Style/theme.dart';

import '../SharedPreferences/Prefs.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class SupervisorStaffPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SupervisorStaffPageState();
  }
}

class _SupervisorStaffPageState extends State<SupervisorStaffPage> {
  String? staffSupervisorValue;
  Map staffSupervisorOption = new Map();
  bool staffSupervisorSelected = false;
  Staff? loggedStaff;
  bool isGoing = false;

  @override
  void initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    syncStaffSupervisorOptions();
  }

  Future<void> syncStaffSupervisorOptions() async {
    EventObject objectEventStaffSupervisor =
        await staffSupervisorOptions(loggedStaff!.supervisorId!);
    if (objectEventStaffSupervisor.success!) {
      Map? data = objectEventStaffSupervisor.object as Map?;
      List<dynamic> toto = data!['supervisorId'];
      Map staffSupervisorArr = new Map();
      staffSupervisorArr[loggedStaff!.id] = "Default";
      for (int i = 0; i < toto.length; i++) {
        staffSupervisorArr[data['supervisorId'][i]] = data['supervisorName'][i];
      }
      setState(() {
        staffSupervisorOption = staffSupervisorArr;
      });
    } else {
      String? msg = objectEventStaffSupervisor.object as String?;
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffSupervisor = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: staffSupervisorValue,
            hint: Text("Select Staff"),
            style: TextStyle(color: AppTheme.appColor),
            underline: Container(
              height: 2,
              color: AppTheme.appColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                staffSupervisorSelected = true;
                staffSupervisorValue = newValue!;
              });
            },
            items: staffSupervisorOption
                .map((key, value) {
                  return MapEntry(
                      value,
                      DropdownMenuItem<String>(
                        value: key,
                        child: Text(value),
                      ));
                })
                .values
                .toList()));

    final goButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          goStaffFiltration(staffSupervisorValue!);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('GO', style: TextStyle(color: Colors.white)),
      ),
    );
    final body = Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .15),
            child: new Icon(
              Icons.person,
              color: AppTheme.appColor,
              size: MediaQuery.of(context).size.height * .15,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: staffSupervisor,
          ),
          staffSupervisorSelected
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: isGoing
                      ? SpinKitPouringHourGlass(
                          color: AppTheme.appColor,
                        )
                      : goButton,
                )
              : Container(),
        ],
      ),
    );
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: body,
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

  Future<void> goStaffFiltration(String staffSupervisor) async {
    loggedStaff!.supervisorStaff = true;
    loggedStaff!.supervisorId = loggedStaff!.id!;
    loggedStaff!.id = staffSupervisor;
    await setUserData(loggedStaff!);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => StaffPage(),
        ));
    // }
  }
}

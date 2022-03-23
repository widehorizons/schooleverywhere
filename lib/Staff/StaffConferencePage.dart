// import 'package:get_version/get_version.dart';
import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'ConferenceStaffJoinStaff.dart';
import 'ConferenceStaffstaff.dart';
import '../Modules/Management.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';

import '../Networking/Futures.dart';
import '../SharedPreferences/Prefs.dart';

import '../Style/theme.dart';

import '../Pages/LoginPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class StaffConferencePage extends StatefulWidget {
  final String type;
  final String sectionid;
  final String Id;
  final String Academicyear;

  const StaffConferencePage(
      this.type, this.sectionid, this.Id, this.Academicyear);

  @override
  State<StatefulWidget> createState() {
    return new _StaffConferencePageState();
  }
}

class _StaffConferencePageState extends State<StaffConferencePage> {
  String? typeOptions;
  String? typename;
  String? checkVersionCode, _projectCode;

  Future<dynamic> homePageAllPages(String linkName, String type) async {
    if (linkName == "Staff Conference") {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConferenceStaffstaff()),
      );
    } else if (linkName == "Join Conference") {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConferenceStaffJoinStaff()),
      );
    }
  }

  late Staff loggedStaff;
  late Parent loggedParent;
  late Student loggedStudent;
  late Management loggedManagement;
  bool isLoading = false;
  late String userAcademicYear,
      userId,
      userType,
      userSection,
      userStage,
      userGrade,
      userSemester,
      userClass,
      userRegno,
      userSupervisor;
  bool checkSupervisor = false;

  @override
  initState() {
    super.initState();
    initPlatformState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    loggedStaff = await getUserData() as Staff;
    userAcademicYear = loggedStaff.academicYear!;
    userSection = loggedStaff.section!;
    userId = loggedStaff.id!;
    userType = loggedStaff.type!;
    userSupervisor = loggedStaff.supervisorId!;
    checkSupervisor = loggedStaff.supervisorStaff!;
  }

  initPlatformState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await packageInfo.buildNumber;
    } catch (e) {
      projectCode = '';
    }
    if (!mounted) return;

    setState(() {
      _projectCode = projectCode;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(FlavorConfig.instance.values.schoolName!),
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  AssetImage('${FlavorConfig.instance.values.imagePath!}'),
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
          child: ((widget.type != STAFF_TYPE) ||
                  ((widget.type == STAFF_TYPE) && (userSupervisor != null)))
              ? FutureBuilder(
                  future: homePageOptions(
                      widget.type,
                      widget.sectionid,
                      widget.Id,
                      widget.Academicyear,
                      checkSupervisor,
                      userSupervisor),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    EventObject objectEvent = snapshot.data;
                    if (!snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: SpinKitPouringHourGlass(
                            color: AppTheme.appColor,
                          ),
                        ),
                      );
                    } else if (objectEvent.success == false) {
                      String? msg = objectEvent.object as String?;
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(msg.toString()),
                        ),
                      );
                    } else {
                      print("SNAP_SHOT_DATA: " + objectEvent.toString());
                      print("DATA_SENT: " +
                          widget.type +
                          " " +
                          widget.sectionid +
                          " " +
                          widget.Id +
                          " " +
                          widget.Academicyear);
                      Map? data = objectEvent.object as Map?;
                      print(
                          "Data Retrived here is ===> ${data!['versionCode']}");

                      if (FlavorConfig.instance.flavor == Flavor.TANTAROYAL &&
                          Platform.isAndroid) {
                        checkVersionCode = data['versionCode_andriod'];
                      } else {
                        checkVersionCode = data['versionCode'];
                      }
                      if ((checkVersionCode == null) ||
                          (checkVersionCode == _projectCode) ||
                          (_projectCode == null)) {
                        List<dynamic> y = data['page'];
                        List<Widget> PageOptions = [];
                        Map Pagearr = new Map();

                        for (int i = 0; i < y.length; i++) {
                          Pagearr[data['page'][i]] = data['url'][i];
                          if (data['page'][i].toString() ==
                              "Staff Conference") {
                            String LinkName = data['page'][i].toString();
                            String imageUrl = data['url'][i].toString();
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          data['page'][i].toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if (data['page'][i].toString() ==
                              "Join Conference") {
                            String LinkName = data['page'][i].toString();
                            String imageUrl = data['url'][i].toString();
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          data['page'][i].toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          }
                        }
                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: GridView.count(
                              crossAxisCount: 2,
                              children: PageOptions,
                            ));
                      } else {
                        print(" check try " + checkVersionCode!);
                        print(" check version " + _projectCode!);
                        return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            title: Text(
                              'Welcome',
                              style: TextStyle(
                                  color: AppTheme.appColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            content: Text(
                              "Please Check App Update",
                              style: TextStyle(
                                  color: AppTheme.appColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ));
                      }
                    }
                  },
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: SpinKitPouringHourGlass(
                      color: AppTheme.appColor,
                    ),
                  ),
                )),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(widget.type, widget.Id);
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

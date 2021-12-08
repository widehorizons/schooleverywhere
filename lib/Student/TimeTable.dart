import '../Networking/TimeTableURL.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';

class TimeTable extends StatefulWidget {
  final String type;
  const TimeTable(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _TimeTableState();
  }
}

class _TimeTableState extends State<TimeTable> {
  Staff? loggedStaff;
  Parent? loggedParent;
  Student? loggedStudent;
  bool isLoading = false;
  List<dynamic> listOfPeriods = [];
  List<dynamic> listOfDays = [];
  Map timeTableData = new Map();
  String? userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      userSemester,
      childern;
  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userSection = loggedParent!.childeSectionSelected;
      userAcademicYear = loggedParent!.academicYear;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      userClass = loggedParent!.classChild;
      userSemester = loggedParent!.semester;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childern = loggedParent!.regno;
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userSemester = loggedStudent!.semester;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childern = loggedStudent!.id;
    } else {
      loggedStaff = await getUserData() as Staff;
      userSection = loggedStaff!.section;
      userAcademicYear = loggedStaff!.academicYear;
      userStage = loggedStaff!.stage;
      userGrade = loggedStaff!.grade;
      userClass = loggedStaff!.staffClass;
      userSemester = loggedStaff!.semester;
      userId = loggedStaff!.id;
      userType = loggedStaff!.type;
      childern = loggedStaff!.id;
    }
    syncTimeTablePeriod();
  }

  Future<void> syncTimeTablePeriod() async {
    EventObject objectEventDates;
    if (widget.type == STAFF_TYPE)
      objectEventDates = await getStaffTimeTable(
          userSection!,
          userAcademicYear!,
          userStage!,
          userGrade!,
          userClass!,
          userSemester!,
          userId!);
    else
      objectEventDates = await getTimeTable(userSection!, userAcademicYear!,
          userStage!, userGrade!, userClass!, userSemester!);
    if (objectEventDates.success!) {
      timeTableData = objectEventDates.object as Map;
      List<dynamic> listOfColumns = timeTableData['period'];
      listOfDays = timeTableData['days'];
      setState(() {
        listOfPeriods = listOfColumns;
        isLoading = true;
      });
    } else {
      String? msg = objectEventDates.object as String?;
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

  @override
  Widget build(BuildContext context) {
    final showData = !isLoading
        ? Container()
        : Center(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(" Period/Time\n  days ",
                            style: TextStyle(
                                color: AppTheme.appColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    for (var i in listOfPeriods)
                      DataColumn(
                          label: Text(i.toString(),
                              style: TextStyle(
                                  color: AppTheme.appColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))),
                  ],
                  rows:
                      listOfDays // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element.toString(),
                                        style: TextStyle(
                                            color: AppTheme.appColor,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))),
                                    for (var names in timeTableData[
                                        element]) //Extracting from Map element the value
                                      DataCell(Text(names.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))),
                                  ],
                                )),
                          )
                          .toList(),
                )));

    final body = ListView(children: <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: showData,
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 100.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {
              if (widget.type == STAFF_TYPE) {
                await launch(TimeTableURL.BASE_URL_TIME_TABLE_STAFF +
                    "?myyears=" +
                    userAcademicYear! +
                    "&sections=" +
                    userSection! +
                    "&stage=" +
                    userStage! +
                    "&grade=" +
                    userGrade! +
                    "&staffid=" +
                    userId! +
                    "&semester=" +
                    userSemester!);
              } else {
                await launch(TimeTableURL.BASE_URL_TIME_TABLE +
                    "?myyears=" +
                    userAcademicYear! +
                    "&sections=" +
                    userSection! +
                    "&stage=" +
                    userStage! +
                    "&grade=" +
                    userGrade! +
                    "&class=" +
                    userClass! +
                    "&semester=" +
                    userSemester!);
              }
            },
            color: AppTheme.appColor,
            child: Text('Overall', style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    ]);

    /* final zoomBody= Zoom(
        width: 2000,
        height: 1800,
        onPositionUpdate: (Offset position){

          print(position);

        },
        onScaleUpdate: (double scale,double zoom){

          print("$scale  $zoom");

        },
        child: Center(
          child: ,
        )
    );
*/
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
                        type: userType!,
                        sectionid: userSection!,
                        Id: childern!,
                        Academicyear: userAcademicYear!)));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('FlavorConfig.instance.values.imagePath!'),
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
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(userType!, userId!);
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

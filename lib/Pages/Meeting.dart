import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../Style/theme.dart';

import 'LoginPage.dart';
import '../SharedPreferences/Prefs.dart';

class Meeting extends StatefulWidget {
  final String type;

  const Meeting(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _MeetingState();
  }
}

class _MeetingState extends State<Meeting> {
  Staff? loggedStaff;
  Parent? loggedParent;
  Student? loggedStudent;

  String? userAcademicYear, userId, userType, userSection, userChildren;
  List<dynamic> dataShow = [];
  List<dynamic> dataShowOne = [];
  List<dynamic> dataShowTwo = [];
  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userId = loggedParent!.id;
      userChildren = loggedParent!.regno;
      userType = loggedParent!.type;
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userId = loggedStudent!.id;
      userChildren = loggedStudent!.id;
      userType = loggedStudent!.type;
    } else {
      loggedStaff = await getUserData() as Staff;
      userAcademicYear = loggedStaff!.academicYear;
      userSection = loggedStaff!.section;
      userId = loggedStaff!.id;
      userChildren = loggedStaff!.id;
      userType = loggedStaff!.type;
    }
    _getDataMeeting();
  }

  Future<void> _getDataMeeting() async {
    EventObject objectEventMessageData;
    EventObject objectEventMessageDataPartOne;
    EventObject objectEventMessageDataPartTwo;
    if (widget.type == PARENT_TYPE || widget.type == STUDENT_TYPE) {
      objectEventMessageData =
          await getStudentMeeting(userChildren!, userAcademicYear!);
      if (objectEventMessageData.success!) {
        Map? messageData = objectEventMessageData.object as Map?;
        List<dynamic> listOfColumns = messageData!['data'];
        setState(() {
          dataShow = listOfColumns;
        });
      } else {
        String? msg = objectEventMessageData.object as String?;
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
    } else {
      objectEventMessageData =
          await getStudentMeeting(userChildren!, userAcademicYear!);
      objectEventMessageDataPartOne =
          await getStaffMeetingPartOne(userChildren!, userAcademicYear!);
      objectEventMessageDataPartTwo =
          await getStaffMeetingPartTwo(userChildren!, userAcademicYear!);
      if (objectEventMessageDataPartOne.success!) {
        Map? messageDataOne = objectEventMessageDataPartOne.object as Map?;
        List<dynamic> listOfColumnsOne = messageDataOne!['data'];
        setState(() {
          dataShowOne = listOfColumnsOne;
        });
      }
      if (objectEventMessageDataPartTwo.success!) {
        Map? messageDataTwo = objectEventMessageDataPartTwo.object as Map?;
        List<dynamic> listOfColumnsTwo = messageDataTwo!['data'];
        setState(() {
          dataShowTwo = listOfColumnsTwo;
        });
      }

      if (!objectEventMessageDataPartTwo.success! &&
          !objectEventMessageDataPartOne.success!) {
        String? msg = objectEventMessageData.object as String?;
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
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == PARENT_TYPE || widget.type == STUDENT_TYPE) {
      final showData = Center(
          child: Column(
        children: <Widget>[
          DataTable(
            columns: [
              DataColumn(
                  label: Text(
                "Purpose",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                overflow: TextOverflow.ellipsis,
              )),
              DataColumn(
                  label: Text(
                "Meeting Date",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Meeting Time",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Staff",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Venue",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
              DataColumn(
                  label: Text(
                "Duration",
                style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              )),
            ],
            rows:
                dataShow // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(
                                element["meettype"] ?? "",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              )),
                              //Extracting from Map element the value
                              DataCell(
                                Text(
                                  element["meetdate"] ?? "",
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  element["meettime"] ?? "",
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  element["name"] ?? "",
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  element["venue"] ?? "",
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 14),
                                ),
                              ),
                              DataCell(
                                Text(
                                  element["duration"] ?? "",
                                  style: TextStyle(
                                      color: Colors.lightBlue, fontSize: 14),
                                ),
                              ),
                            ],
                          )),
                    )
                    .toList(),
          )
        ],
      ));
      final body = ListView(children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: showData,
          ),
        ),
      ]);
      return Scaffold(
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(SCHOOL_NAME),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => HomePage(
                          type: userType!,
                          sectionid: userSection!,
                          Id: userId!,
                          Academicyear: userAcademicYear!)));
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('img/logo.png'),
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
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0), child: body),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 55,
            onPressed: () {
              logOut(userType!, userId!);
              removeUserData();
              while (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
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
    } else {
      final showData = Align(
          alignment: Alignment.topLeft,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      "Message",
                      style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                  rows:
                      dataShowOne // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                      element["mess"],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    )),
                                    //Extracting from Map element the value
                                  ],
                                )),
                          )
                          .toList(),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
              ),
              DataTable(
                columns: [
                  DataColumn(
                      label: Text(
                    "Purpose",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataColumn(
                      label: Text(
                    "Meeting Date",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                  )),
                  DataColumn(
                      label: Text(
                    "Meeting Time",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                  )),
                  /* DataColumn(label: Text("Staff",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 16),)),
                  DataColumn(label: Text("Venue",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 16),)),
                  DataColumn(label: Text("Duration",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 16),)),*/
                ],
                rows:
                    dataShowTwo // Loops through dataColumnText, each iteration assigning the value to element
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    element["meettype"],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  )),
                                  //Extracting from Map element the value
                                  DataCell(
                                    Text(
                                      element["meetdate"],
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 14),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      element["meettime"],
                                      style: TextStyle(
                                          color: Colors.lightBlue,
                                          fontSize: 14),
                                    ),
                                  ),
                                  /*DataCell(
                            Text(element["name"],
                              style: TextStyle(color: Colors.lightBlue,
                                  fontSize: 14),),),
                          DataCell(
                            Text(element["venue"],
                              style: TextStyle(color: Colors.lightBlue,
                                  fontSize: 14),),),
                          DataCell(
                            Text(element["duration"],
                              style: TextStyle(color: Colors.lightBlue,
                                  fontSize: 14),),),*/
                                ],
                              )),
                        )
                        .toList(),
              )
            ],
          ));

      final body = ListView(children: <Widget>[
        SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: showData,
          ),
        ),
      ]);
      return Scaffold(
        appBar: new AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(SCHOOL_NAME),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(new MaterialPageRoute(
                      builder: (context) => HomePage(
                          type: userType!,
                          sectionid: userSection!,
                          Id: userChildren!,
                          Academicyear: userAcademicYear!)));
                },
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('img/logo.png'),
                ),
              )
            ],
          ),
          backgroundColor: AppTheme.appColor,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
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
}

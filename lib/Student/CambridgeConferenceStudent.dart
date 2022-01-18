import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
import '../Networking/ApiConstants.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Messages.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';

import '../Style/theme.dart';

import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';

import 'SendMailInbox.dart';

class CambridgeConferenceStudent extends StatefulWidget {
  final String type;
  final String sessionid;

  const CambridgeConferenceStudent(this.sessionid, this.type);
  @override
  State<StatefulWidget> createState() {
    return new _CambridgeConferenceStudentState();
  }
}

class _CambridgeConferenceStudentState
    extends State<CambridgeConferenceStudent> {
  Student? loggedStudent;
  Parent? loggedParent;
  int? JoinStaff;
  String? userRegno;
  String? urlConference;
  String? typeUser;
  String? userAcademicYear,
      userId,
      userType,
      userSection,
      childId,
      userstage,
      usergrade,
      userclass,
      usersemester,
      username;
  List<dynamic> listOfMessage = [];
  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getUrlConference() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getCambridgeUrlConferenceData(userSection!);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['conference'];
      print("url conference:" + data['conference']);
    }
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userstage = loggedParent!.stage;
      usergrade = loggedParent!.grade;
      childId = loggedParent!.regno;
      userclass = loggedParent!.classChild;
      usersemester = loggedParent!.semester;
      userId = loggedParent!.id;
      username = loggedParent!.name;
      typeUser = "parent";
      _getMessages();
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childId = loggedStudent!.id;
      userstage = loggedStudent!.stage;
      usergrade = loggedStudent!.grade;
      userclass = loggedStudent!.studentClass;
      usersemester = loggedStudent!.semester;
      username = loggedStudent!.name;
      typeUser = "student";
      _getMessages();
    }
    getUrlConference();
  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData =
        await getCambridgeStudentConferenceData(
            childId!, userAcademicYear!, userSection!, widget.sessionid);
    if (objectEventMessageData.success!) {
      Map? messageData = objectEventMessageData.object as Map?;
      List<dynamic> listOfColumns = messageData!['data'];
      setState(() {
        listOfMessage = listOfColumns;
      });
    }

    // JitsiMeet.addListener(JitsiMeetingListener(
    //     onConferenceWillJoin: _onConferenceWillJoin,
    //     onConferenceJoined: _onConferenceJoined,
    //     onConferenceTerminated: _onConferenceTerminated,
    //     onError: _onError));
  }

  Future<void> JoinConferenceStatus(
      String roomChannelName, String staffid, String StaffSubjectId) async {
    EventObject objectEvent = new EventObject();
    objectEvent = await JoinCambridgeConference(
        roomChannelName,
        userId!,
        userAcademicYear!,
        StaffSubjectId,
        userSection!,
        userstage!,
        usergrade!,
        userclass!,
        usersemester!,
        typeUser!);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      JoinStaff = data!['data'];
    }
  }

  Future<void> ConferenceTerminatedStatus() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await CambridgeConferenceTerminated(JoinStaff!);
  }

  @override
  void dispose() {
    super.dispose();
    // JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    final showData = Center(
        child: ListView(
      children: <Widget>[
        DataTable(
          columns: [
            DataColumn(
                label: Text(
              "Teacher",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Subject",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Conference",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
          ],
          rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                              element["teacher"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),
                            DataCell(Text(
                              element["subject"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),
                            //Extracting from Map element the value
                            DataCell(
                              Text(
                                "Conference",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () async {
                                // _joinMeeting(ApiConstants.ConferenceSchoolName +
                                //     "Schooleverywhere" +
                                //     element["staffid"] +
                                //     element["subjectid"] +
                                //     widget.sessionid);
                                JoinConferenceStatus(
                                    ApiConstants.ConferenceSchoolName +
                                        "Schooleverywhere" +
                                        element["staffid"] +
                                        element["subjectid"] +
                                        widget.sessionid,
                                    element["staffid"],
                                    element["subjectid"]);
                              },
                            ),
                          ],
                        )),
                  )
                  .toList(),
        )
      ],
    ));
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
                        Id: childId!,
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
            padding: EdgeInsets.symmetric(vertical: 10.0), child: showData),
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

  // _joinMeeting(String RoomChannel) async {
  //   print(RoomChannel);

  //   try {
  //     var options = JitsiMeetingOptions(
  //         room: RoomChannel) // Required, spaces will be trimmed
  //       ..serverURL = urlConference
  //       ..subject = "Schooleverywhere Conference"
  //       ..userDisplayName = username
  //       ..audioOnly = false
  //       ..audioMuted = false
  //       ..videoMuted = false;

  //     debugPrint("JitsiMeetingOptions: $options");
  //     await JitsiMeet.joinMeeting(
  //       options,
  //       listener: JitsiMeetingListener(
  //           onConferenceWillJoin: (message) {
  //             debugPrint("${options.room} will join with message: $message");
  //           },
  //           onConferenceJoined: (message) {
  //             debugPrint("${options.room} joined with message: $message");
  //           },
  //           onConferenceTerminated: (message) {
  //             debugPrint("${options.room} terminated with message: $message");
  //           },
  //           genericListeners: [
  //             JitsiGenericListener(
  //                 eventName: 'readyToClose',
  //                 callback: (dynamic message) {
  //                   debugPrint("readyToClose callback");
  //                 }),
  //           ]),
  //     );
  //   } catch (error) {
  //     debugPrint("error: $error");
  //   }
  // }

  void _onConferenceWillJoin(message) {
    debugPrint("_onConferenceWillJoin broadcasted with message: $message");
  }

  void _onConferenceJoined(message) {
    debugPrint("_onConferenceJoined broadcasted with message: $message");
  }

  void _onConferenceTerminated(message) {
    debugPrint("_onConferenceTerminated broadcasted with message: $message");
    ConferenceTerminatedStatus();
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}

class DetailPage extends StatelessWidget {
  final Messages msg;

  DetailPage(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(msg.messageTitle),
    ));
  }
}

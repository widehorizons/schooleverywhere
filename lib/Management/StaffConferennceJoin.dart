import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../Networking/ApiConstants.dart';
import '../Modules/Management.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';

class StaffConferennceJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StaffConferennceJoinState();
  }
}

class StaffConferennceJoinState extends State<StaffConferennceJoin> {
  Management? loggedManagement;
  String? userAcademicYear,
      userSection,
      userSectionName,
      userId,
      userType,
      userName;
  int? JoinStaff;
  String? urlConference;
  String? IdRowJoin;
  List<dynamic> listOfMessage = [];
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getUrlConference() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getUrlConferenceData(userSection!);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['conference'];
    }
  }

  Future<void> getLoggedInUser() async {
    loggedManagement = await getUserData() as Management;
    userAcademicYear = loggedManagement!.academicYear;
    userSection = loggedManagement!.section;
    userSectionName = loggedManagement!.sectionName;
    userId = loggedManagement!.id!;
    userType = loggedManagement!.type!;
    userName = loggedManagement!.name!;
    getUrlConference();
    _getMessages();
  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData = await getConferenceStaffData();
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

  Future<void> JoinConferenceStatus(String Id) async {
    EventObject objectEvent = new EventObject();
    objectEvent = await JoinConferenceSatff(Id, userId!);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
  }

  Future<void> ConferenceTerminatedStatus(String Id) async {
    EventObject objectEvent = new EventObject();
    objectEvent = await ConferenceTerminatedStaffJoin(Id, userId!);
  }

  SetConferenceJoinId(String IdRow) {
    IdRowJoin = IdRow;
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
              "Staff Name",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Start",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Join",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
          ],
          rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                              element["staffname"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),

                            DataCell(Text(
                              element["startdate"],
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
                                // _joinMeeting(ApiConstants.ConferenceSchoolName+"Schooleverywhere"+element["staffid"]);
                                SetConferenceJoinId(element["id"]);
                                JoinConferenceStatus(element["id"]);
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
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('img/logo.png'),
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

  _onAudioOnlyChanged(bool value) {
    setState(() {
      isAudioOnly = value;
    });
  }

  _onAudioMutedChanged(bool value) {
    setState(() {
      isAudioMuted = value;
    });
  }

  _onVideoMutedChanged(bool value) {
    setState(() {
      isVideoMuted = value;
    });
  }

  // _joinMeeting(RoomChannel) async {
  //   try {
  //     var options = JitsiMeetingOptions(
  //         room: RoomChannel) // Required, spaces will be trimmed
  //       ..serverURL = urlConference
  //       ..subject = "Schooleverywhere Conference"
  //       ..userDisplayName = userName
  //       ..audioOnly = isAudioOnly
  //       ..audioMuted = isAudioMuted
  //       ..videoMuted = isVideoMuted;

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
    ConferenceTerminatedStatus(IdRowJoin!);
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}

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
import 'package:schooleverywhere/config/flavor_config.dart';

class StaffConferennce extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StaffConferennceState();
  }
}

class StaffConferennceState extends State<StaffConferennce> {
  Management? loggedManagement;
  String? userAcademicYear,
      userSection,
      userSectionName,
      userId,
      userType,
      userName;
  int? JoinStaff;
  String? urlConference;

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

    // JitsiMeet.addListener(JitsiMeetingListener(
    //     onConferenceWillJoin: _onConferenceWillJoin,
    //     onConferenceJoined: _onConferenceJoined,
    //     onConferenceTerminated: _onConferenceTerminated,
    //     onError: _onError));
    getUrlConference();
  }

  Future<void> JoinConferenceStatus() async {
    //print("fff");
    EventObject objectEvent = new EventObject();
    objectEvent = await JoinConferenceStaffMain(userId!);
    Map? data = objectEvent.object as Map?;
    //print(userId+"gggg");

    if (objectEvent.success!) {
      JoinStaff = data!['data'];
    }
  }

  Future<void> ConferenceTerminatedStatus() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await ConferenceTerminatedStaff(JoinStaff!);
  }

  @override
  void dispose() {
    super.dispose();
    // JitsiMeet.removeAllListeners();
  }

  @override
  Widget build(BuildContext context) {
    final data = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 24.0,
          ),
          CheckboxListTile(
            title: Text("Audio Only"),
            value: isAudioOnly,
            onChanged: _onAudioOnlyChanged,
          ),
          SizedBox(
            height: 16.0,
          ),
          CheckboxListTile(
            title: Text("Audio Muted"),
            value: isAudioMuted,
            onChanged: _onAudioMutedChanged,
          ),
          SizedBox(
            height: 16.0,
          ),
          CheckboxListTile(
            title: Text("Video Muted"),
            value: isVideoMuted,
            onChanged: _onVideoMutedChanged,
          ),
          Divider(
            height: 48.0,
            thickness: 2.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: RaisedButton(
              onPressed: () {
                JoinConferenceStatus();
                // _joinMeeting();
              },
              child: Text(
                "Conference",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blue,
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: data,
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

  _onAudioOnlyChanged(bool? value) {
    setState(() {
      isAudioOnly = value!;
    });
  }

  _onAudioMutedChanged(bool? value) {
    setState(() {
      isAudioMuted = value!;
    });
  }

  _onVideoMutedChanged(bool? value) {
    setState(() {
      isVideoMuted = value!;
    });
  }

  // _joinMeeting() async {
  //   try {
  //     var options = JitsiMeetingOptions(
  //         room:
  //             ApiConstants.ConferenceSchoolName + "Schooleverywhere" + userId!)
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
    ConferenceTerminatedStatus();
  }

  _onError(error) {
    debugPrint("_onError broadcasted: $error");
  }
}

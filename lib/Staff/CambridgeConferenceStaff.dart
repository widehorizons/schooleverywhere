import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Networking/ApiConstants.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';

class CambridgeConferenceStaff extends StatefulWidget {
  final String sessionValue;
  const CambridgeConferenceStaff(this.sessionValue);
  @override
  State<StatefulWidget> createState() {
    return new _CambridgeConferenceStaffState();
  }
}

class _CambridgeConferenceStaffState extends State<CambridgeConferenceStaff> {
  Staff? loggedStaff;
  String StaffSection = "Loading...";
  String StaffSectionId = "";
  String StaffStage = "Loading...";
  String StaffStageId = "";
  String StaffGrade = "Loading...";
  String StaffGradeId = "";
  String StaffSemester = "Loading...";
  String StaffSemesterId = "";
  String StaffClass = "Loading...";
  String StaffClassId = "";
  String StaffSubject = "Loading...";
  String StaffSubjectId = "";
  String academicYearValue = "Loading...";
  String? staffid;
  bool isLoading = false, checkSync = true;
  String? urlConference;
  int? JoinStaff;

  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  Map staffclassOptions = new Map();
  List? classSelected;
  List<dynamic> classstaff = [];
  String? channel;

  initState() {
    super.initState();
    classSelected = [];
    getLoggedStaff();
  }

  Future<void> getUrlConference() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getUrlConferenceData(StaffSectionId);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['conference'];
      print(data['conference']);
    }
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    StaffSection = loggedStaff!.sectionName!;
    StaffSectionId = loggedStaff!.section!;
    StaffStage = loggedStaff!.stageName!;
    StaffStageId = loggedStaff!.stage!;
    StaffGrade = loggedStaff!.gradeName!;
    StaffGradeId = loggedStaff!.grade!;
    StaffSemester = loggedStaff!.semesterName!;
    StaffSemesterId = loggedStaff!.semester!;
    StaffClass = loggedStaff!.staffClassName!;
    StaffClassId = loggedStaff!.staffClass!;
    StaffSubject = loggedStaff!.subjectName!;
    StaffSubjectId = loggedStaff!.subject!;
    staffid = loggedStaff!.id;
    academicYearValue = loggedStaff!.academicYear!;
    getUrlConference();

    JitsiMeet.addListener(JitsiMeetingListener(
        onConferenceWillJoin: _onConferenceWillJoin,
        onConferenceJoined: _onConferenceJoined,
        onConferenceTerminated: _onConferenceTerminated,
        onError: _onError));
  }

  Future<void> JoinConferenceStatus(String roomChannelName) async {
    EventObject objectEvent = new EventObject();
    objectEvent = await JoinCambridgeConference(
        roomChannelName,
        staffid!,
        academicYearValue,
        StaffSubjectId,
        StaffSectionId,
        StaffStageId,
        StaffGradeId,
        StaffClassId,
        StaffSemesterId,
        'staff');
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
    JitsiMeet.removeAllListeners();
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
                JoinConferenceStatus(ApiConstants.ConferenceSchoolName +
                    "Schooleverywhere" +
                    staffid! +
                    StaffSubjectId +
                    StaffGradeId);
                _joinMeeting();
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
            Text(SCHOOL_NAME),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: loggedStaff!.type!,
                        sectionid: loggedStaff!.section!,
                        Id: loggedStaff!.id!,
                        Academicyear: loggedStaff!.academicYear!)));
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
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height * .88,
            ),
            child: Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: data,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(loggedStaff!.type!, loggedStaff!.id!);
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

// "trySchooleverywhere"+staffid+StaffSubjectId+StaffGradeId
  _joinMeeting() async {
    try {
      var options = JitsiMeetingOptions(
          room: ApiConstants.ConferenceSchoolName +
              "Schooleverywhere" +
              staffid! +
              StaffSubjectId +
              StaffGradeId)
        ..serverURL = urlConference
        ..subject = "Schooleverywhere Conference"
        ..userDisplayName = loggedStaff!.name
        ..audioOnly = isAudioOnly
        ..audioMuted = isAudioMuted
        ..videoMuted = isVideoMuted;

      debugPrint("JitsiMeetingOptions: $options");
      await JitsiMeet.joinMeeting(
        options,
        listener: JitsiMeetingListener(
            onConferenceWillJoin: (message) {
              debugPrint("${options.room} will join with message: $message");
            },
            onConferenceJoined: (message) {
              debugPrint("${options.room} joined with message: $message");
            },
            onConferenceTerminated: (message) {
              debugPrint("${options.room} terminated with message: $message");
            },
            genericListeners: [
              JitsiGenericListener(
                  eventName: 'readyToClose',
                  callback: (dynamic message) {
                    debugPrint("readyToClose callback");
                  }),
            ]),
      );
    } catch (error) {
      debugPrint("error: $error");
    }
  }

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

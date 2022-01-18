import 'package:url_launcher/url_launcher.dart';
import '../Modules/Management.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';

class CambridgeStaffConference extends StatefulWidget {
  final String sessionid;
  const CambridgeStaffConference(this.sessionid);

  @override
  State<StatefulWidget> createState() {
    return new CambridgeStaffConferenceState();
  }
}

class CambridgeStaffConferenceState extends State<CambridgeStaffConference> {
  Management? loggedManagement;
  TextEditingController subjectValue = new TextEditingController();
  String url = ApiConstants.FILE_UPLOAD_MANAGEMENT_BY_SELECT_API;
  String? userSection, userAcademicYear, userId, userType;
  List<dynamic> listOfMessage = [];
  String? urlConference, userName;
  int? JoinStaff;
  String? IdRowJoin;
  var isAudioOnly = true;
  var isAudioMuted = true;
  var isVideoMuted = true;

  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getUrlConference() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getCambridgeUrlConferenceData(userSection!);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['conference'];
    }
  }

  Future<void> getLoggedInUser() async {
    loggedManagement = await getUserData() as Management;
    userAcademicYear = loggedManagement!.academicYear;
    userSection = loggedManagement!.section;
    userId = loggedManagement!.id!;
    userType = loggedManagement!.type!;
    userName = loggedManagement!.name!;
    getUrlConference();
    _getMessages();
  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData =
        await getCambridgeAdvancedConferenceStaffData(
            widget.sessionid, userSection!, userAcademicYear!);
    if (objectEventMessageData.success!) {
      Map? messageData = objectEventMessageData.object as Map?;
      List<dynamic> listOfColumns = messageData!['data'];
      setState(() {
        listOfMessage = listOfColumns;
      });
    }
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
    final showData = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              "Subject",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Staff Name",
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
                              element["subjectname"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),

                            DataCell(Text(
                              element["staffname"],
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: showData,
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
  //     var options = JitsiMeetingOptions(room: RoomChannel) // Required, spaces will be trimmed
  //       ..serverURL = urlConference
  //       ..subject = "Schooleverywhere Conference"
  //       ..userDisplayName = userName

  //       ..audioOnly = isAudioOnly
  //       ..audioMuted = isAudioMuted
  //       ..videoMuted = isVideoMuted;

  //     debugPrint("JitsiMeetingOptions: $options");
  //     await JitsiMeet.joinMeeting(options,
  //         listener: JitsiMeetingListener(
  //         onConferenceWillJoin: (message) {
  //           debugPrint("${options.room} will join with message: $message");
  //         },
  //         onConferenceJoined: (message) {
  //           debugPrint("${options.room} joined with message: $message");
  //         },
  //         onConferenceTerminated: (message) {
  //           debugPrint("${options.room} terminated with message: $message");
  //         },
  //         genericListeners: [
  //           JitsiGenericListener(
  //               eventName: 'readyToClose',
  //               callback: (dynamic message) {
  //                 debugPrint("readyToClose callback");
  //               }),
  //         ]),);
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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:jitsi_meet/jitsi_meet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Networking/ApiConstants.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';

class createConferenceAdvanced extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _createConferenceAdvancedState();
  }
}

class _createConferenceAdvancedState extends State<createConferenceAdvanced> {
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
    objectEvent =
        await getUrlConferenceDataByStage(StaffSectionId, StaffStageId);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['advancedConference'];
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
  }

  @override
  Widget build(BuildContext context) {
    final data = SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 24.0,
          ),
          SizedBox(
            height: 64.0,
            width: double.maxFinite,
            child: RaisedButton(
              onPressed: () async {
                //  JoinConferenceStatus(ApiConstants.ConferenceSchoolName+"Schooleverywhere"+staffid+StaffSubjectId+StaffGradeId);
                //  _joinMeeting();
                await launch(ApiConstants.BASE_URL +
                    "conference/advancedConferenceStaffStudent.php?staff=" +
                    staffid! +
                    "&subject=" +
                    StaffSubjectId +
                    "&grade=" +
                    StaffGradeId +
                    "&section=" +
                    StaffSectionId +
                    "&stage=" +
                    StaffStageId);
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
}

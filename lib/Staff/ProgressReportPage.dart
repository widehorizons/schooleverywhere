import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Networking/ProgressReport.dart';
import '../Style/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SharedPreferences/Prefs.dart';
import '../Pages/LoginPage.dart';
import '../config/flavor_config.dart';

class ProgressReportPage extends StatefulWidget {
  final String studentId;
  final String reportId;
  final String dateId;

  const ProgressReportPage(this.studentId, this.reportId, this.dateId);

  @override
  State<StatefulWidget> createState() {
    return new _ProgressReportPageState();
  }
}

class _ProgressReportPageState extends State<ProgressReportPage> {
  Staff? loggedStaff;
  String? StaffSection,
      StaffSectionId,
      StaffStageId,
      StaffGradeId,
      StaffSemesterId,
      StaffClassId,
      StaffYear;

  @override
  void initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    StaffSectionId = loggedStaff!.section;
    StaffStageId = loggedStaff!.stage;
    StaffGradeId = loggedStaff!.grade;
    StaffSemesterId = loggedStaff!.semester;
    StaffClassId = loggedStaff!.staffClass;
    StaffYear = loggedStaff!.academicYear;
  }

  @override
  Widget build(BuildContext context) {
    final goButtonPortrait = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await launch(
              ProgressReport.SCHOOL_PROGRESS_REPORT_STAFF_PORTRAIT_LINK +
                  "?myyears=" +
                  StaffYear! +
                  "&regno=" +
                  widget.studentId +
                  "&sections=" +
                  StaffSectionId! +
                  "&hisdate=" +
                  widget.dateId +
                  "&progress=" +
                  widget.reportId);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('Portrait Print', style: TextStyle(color: Colors.white)),
      ),
    );
    final goButtonLandScape = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await launch(
              ProgressReport.SCHOOL_PROGRESS_REPORT_STAFF_LAND_SCAPE_LINK +
                  "?myyears=" +
                  StaffYear! +
                  "&regno=" +
                  widget.studentId +
                  "&sections=" +
                  StaffSectionId! +
                  "&hisdate=" +
                  widget.dateId +
                  "&progress=" +
                  widget.reportId);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('Land Scape Print', style: TextStyle(color: Colors.white)),
      ),
    );
    final goButtonCore = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await launch(ProgressReport.SCHOOL_PROGRESS_REPORT_STAFF_CORE_LINK +
              "?myyears=" +
              StaffYear! +
              "&regno=" +
              widget.studentId +
              "&sections=" +
              StaffSectionId! +
              "&hisdate=" +
              widget.dateId);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('Core Print', style: TextStyle(color: Colors.white)),
      ),
    );
    final goButtonNewPrint = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await launch(ProgressReport.SCHOOL_PROGRESS_REPORT_STAFF_NEW_LINK +
              "?myyears=" +
              StaffYear! +
              "&regno=" +
              widget.studentId +
              "&sections=" +
              StaffSectionId! +
              "&hisdate=" +
              widget.dateId +
              "&progress=" +
              widget.reportId);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('New Print', style: TextStyle(color: Colors.white)),
      ),
    );
    final goButtonPrintTwo = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await launch(ProgressReport.SCHOOL_PROGRESS_REPORT_STAFF_PRINT2_LINK +
              "?myyears=" +
              StaffYear! +
              "&sections=" +
              StaffSectionId! +
              "&stage=" +
              StaffStageId! +
              "&grade=" +
              StaffGradeId! +
              "&class=" +
              StaffClassId! +
              "&hisdate=" +
              widget.dateId +
              "&hidprogressReportName=" +
              widget.reportId +
              "&stregvb=" +
              widget.studentId);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('Print 2', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: goButtonPortrait,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: goButtonLandScape,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: goButtonCore,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: goButtonNewPrint,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: goButtonPrintTwo,
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

import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Style/theme.dart';
import '../SharedPreferences/Prefs.dart';
import '../Pages/LoginPage.dart';
import 'ProgressReportPage.dart';

class ProgressReportStaffIndex extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ProgressReportStaffIndexState();
  }
}

class _ProgressReportStaffIndexState extends State<ProgressReportStaffIndex> {
  String? dateValue, reportValue, stuValue;
  Map reportOptions = new Map();
  Map dateOptions = new Map();
  Map stuOptions = new Map();
  Staff? loggedStaff;
  List<dynamic> studentsList = [];
  String? studentSelected;
  bool isGoing = false;
  bool dateSelected = false;
  bool stuSelected = false;
  bool reportSelected = false;
  String? StaffSectionId,
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
    syncGetStaffStudentId();
    syncDateOptions();
    syncReportOptions();
  }

  Future<void> syncGetStaffStudentId() async {
    EventObject objectEventStudent = await getStudentProgressPreport(
        StaffSectionId!,
        StaffStageId!,
        StaffGradeId!,
        StaffClassId!,
        StaffYear!);
    if (objectEventStudent.success!) {
      Map? data = objectEventStudent.object as Map?;
      List<dynamic> toto = data!['studentId'];
      Map stuArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        stuArr[data['studentId'][i]] = data['studentName'][i];
      }
      setState(() {
        stuOptions = stuArr;
      });
    } else {
      String? msg = objectEventStudent.object as String?;
      /*  Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncDateOptions() async {
    EventObject objectEventDate = await getDateOptions(
        StaffSectionId!, StaffYear!, StaffStageId!, StaffGradeId!, "one");
    if (objectEventDate.success!) {
      Map? data = objectEventDate.object as Map?;
      List<dynamic> toto = data!['dateid'];
      Map dateArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        dateArr[data['dateid'][i]] = data['dateName'][i];
      }
      setState(() {
        dateOptions = dateArr;
      });
    } else {
      String? msg = objectEventDate.object as String?;
      /*   Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
      Fluttertoast.showToast(
          msg: msg.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> syncReportOptions() async {
    EventObject objectEventReport = await getReportOptions(
        StaffSectionId!, StaffYear!, StaffStageId!, StaffGradeId!, "one");
    if (objectEventReport.success!) {
      Map? data = objectEventReport.object as Map?;
      List<dynamic> toto = data!['reportid'];
      Map reportArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        reportArr[data['reportid'][i]] = data['reportName'][i];
      }
      setState(() {
        reportOptions = reportArr;
      });
    } else {
      String? msg = objectEventReport.object as String?;
      /*  Flushbar(
        title: "Failed",
        message: msg.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
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
    final selectedStudent = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: stuValue,
            hint: Text("Select Student"),
            style: TextStyle(color: AppTheme.appColor),
            underline: Container(
              height: 2,
              color: AppTheme.appColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                stuSelected = true;
                stuValue = newValue!;
              });
            },
            items: stuOptions
                .map((key, value) {
                  return MapEntry(
                      value,
                      DropdownMenuItem<String>(
                        value: key,
                        child: Text(value),
                      ));
                })
                .values
                .toList()));

    final date = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: dateValue,
            hint: Text("Select Date"),
            style: TextStyle(color: AppTheme.appColor),
            underline: Container(
              height: 2,
              color: AppTheme.appColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                dateSelected = true;
                dateValue = newValue!;
              });
            },
            items: dateOptions
                .map((key, value) {
                  return MapEntry(
                      value,
                      DropdownMenuItem<String>(
                        value: key,
                        child: Text(value),
                      ));
                })
                .values
                .toList()));

    final report = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: reportValue,
            hint: Text("Select Progress Report Name"),
            style: TextStyle(color: AppTheme.appColor),
            underline: Container(
              height: 2,
              color: AppTheme.appColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                reportSelected = true;
                reportValue = newValue!;
              });
            },
            items: reportOptions
                .map((key, value) {
                  return MapEntry(
                      value,
                      DropdownMenuItem<String>(
                        value: key,
                        child: Text(value),
                      ));
                })
                .values
                .toList()));

    final goButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          if (reportValue != null && stuValue != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ProgressReportPage(stuValue!, reportValue!, dateValue!)),
            );
          } else {
            /*  Flushbar(
              title: "Failed",
              message: "Please Select Report",
              icon: Icon(Icons.close),
              backgroundColor: AppTheme.appColor,
              duration: Duration(seconds: 3),
            )
              ..show(context);*/
            Fluttertoast.showToast(
                msg: "Please Select Report",
                toastLength: Toast.LENGTH_LONG,
                timeInSecForIosWeb: 3,
                backgroundColor: AppTheme.appColor,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('GO', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: selectedStudent,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: date,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: report,
          ),
          stuValue != null && reportValue != null
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: isGoing
                      ? SpinKitPouringHourGlass(
                          color: AppTheme.appColor,
                        )
                      : goButton,
                )
              : Container(),
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
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              backgroundImage: AssetImage('img/logo.png'),
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

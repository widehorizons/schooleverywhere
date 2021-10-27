import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Networking/ProgressReport.dart';
import '../Style/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SharedPreferences/Prefs.dart';
import '../Pages/LoginPage.dart';

class ProgressReportIndex2 extends StatefulWidget {
  final String type;
  const ProgressReportIndex2(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _ProgressReportIndex2State();
  }
}

class _ProgressReportIndex2State extends State<ProgressReportIndex2> {
  String? dateValue, reportValue, subValue;
  bool dateSelected = false, subSelected = false;
  Map reportOptions = new Map();
  Map dateOptions = new Map();
  Map subjectOption = new Map();
  Student? loggedStudent;
  Parent? loggedParent;

  bool isGoing = false;
  String? userAcademicYear,
      userId,
      userType,
      userSection,
      userRegno,
      userstage,
      usergrade;

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
      userstage = loggedParent!.stage;
      usergrade = loggedParent!.grade;
      userRegno = loggedParent!.regno;
      syncGetStudentSubject();
      syncDateOptions();
      syncReportOptions();
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userstage = loggedStudent!.stage;
      usergrade = loggedStudent!.grade;
      userRegno = loggedStudent!.id;
      syncGetStudentSubject();
      syncDateOptions();
      syncReportOptions();
    }
  }

  Future<void> syncGetStudentSubject() async {
    EventObject objectEvent = new EventObject();
    if (widget.type == PARENT_TYPE) {
      objectEvent = await getSubjectReceiveFromTeacher(
          loggedParent!.childeSectionSelected,
          loggedParent!.academicYear,
          loggedParent!.stage,
          loggedParent!.grade,
          loggedParent!.semester);
    } else {
      objectEvent = await getSubjectReceiveFromTeacher(
          loggedStudent!.section!,
          loggedStudent!.academicYear!,
          loggedStudent!.stage!,
          loggedStudent!.grade!,
          loggedStudent!.semester!);
    }
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> y = data!['subjectId'];
      Map SubjectArr = new Map();
      for (int i = 0; i < y.length; i++) {
        SubjectArr[data['subjectId'][i]] = data['subjectName'][i];
      }
      setState(() {
        subjectOption = SubjectArr;
      });
    } else {
      String? msg = objectEvent.object as String?;
      /* Flushbar(
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

  Future<void> syncDateOptions() async {
    EventObject objectEventDate = await getDateOptions(
        userSection!, userAcademicYear!, userstage!, usergrade!, "one");
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

  Future<void> syncReportOptions() async {
    EventObject objectEventReport = await getReportOptions(
        userSection!, userAcademicYear!, userstage!, usergrade!, "one");
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
    final subject = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: subValue,
            hint: Text("Select Subject"),
            style: TextStyle(color: AppTheme.appColor),
            underline: Container(
              height: 2,
              color: AppTheme.appColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                subSelected = true;
                subValue = newValue!;
              });
            },
            items: subjectOption
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
          if (reportValue != null) {
            await launch(ProgressReport.SCHOOL_PROGRESS_REPORT_TWO_LINK +
                "?myyears=" +
                userAcademicYear! +
                "&regno=" +
                userRegno! +
                "&sections=" +
                userSection! +
                "&hisdate=" +
                dateValue! +
                "&progress=" +
                reportValue! +
                "&subject=" +
                subValue!);
          } else {
            await launch(ProgressReport.SCHOOL_PROGRESS_REPORT_TWO_LINK +
                "?myyears=" +
                userAcademicYear! +
                "&regno=" +
                userRegno! +
                "&sections=" +
                userSection! +
                "&hisdate=" +
                dateValue! +
                "&subject=" +
                subValue!);
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
            child: subject,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: date,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: report,
          ),
          subSelected && dateSelected
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
            logOut(loggedStudent!.type!, loggedStudent!.id!);
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

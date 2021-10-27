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

class ProgressReportIndex extends StatefulWidget {
  final String type;
  final String pageType;
  const ProgressReportIndex(this.type, this.pageType);

  @override
  State<StatefulWidget> createState() {
    return new _ProgressReportIndexState();
  }
}

class _ProgressReportIndexState extends State<ProgressReportIndex> {
  String? dateValue, reportValue;
  Map reportOptions = new Map();
  Map dateOptions = new Map();
  String? typeOptions;
  String? typename, userstage, usergrade;
  Student? loggedStudent;
  Parent? loggedParent;

  bool isGoing = false;
  bool dateSelected = false;
  String? userAcademicYear, userId, userType, userSection, userRegno;

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
      syncDateOptions();
      syncReportOptions();
      getTypeProgressReport();
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userRegno = loggedStudent!.id;
      userstage = loggedStudent!.stage;
      usergrade = loggedStudent!.grade;
      syncDateOptions();
      syncReportOptions();
      getTypeProgressReport();
    }
  }

  Future<void> syncDateOptions() async {
    EventObject objectEventDate = await getDateOptions(userSection!,
        userAcademicYear!, userstage!, usergrade!, widget.pageType);
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
    EventObject objectEventReport = await getReportOptions(userSection!,
        userAcademicYear!, userstage!, usergrade!, widget.pageType);
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

  Future<void> getTypeProgressReport() async {
    EventObject objectEventtype = await typeProgressReport(
        userSection!, userAcademicYear!, widget.pageType);
    if (objectEventtype.success!) {
      String? toto = objectEventtype.object as String?;
      setState(() {
        typeOptions = toto!;
      });
      print("Data: " + toto.toString());
    } else {
      String? msg = objectEventtype.object as String?;
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

  @override
  Widget build(BuildContext context) {
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
          if (widget.pageType == "one") {
            if (typeOptions == 'printevaluate') {
              setState(() {
                typename =
                    ProgressReport.SCHOOL_STUDENT_PROGRESS_REPORT_ONE_LINK;
              });
            } else if (typeOptions == 'printevaluatetwo') {
              setState(() {
                typename =
                    ProgressReport.SCHOOL_STUDENT_PROGRESS_REPORT_TWO_LINK;
              });
            } else if (typeOptions == 'printevaluatecore') {
              setState(() {
                typename =
                    ProgressReport.SCHOOL_STUDENT_PROGRESS_REPORT_CORE_LINK;
              });
            } else if (typeOptions == 'viewprogressreportprint') {
              setState(() {
                typename =
                    ProgressReport.SCHOOL_STUDENT_PROGRESS_REPORT_PRINT_LINK;
              });
            } else {
              setState(() {
                typename =
                    ProgressReport.SCHOOL_STUDENT_PROGRESS_REPORT_NEW_LINK;
              });
            }
          } else {
            if (typeOptions == 'printProgressReportAltTwo') {
              setState(() {
                typename = ProgressReport.SCHOOL_PROGRESS_REPORT_ALT_TWO_LINK;
              });
            } else {
              setState(() {
                typename = ProgressReport.SCHOOL_PROGRESS_REPORT_ALT_ONE_LINK;
              });
            }
          }
          if (reportValue != null) {
            await launch(typename! +
                "?myyears=" +
                userAcademicYear! +
                "&regno=" +
                userRegno! +
                "&sections=" +
                userSection! +
                "&hisdate=" +
                dateValue! +
                "&hidprogressReportName=" +
                reportValue! +
                "&stage=" +
                userstage! +
                "&grade=" +
                usergrade!);
          } else {
            await launch(typename! +
                "?myyears=" +
                userAcademicYear! +
                "&regno=" +
                userRegno! +
                "&sections=" +
                userSection! +
                "&hisdate=" +
                dateValue!);
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
            child: date,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: report,
          ),
          dateSelected
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

import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schooleverywhere/config/flavor_config.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Style/theme.dart';

import '../SharedPreferences/Prefs.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class StaffPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _StaffPageState();
  }
}

class _StaffPageState extends State<StaffPage> {
  String? academicYearValue,
      semesterValue,
      semesterName,
      sectionValue,
      sectionName,
      stageValue,
      stageName,
      gradeValue,
      gradeName,
      staffclassValue,
      staffclassName,
      subjectValue,
      subjectName;
  bool academicYearSelected = false,
      sectionSelected = false,
      stageSelected = false,
      gradeSelected = false,
      semesterSelected = false,
      staffclassSelected = false,
      subjectSelected = false;
  List<String> academicYearsOptions = [];
  Map sectionsOptions = new Map();
  Map stageOptions = new Map();
  Map gradeOptions = new Map();
  Map semestersOptions = new Map();
  Map staffclassOptions = new Map();
  Map subjectOptions = new Map();
  Staff? loggedStaff;

  bool checkSupervisor = false;

  @override
  initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    checkSupervisor = loggedStaff!.supervisorStaff!;
    if (loggedStaff!.section != null &&
        loggedStaff!.academicYear != null &&
        loggedStaff!.stage != null &&
        loggedStaff!.grade != null &&
        loggedStaff!.semester != null &&
        loggedStaff!.staffClass != null &&
        loggedStaff!.subject != null &&
        !checkSupervisor) {
      sectionValue = loggedStaff!.section;
      sectionName = loggedStaff!.sectionName;
      academicYearValue = loggedStaff!.academicYear;
      stageValue = loggedStaff!.stage;
      stageName = loggedStaff!.stageName;
      gradeValue = loggedStaff!.grade;
      gradeName = loggedStaff!.gradeName;
      semesterValue = loggedStaff!.semester;
      semesterName = loggedStaff!.semesterName;
      staffclassValue = loggedStaff!.staffClass;
      staffclassName = loggedStaff!.staffClassName;
      subjectValue = loggedStaff!.subject;
      subjectName = loggedStaff!.subjectName;
      sectionSelected = true;
      academicYearSelected = true;
      stageSelected = true;
      gradeSelected = true;
      semesterSelected = true;
      staffclassSelected = true;
      subjectSelected = true;
      syncSectionOptions();
      syncAcademicYearOptions();
      syncStageOptions();
      syncGradeOptions();
      syncSemesterOptions();
      syncClassOptions();
      syncSubjectOptions();
    } else
      syncSectionOptions();
  }

  Future<void> syncAcademicYearOptions() async {
    EventObject objectEventYear = await academicYearOptions(sectionValue!);
    if (objectEventYear.success!) {
      List<dynamic>? toto = objectEventYear.object as List?;
      List<String> convert = [];
      for (int i = 0; i < toto!.length; i++) {
        convert.add(toto[i].toString());
      }
      setState(() {
        academicYearsOptions = convert;
      });
      print("Data: " + toto.toString());
    } else {
      String? msg = objectEventYear.object as String?;
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

  Future<void> syncSectionOptions() async {
    EventObject objectEventSection =
        await sectionStaffOptions(loggedStaff!.id!);
    if (objectEventSection.success!) {
      Map? toto = objectEventSection.object as Map?;
      List<dynamic> x = toto!['idSection'];
      Map Sectionarr = new Map();
      for (int i = 0; i < x.length; i++) {
        Sectionarr[toto['idSection'][i]] = toto['sectionName'][i];
      }
      setState(() {
        sectionsOptions = Sectionarr;
        print("section map:" + Sectionarr.toString());
      });
    } else {
      String? msg = objectEventSection.object as String?;
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

  Future<void> syncStageOptions() async {
    EventObject objectEventStage = await stageStaffOptions(
        sectionValue!, academicYearValue!, loggedStaff!.id!);
    if (objectEventStage.success!) {
      Map? data = objectEventStage.object as Map?;
      List<dynamic> x = data!['stageId'];
      Map Stagearr = new Map();
      for (int i = 0; i < x.length; i++) {
        Stagearr[data['stageId'][i]] = data['stageName'][i];
      }
      setState(() {
        stageOptions = Stagearr;
        print("stage map:" + Stagearr.toString());
      });
    } else {
      String? msg = objectEventStage.object as String?;
      /*   Flushbar(
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

  Future<void> syncGradeOptions() async {
    EventObject objectEventGarde = await gradeStaffOptions(
        sectionValue!, stageValue!, academicYearValue!, loggedStaff!.id!);
    if (objectEventGarde.success!) {
      Map? data = objectEventGarde.object as Map?;
      List<dynamic> y = data!['gardeId'];
      Map Gardearr = new Map();
      for (int i = 0; i < y.length; i++) {
        Gardearr[data['gardeId'][i]] = data['gardeName'][i];
      }
      setState(() {
        gradeOptions = Gardearr;
        print("grade map:" + Gardearr.toString());
      });
    } else {
      String? msg = objectEventGarde.object as String?;
      /*   Flushbar(
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

  Future<void> syncSemesterOptions() async {
    EventObject objectEventSemester = await semesterStaffOptions(
        sectionValue!, stageValue!, gradeValue!, academicYearValue!);
    if (objectEventSemester.success!) {
      Map? data = objectEventSemester.object as Map?;
      List<dynamic> z = data!['semisterId'];
      Map Semesterarr = new Map();
      for (int i = 0; i < z.length; i++) {
        Semesterarr[data['semisterId'][i]] = data['semisterName'][i];
      }
      setState(() {
        semestersOptions = Semesterarr;
        print("semester map:" + Semesterarr.toString());
      });
    } else {
      String? msg = objectEventSemester.object as String?;
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

  Future<void> syncClassOptions() async {
    EventObject objectEventClass = await classStaffOptions(sectionValue!,
        stageValue!, gradeValue!, academicYearValue!, loggedStaff!.id!);
    if (objectEventClass.success!) {
      Map? data = objectEventClass.object as Map?;
      List<dynamic> m = data!['classId'];
      Map Classarr = new Map();
      for (int i = 0; i < m.length; i++) {
        Classarr[data['classId'][i]] = data['classsName'][i];
      }
      setState(() {
        staffclassOptions = Classarr;
        print("class map:" + Classarr.toString());
      });
    } else {
      String? msg = objectEventClass.object as String?;
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

  Future<void> syncSubjectOptions() async {
    EventObject objectEventSubject = await subjectStaffOptions(
        sectionValue!,
        stageValue!,
        gradeValue!,
        academicYearValue!,
        loggedStaff!.id!,
        semesterValue!,
        staffclassValue!);
    if (objectEventSubject.success!) {
      Map? data = objectEventSubject.object as Map?;
      List<dynamic> n = data!['subjectId'];
      Map Subjectarr = new Map();
      for (int i = 0; i < n.length; i++) {
        Subjectarr[data['subjectId'][i]] = data['subjectName'][i];
      }
      setState(() {
        subjectOptions = Subjectarr;
        print("subject map:" + Subjectarr.toString());
      });
    } else {
      Object? msg = objectEventSubject.object;
      /*   Flushbar(
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
    final section = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: sectionValue,
          hint: Text("Select Section"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              sectionSelected = true;
              sectionValue = newValue!;
              sectionName = sectionsOptions[newValue];
              academicYearsOptions.clear();
              academicYearValue = null;
              academicYearSelected = false;
              stageOptions.clear();
              stageValue = null;
              stageName = null;
              stageSelected = false;
              gradeOptions.clear();
              gradeValue = null;
              gradeName = null;
              gradeSelected = false;
              semestersOptions.clear();
              semesterValue = null;
              semesterName = null;
              semesterSelected = false;
              staffclassOptions.clear();
              staffclassValue = null;
              staffclassName = null;
              staffclassSelected = false;
              subjectOptions.clear();
              subjectValue = null;
              subjectName = null;
              subjectSelected = false;
              syncAcademicYearOptions();
            });
          },
          items: sectionsOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );
    final academicYear = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
        isExpanded: true,
        value: academicYearValue,
        hint: Text("Select Academic Year"),
        style: TextStyle(color: AppTheme.appColor),
        underline: Container(
          height: 2,
          color: AppTheme.appColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            academicYearSelected = true;
            academicYearValue = newValue!;
            stageOptions.clear();
            stageValue = null;
            stageName = null;
            stageSelected = false;
            gradeOptions.clear();
            gradeValue = null;
            gradeName = null;
            gradeSelected = false;
            semestersOptions.clear();
            semesterValue = null;
            semesterName = null;
            semesterSelected = false;
            staffclassOptions.clear();
            staffclassValue = null;
            staffclassName = null;
            staffclassSelected = false;
            subjectOptions.clear();
            subjectValue = null;
            subjectName = null;
            subjectSelected = false;
            syncStageOptions();
          });
        },
        items:
            academicYearsOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
    final stage = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: stageValue,
          hint: Text("Select Stage"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              stageSelected = true;
              stageValue = newValue!;
              stageName = stageOptions[newValue];
              gradeOptions.clear();
              gradeValue = null;
              gradeName = null;
              gradeSelected = false;
              semestersOptions.clear();
              semesterValue = null;
              semesterName = null;
              semesterSelected = false;
              staffclassOptions.clear();
              staffclassValue = null;
              staffclassName = null;
              staffclassSelected = false;
              subjectOptions.clear();
              subjectValue = null;
              subjectName = null;
              subjectSelected = false;
              syncGradeOptions();
            });
          },
          items: stageOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );
    final grade = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: gradeValue,
          hint: Text("Select Grade"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              gradeSelected = true;
              gradeValue = newValue!;
              gradeName = gradeOptions[newValue];
              semestersOptions.clear();
              semesterValue = null;
              semesterName = null;
              semesterSelected = false;
              staffclassOptions.clear();
              staffclassValue = null;
              staffclassName = null;
              staffclassSelected = false;
              subjectOptions.clear();
              subjectValue = null;
              subjectName = null;
              subjectSelected = false;
              syncSemesterOptions();
            });
          },
          items: gradeOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );
    final semester = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: semesterValue,
          hint: Text("Select Semester"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              semesterSelected = true;
              semesterValue = newValue!;
              semesterName = semestersOptions[newValue];
              staffclassOptions.clear();
              staffclassValue = null;
              staffclassName = null;
              staffclassSelected = false;
              subjectOptions.clear();
              subjectValue = null;
              subjectName = null;
              subjectSelected = false;
              syncClassOptions();
            });
          },
          items: semestersOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );
    final staffclass = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: staffclassValue,
          hint: Text("Select Class"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              staffclassSelected = true;
              staffclassValue = newValue!;
              staffclassName = staffclassOptions[newValue];
              subjectOptions.clear();
              subjectValue = null;
              subjectName = null;
              subjectSelected = false;
              syncSubjectOptions();
            });
          },
          items: staffclassOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );
    final subject = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: subjectValue,
          hint: Text("Select Subject"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              subjectSelected = true;
              subjectValue = newValue!;
              subjectName = subjectOptions[newValue];
            });
          },
          items: subjectOptions
              .map((key, value) {
                return MapEntry(
                    value,
                    DropdownMenuItem<String>(
                      value: key,
                      child: Text(value),
                    ));
              })
              .values
              .toList()),
    );
    final goButton = Padding(
      padding: EdgeInsets.symmetric(
          vertical: 30.0, horizontal: MediaQuery.of(context).size.width * .25),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          goHomePage();
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('GO', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Center(
      widthFactor: 2,
      child: Container(
        width: MediaQuery.of(context).size.width * .75,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: section,
            ),
            sectionSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: academicYear,
                  )
                : Container(),
            academicYearSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: stage,
                  )
                : Container(),
            stageSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: grade,
                  )
                : Container(),
            gradeSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: semester,
                  )
                : Container(),
            semesterSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: staffclass,
                  )
                : Container(),
            staffclassSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: subject,
                  )
                : Container(),
            subjectSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .4,
                    child: goButton,
                  )
                : Container(),
          ],
        ),
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
              backgroundColor: Colors.transparent,
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

  Future<void> goHomePage() async {
    loggedStaff!.section = sectionValue!;
    loggedStaff!.sectionName = sectionName!;
    loggedStaff!.academicYear = academicYearValue!;
    loggedStaff!.stage = stageValue!;
    loggedStaff!.stageName = stageName!;
    loggedStaff!.grade = gradeValue!;
    loggedStaff!.gradeName = gradeName!;
    loggedStaff!.semester = semesterValue!;
    loggedStaff!.semesterName = semesterName!;
    loggedStaff!.staffClass = staffclassValue!;
    loggedStaff!.staffClassName = staffclassName!;
    loggedStaff!.subject = subjectValue!;
    loggedStaff!.subjectName = subjectName!;
    await setUserData(loggedStaff!);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
              type: loggedStaff!.type!,
              sectionid: loggedStaff!.section!,
              Id: loggedStaff!.id!,
              Academicyear: loggedStaff!.academicYear!)),
    );
  }
}

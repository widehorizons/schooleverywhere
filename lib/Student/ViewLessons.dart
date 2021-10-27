import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/DownloadList.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
import 'LessonsContentPage.dart';

class ViewLessons extends StatefulWidget {
  final String type;
  const ViewLessons(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _ViewLessonsState();
  }
}

class _ViewLessonsState extends State<ViewLessons> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map datesOptions = new Map();
  Map subjectOption = new Map();
  Map divisions = new Map();
  Map teacherOption = new Map();
  String? subjectValue;
  String? teacherValue;
  bool subjectSelected = false;
  bool teacherSelected = false;
  List<dynamic> dataShowContent = [];
  String? dateValue,
      userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      userSemester,
      childern;
  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userSection = loggedParent!.childeSectionSelected;
      userAcademicYear = loggedParent!.academicYear;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      userClass = loggedParent!.classChild;
      userSemester = loggedParent!.semester;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childern = loggedParent!.regno;
    } else {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userSemester = loggedStudent!.semester;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childern = loggedStudent!.id;
    }
    syncReceiveFromTeacherSubject();
  }

  Future<void> syncReceiveFromTeacherSubject() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getSubjectReceiveFromTeacher(
        userSection!, userAcademicYear!, userStage!, userGrade!, userSemester!);
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> y = data!['subjectId'];
      Map subjectArr = new Map();
      subjectArr['All'] = 'All';
      for (int i = 0; i < y.length; i++) {
        subjectArr[data['subjectId'][i]] = data['subjectName'][i];
      }
      setState(() {
        subjectOption = subjectArr;
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

  Future<void> syncReceiveFromTeacherTeacher() async {
    EventObject objectEventr = new EventObject();
    if (widget.type == PARENT_TYPE) {
      objectEventr = await getReceiveFromTeacherTeacher(
          loggedParent!.childeSectionSelected,
          loggedParent!.academicYear,
          loggedParent!.stage,
          loggedParent!.grade,
          loggedParent!.semester,
          subjectValue!,
          loggedParent!.classChild);
    } else {
      objectEventr = await getReceiveFromTeacherTeacher(
          loggedStudent!.section!,
          loggedStudent!.academicYear!,
          loggedStudent!.stage!,
          loggedStudent!.grade!,
          loggedStudent!.semester!,
          subjectValue!,
          loggedStudent!.studentClass!);
    }
    if (objectEventr.success!) {
      Map? data = objectEventr.object as Map?;
      List<dynamic> y = data!['staffId'];
      Map TeacherArr = new Map();
      TeacherArr['All'] = 'All';
      for (int i = 0; i < y.length; i++) {
        TeacherArr[data['staffId'][i]] = data['satffName'][i];
      }
      setState(() {
        teacherOption = TeacherArr;
      });
    } else {
      String? msg = objectEventr.object as String?;
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

  Future<void> syncViewLessons() async {
    EventObject objectEventSt = await viewLessons(
        userSection!,
        userAcademicYear!,
        userStage!,
        userGrade!,
        userSemester!,
        subjectValue!,
        teacherValue!,
        userClass!);
    if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      List<dynamic> listOfColumns = dataShowContentData!['data'];
      setState(() {
        dataShowContent = listOfColumns;
      });
    } else {
      String? msg = objectEventSt.object as String?;
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
    final subjectUi = Padding(
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
              teacherValue;
              teacherSelected = false;
              teacherOption.clear();
              syncReceiveFromTeacherTeacher();
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
              .toList()),
    );

    final teacherUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: teacherValue,
          hint: Text("Select Teacher"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              teacherSelected = true;
              teacherValue = newValue!;
              syncViewLessons();
            });
          },
          items: teacherOption
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

    final showData = Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(
                      "Subject",
                      style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                    )),
                    DataColumn(
                        label: Text(
                      "Date",
                      style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                    )),
                    DataColumn(
                        label: Text(
                      "title",
                      style: TextStyle(color: AppTheme.appColor, fontSize: 16),
                    )),
                  ],
                  rows:
                      dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(
                                      element["Subject"] ?? "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    )),
                                    DataCell(Text(
                                      element["filedate"] ?? "",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    )),
                                    DataCell(
                                        Text(
                                          element["title"] ?? "",
                                          style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontSize: 14),
                                        ), onTap: () {
                                      print(
                                          " ${element["id"]},${element["tableName"]},${userType!},${userId!},${userSection!},${userAcademicYear!}");
                                      Navigator.push(
                                          context,
                                          new MaterialPageRoute(
                                              builder: (context) =>
                                                  LessonsContentPage(
                                                      element["id"],
                                                      element["tableName"],
                                                      userType!,
                                                      userId!,
                                                      userSection!,
                                                      userAcademicYear!)));
                                    }),
                                  ],
                                )),
                          )
                          .toList(),
                ))));

    final body = Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: subjectUi,
          ),
          subjectSelected
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: teacherUi,
                )
              : Container(),
          teacherSelected
              ? new Expanded(
                  child: ListView(
                  children: <Widget>[
                    showData,
                  ],
                ))
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
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: userType!,
                        sectionid: userSection!,
                        Id: childern!,
                        Academicyear: userAcademicYear!)));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage('img/logo.png'),
              ),
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
        child: body,
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
}

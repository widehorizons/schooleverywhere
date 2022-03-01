import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class TakeAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _TakeAttendanceState();
  }
}

class _TakeAttendanceState extends State<TakeAttendance> {
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
  final format = DateFormat("yyyy-MM-dd");
  List Student = [];
  List? StudentSelectedPresent;
  List? StudentSelectedOD;
  List? StudentSelectedAbsent;
  List? StudentSelectedMedical;
  List? StudentSelectedLate;
  List? StudentSelectedExcuse;
  List? StudentSelected;

  TextEditingController Date = new TextEditingController();
  // bool datasend = false;

  initState() {
    super.initState();
    getLoggedStaff();
    StudentSelectedPresent = [];
    StudentSelectedOD = [];
    StudentSelectedAbsent = [];
    StudentSelectedMedical = [];
    StudentSelectedLate = [];
    StudentSelectedExcuse = [];
    StudentSelected = [];
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

    setState(() {
      syncGetStudentId();
    });
  }

  Future<void> syncGetStudentId() async {
    EventObject eventObject = await getStudentId(StaffSectionId, StaffStageId,
        StaffGradeId, StaffClassId, loggedStaff!.academicYear!);
    if (eventObject.success!) {
      Map? getStudentValues = eventObject.object as Map?;
      List<dynamic> listOfColumns = getStudentValues!['data'];
      setState(() {
        Student = listOfColumns;
      });
    } else {
      String? msg = eventObject.object as String?;
      /*    Flushbar(
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

  Future<void> addAttandence() async {
    EventObject objectEventTopics;
    if (Date.text != "") {
      objectEventTopics = await addAttendance(
          loggedStaff!.id!,
          loggedStaff!.section!,
          loggedStaff!.academicYear!,
          loggedStaff!.stage!,
          loggedStaff!.grade!,
          loggedStaff!.staffClass!,
          loggedStaff!.subject!,
          StudentSelectedPresent!,
          StudentSelectedExcuse!,
          StudentSelectedLate!,
          StudentSelectedMedical!,
          StudentSelectedAbsent!,
          StudentSelectedOD!,
          Date.text,
          loggedStaff!.semester!);

      setState(() {
        // Navigator.of(context).pop();
        if (objectEventTopics.success!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TakeAttendance()),
          );
          /*   Flushbar(
          title: "Success",
          message: "Added",
          icon: Icon(Icons.done_outline),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 2),
        )
          ..show(context);*/
          Fluttertoast.showToast(
              msg: "Added",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          String? msg = objectEventTopics.object as String?;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TakeAttendance()),
          );
          /*  Flushbar(
          title: "Failed",
          message: "Something Wrong",
          icon: Icon(Icons.close),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 3),
        )
          ..show(context);*/
          Fluttertoast.showToast(
              msg: "Something Wrong",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } else {
      /*  Flushbar(
        title: "Failed",
        message: "Please Select Date",
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: "Please Select Date",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final selectedPrecent = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("Present"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          initialValue: StudentSelectedPresent,
          onSaved: (value) {
            setState(() {
              StudentSelectedPresent = value;
              StudentSelectedPresent!.forEach((element) {
                if (StudentSelectedOD!.contains(element) ||
                    StudentSelectedAbsent!.contains(element) ||
                    StudentSelectedExcuse!.contains(element) ||
                    StudentSelectedLate!.contains(element) ||
                    StudentSelectedMedical!.contains(element)) {
                  Fluttertoast.showToast(
                      msg: "Duplicated status to same student",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      backgroundColor: AppTheme.appColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  StudentSelectedPresent!.remove(element);
                }
              });
            });
          }),
    );
    final selectedOD = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("OD"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          initialValue: StudentSelectedOD,
          onSaved: (value) {
            setState(() {
              StudentSelectedOD = value;
              StudentSelectedOD!.forEach((element) {
                if (StudentSelectedPresent!.contains(element) ||
                    StudentSelectedAbsent!.contains(element) ||
                    StudentSelectedExcuse!.contains(element) ||
                    StudentSelectedLate!.contains(element) ||
                    StudentSelectedMedical!.contains(element)) {
                  Fluttertoast.showToast(
                      msg: "Duplicated status to same student",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      backgroundColor: AppTheme.appColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  StudentSelectedOD!.remove(element);
                }
              });
            });
          }),
    );
    final selectedAbsent = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("Absent"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          initialValue: StudentSelectedAbsent,
          onSaved: (value) {
            setState(() {
              StudentSelectedAbsent = value;
              StudentSelectedAbsent!.forEach((element) {
                if (StudentSelectedPresent!.contains(element) ||
                    StudentSelectedOD!.contains(element) ||
                    StudentSelectedExcuse!.contains(element) ||
                    StudentSelectedLate!.contains(element) ||
                    StudentSelectedMedical!.contains(element)) {
                  Fluttertoast.showToast(
                      msg: "Duplicated status to same student",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      backgroundColor: AppTheme.appColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  StudentSelectedAbsent!.remove(element);
                }
              });
            });
          }),
    );
    final selectedMedical = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("Medical"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          initialValue: StudentSelectedMedical,
          onSaved: (value) {
            setState(() {
              StudentSelectedMedical = value;
              StudentSelectedMedical!.forEach((element) {
                if (StudentSelectedPresent!.contains(element) ||
                    StudentSelectedOD!.contains(element) ||
                    StudentSelectedAbsent!.contains(element) ||
                    StudentSelectedLate!.contains(element) ||
                    StudentSelectedExcuse!.contains(element)) {
                  Fluttertoast.showToast(
                      msg: "Duplicated status to same student",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      backgroundColor: AppTheme.appColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  StudentSelectedMedical!.remove(element);
                }
              });
            });
          }),
    );
    final selectedLate = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("Late"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          initialValue: StudentSelectedLate,
          onSaved: (value) {
            setState(() {
              StudentSelectedLate = value;
              StudentSelectedLate!.forEach((element) {
                if (StudentSelectedPresent!.contains(element) ||
                    StudentSelectedOD!.contains(element) ||
                    StudentSelectedAbsent!.contains(element) ||
                    StudentSelectedMedical!.contains(element) ||
                    StudentSelectedExcuse!.contains(element)) {
                  Fluttertoast.showToast(
                      msg: "Duplicated status to same student",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      backgroundColor: AppTheme.appColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  StudentSelectedLate!.remove(element);
                }
              });
            });
          }),
    );
    final selectedExcuse = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("Excuse"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          initialValue: StudentSelectedExcuse,
          onSaved: (value) {
            setState(() {
              StudentSelectedExcuse = value;
              StudentSelectedExcuse!.forEach((element) {
                if (StudentSelectedPresent!.contains(element) ||
                    StudentSelectedOD!.contains(element) ||
                    StudentSelectedAbsent!.contains(element) ||
                    StudentSelectedMedical!.contains(element) ||
                    StudentSelectedLate!.contains(element)) {
                  Fluttertoast.showToast(
                      msg: "Duplicated status to same student",
                      toastLength: Toast.LENGTH_LONG,
                      timeInSecForIosWeb: 3,
                      backgroundColor: AppTheme.appColor,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  StudentSelectedExcuse!.remove(element);
                }
              });
            });
          }),
    );

    final loadingSign = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SpinKitPouringHourGlass(
        color: AppTheme.appColor,
      ),
    );

    final data = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text('Date',
              style: TextStyle(
                  color: AppTheme.appColor,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                  fontSize: 18)),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 70),
              child: Container(
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.height * .05,
                  child: DateTimeField(
                    format: format,
                    controller: Date,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.appColor)),
                    ),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1996),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(2050));
                    },
                  ))),
          selectedPrecent,
          selectedOD,
          selectedAbsent,
          selectedMedical,
          selectedLate,
          selectedExcuse,
          RaisedButton(
            color: AppTheme.appColor,
            child: Text("ADD", style: TextStyle(color: Colors.white)),
            onPressed: () {
              addAttandence();
            },
          )
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
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: loggedStaff!.type!,
                        sectionid: loggedStaff!.section!,
                        Id: "",
                        Academicyear: "")));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    AssetImage('${FlavorConfig.instance.values.imagePath!}'),
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

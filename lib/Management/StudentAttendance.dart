import 'dart:io';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../Modules/Management.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';

class StudentAttendance extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StudentAttendanceState();
  }
}

class StudentAttendanceState extends State<StudentAttendance> {
  Management? loggedManagement;

  bool stageSelected = false, gradeSelected = false, classSelected = false;
  TextEditingController messageValue = new TextEditingController();
  TextEditingController subjectValue = new TextEditingController();
  FileType? _pickingType;
  File? filepath;
  bool isLoading = false;
  List<File> selectedFilesList = [];
  List<File> tempSelectedFilesList = [];
  List newFileName = [];
  String? _extension,
      userSection,
      userSectionName = "",
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass;
  bool loadingPath = false;
  bool _hasValidMime = false;
  bool dataSend = false;
  List? teacherSelected, studentSelected, parentSelected;
  bool filesize = true;
  bool isLoadingSearch = false;
  bool isLoadingSearchResult = false;
  Map sectionsOptions = new Map();
  Map stageOptions = new Map();
  Map gradeOptions = new Map();
  Map classOptions = new Map();
  String? stageValue, stageName, gradeValue, gradeName, classValue, className;
  final format = DateFormat("yyyy-MM-dd");
  List Student = [];
  List? StudentSelectedPresent;
  List? StudentSelectedOD;
  List? StudentSelectedAbsent;
  List? StudentSelectedMedical;
  List? StudentSelectedLate;
  List? StudentSelectedExcuse;

  TextEditingController Date = new TextEditingController();

  final uploader = FlutterUploader();
  initState() {
    super.initState();
    getLoggedInUser();
    StudentSelectedPresent = [];
    StudentSelectedOD = [];
    StudentSelectedAbsent = [];
    StudentSelectedMedical = [];
    StudentSelectedLate = [];
    StudentSelectedExcuse = [];
  }

  Future<void> getLoggedInUser() async {
    loggedManagement = await getUserData() as Management;
    userAcademicYear = loggedManagement!.academicYear;
    userSection = loggedManagement!.section;
    userSectionName = loggedManagement!.sectionName;
    userId = loggedManagement!.id!;
    userType = loggedManagement!.type!;

    syncStageOptions();
  }

  Future<void> syncStageOptions() async {
    print("section" + userSection!);
    print("id" + userId!);
    EventObject objectEventStage =
        await stageManagmentOptions(userSection!, userAcademicYear!, userId!);
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
      /*Flushbar(
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
    EventObject objectEventGarde = await gradeManagementOptions(
        userSection!, stageValue!, userAcademicYear!, userId!);
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
      /*Flushbar(
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
    EventObject objectEventClass = await classManagenemtOptions(
        userSection!, stageValue!, gradeValue!, userAcademicYear!, userId!);
    if (objectEventClass.success!) {
      Map? data = objectEventClass.object as Map?;
      List<dynamic> m = data!['classId'];
      Map Classarr = new Map();
      for (int i = 0; i < m.length; i++) {
        Classarr[data['classId'][i]] = data['classsName'][i];
      }
      setState(() {
        classOptions = Classarr;
        print("class map:" + Classarr.toString());
      });
    } else {
      String? msg = objectEventClass.object as String?;
      /*Flushbar(
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

  Future<void> syncGetStudentId() async {
    EventObject eventObject = await getStudentId(
        userSection!, stageValue!, gradeValue!, classValue!, userAcademicYear!);
    if (eventObject.success!) {
      Map? getStudentValues = eventObject.object as Map?;
      List<dynamic> listOfColumns = getStudentValues!['data'];
      setState(() {
        Student = listOfColumns;
      });
      isLoadingSearch = true;
      isLoadingSearchResult = true;
    } else {
      isLoadingSearch = false;
      String? msg = eventObject.object as String?;
      /*Flushbar(
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

              classOptions.clear();
              classValue = null;
              className = null;
              classSelected = false;
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
              classOptions.clear();
              classValue = null;
              className = null;
              classSelected = false;

              syncClassOptions();
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
    final managementclass = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: classValue,
          hint: Text("Select Class"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              classSelected = true;
              classValue = newValue!;
              className = classOptions[newValue];
            });
          },
          items: classOptions
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

    final selectedPrecent = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          // autovalidate: false,
          title: Text("Present"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          required: true,
          initialValue: StudentSelectedPresent,
          onSaved: (value) {
            setState(() {
              StudentSelectedPresent = value;
            });
          }),
    );
    final selectedOD = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          // autovalidate: false,
          title: Text("OD"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          required: true,
          initialValue: StudentSelectedOD,
          onSaved: (value) {
            setState(() {
              StudentSelectedOD = value;
            });
          }),
    );
    final selectedAbsent = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          // autovalidate: false,
          title: Text("Absent"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          required: true,
          initialValue: StudentSelectedAbsent,
          onSaved: (value) {
            setState(() {
              StudentSelectedAbsent = value;
            });
          }),
    );
    final selectedMedical = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          // autovalidate: false,
          title: Text("Medical"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          required: true,
          initialValue: StudentSelectedMedical,
          onSaved: (value) {
            setState(() {
              StudentSelectedMedical = value;
            });
          }),
    );
    final selectedLate = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          // autovalidate: false,
          title: Text("Late"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          required: true,
          initialValue: StudentSelectedLate,
          onSaved: (value) {
            setState(() {
              StudentSelectedLate = value;
            });
          }),
    );
    final selectedExcuse = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          // autovalidate: false,
          title: Text("Excuse"),
          validator: (value) {
            if (value == null) return 'Please select one or more option(s)';
          },
          errorText: 'Please select one or more option(s)',
          dataSource: Student,
          textField: 'display',
          valueField: 'value',
          required: true,
          initialValue: StudentSelectedExcuse,
          onSaved: (value) {
            setState(() {
              StudentSelectedExcuse = value;
            });
          }),
    );

    final loadingSign = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SpinKitPouringHourGlass(
        color: AppTheme.appColor,
      ),
    );

    Future<void> addManagementAttendence() async {
      isLoading = true;
      EventObject objectEventTopics;
      if (Date.text != "") {
        objectEventTopics = await addManagementAttendance(
            loggedManagement!.id!,
            loggedManagement!.section!,
            loggedManagement!.academicYear!,
            stageValue!,
            gradeValue!,
            classValue!,
            StudentSelectedPresent!,
            StudentSelectedExcuse!,
            StudentSelectedLate!,
            StudentSelectedMedical!,
            StudentSelectedAbsent!,
            StudentSelectedOD!,
            Date.text);
        setState(() {});
        Navigator.of(context).pop();
        if (objectEventTopics.success!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => StudentAttendance()),
          );
          /*Flushbar(
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
            MaterialPageRoute(builder: (context) => StudentAttendance()),
          );
          /*Flushbar(
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
      } else {
        /*Flushbar(
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
          !isLoading
              ? RaisedButton(
                  color: AppTheme.appColor,
                  child: Text("ADD", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    addManagementAttendence();
                    setState(() {});
                  },
                )
              : loadingSign,
        ],
      ),
    );

    final body = SingleChildScrollView(
        child: Center(
      child: Column(children: <Widget>[
        Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
        ),
        isLoadingSearch
            ? Container()
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: Text(" Section: " + userSectionName!,
                          style: TextStyle(
                              wordSpacing: 10,
                              color: AppTheme.appColor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: stage,
                    ),
                    stageSelected
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * .5,
                            child: grade,
                          )
                        : Container(),
                    gradeSelected
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width * .5,
                            child: managementclass,
                          )
                        : Container(),
                    classSelected
                        ? RaisedButton(
                            color: AppTheme.appColor,
                            child: Text("View",
                                style: TextStyle(color: Colors.white)),
                            onPressed: () {
                              syncGetStudentId();
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
        isLoadingSearchResult
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: data,
              )
            : Container(),
      ]),
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

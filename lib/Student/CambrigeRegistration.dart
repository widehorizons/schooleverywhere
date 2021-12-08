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
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

//TODO: CambrigeRegistration shouldn't response with No data
class CambrigeRegistration extends StatefulWidget {
  final String type;
  const CambrigeRegistration(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _CambrigeRegistrationState();
  }
}

class _CambrigeRegistrationState extends State<CambrigeRegistration> {
  Parent? loggedParent;
  Student? loggedStudent;

  String? userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      userSemester,
      sessionValue,
      userChildren,
      subjectValue,
      subSubjectValue,
      statusValue;

  bool sessionSelected = false;
  bool subjectSelected = false;
  bool subSubjectSelected = false;
  bool stausSelected = false;
  bool isLoading = false;
  Map sessionOption = Map();
  Map subjectOption = Map();
  Map subsubjectOption = Map();
  Map statusOption = Map();
  List rowHeaders = [];
  List rowHeadersid = [];
  List columnHeaders = [];
  Map selected = new Map();

  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  saveHeaders() {
    //Saving All Headers
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
      userChildren = loggedParent!.regno;
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userSemester = loggedStudent!.semester;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      userChildren = loggedStudent!.id;
    }
    getSessionCambridge();
  }

  Future<void> getSessionCambridge() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getSessionCamb(
        userSection!, userAcademicYear!, userStage!, userGrade!, userChildren!);
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> y = data!['sessionId'];
      Map SessionArr = new Map();
      for (int i = 0; i < y.length; i++) {
        SessionArr[data['sessionId'][i]] = data['sessionName'][i];
      }
      setState(() {
        sessionOption = SessionArr;
      });
    } else {
      String? msg = objectEvent.object as String?;
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

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  Future<void> syncGetSubjectForSession() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getSubjectForSession(userSection!, userAcademicYear!,
        userStage!, userGrade!, userChildren!, sessionValue!);
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

  Future<void> syncGetSubSubjectForSession() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getGetSubSubjectForSession(
        userSection!,
        userAcademicYear!,
        userStage!,
        userGrade!,
        userChildren!,
        sessionValue!,
        subjectValue!);
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> y = data!['subsubjectId'];
      Map subSubjectArr = new Map();
      for (int i = 0; i < y.length; i++) {
        subSubjectArr[data['subsubjectId'][i]] = data['subsubjectName'][i];
      }
      setState(() {
        subsubjectOption = subSubjectArr;
      });
    } else {
      String? msg = objectEvent.object as String?;
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

  Future<void> syncGetStatusSubjectForSession() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getStatusSubjectForSession(
        userSection!,
        userAcademicYear!,
        userStage!,
        userGrade!,
        userChildren!,
        sessionValue!,
        subjectValue!);
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> y = data!['statusId'];
      Map statusArr = new Map();
      for (int i = 0; i < y.length; i++) {
        statusArr[data['statusId'][i]] = data['statusName'][i];
      }
      setState(() {
        statusOption = statusArr;
      });
    } else {
      String? msg = objectEvent.object as String?;
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

  Future<void> synAddRegistration() async {
    setState(() {
      isLoading = true;
    });
    EventObject objectEvent = new EventObject();
    objectEvent = await AddCambrigeRegistration(
        userSection!,
        userAcademicYear!,
        userStage!,
        userGrade!,
        userChildren!,
        sessionValue!,
        subjectValue!,
        subSubjectValue ?? "",
        statusValue!);

    if (objectEvent.success!) {
      /*  Flushbar(
        title: "Added",
        message: "DONE",
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: "DONE",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoading = false;
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: sessionValue,
          hint: Text("Select Session"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              sessionSelected = true;
              sessionValue = newValue!;
              syncGetSubjectForSession();
            });
          },
          items: sessionOption
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
              syncGetSubSubjectForSession();
              syncGetStatusSubjectForSession();
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
    final subsubject = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: subSubjectValue,
          hint: Text("Select Subsubject"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              subSubjectSelected = true;
              subSubjectValue = newValue ?? null;
            });
          },
          items: subsubjectOption
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
    final status = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: statusValue,
          hint: Text("Select Status"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              stausSelected = true;
              statusValue = newValue!;
            });
          },
          items: statusOption
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
    final loadingSign = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SpinKitPouringHourGlass(
        color: AppTheme.appColor,
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          synAddRegistration();
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('ADD', style: TextStyle(color: Colors.white)),
      ),
    );
    final body = Column(children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        child: session,
      ),
      sessionSelected
          ? SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: subject,
            )
          : Container(),
      subjectSelected
          ? SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: subsubject,
            )
          : Container(),
      subjectSelected
          ? SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: status,
            )
          : Container(),
      stausSelected
          ? SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: !isLoading ? loginButton : loadingSign,
            )
          : Container(),
    ]);

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
                        type: userType!,
                        sectionid: userSection!,
                        Id: userChildren!,
                        Academicyear: userAcademicYear!)));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('FlavorConfig.instance.values.imagePath!'),
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

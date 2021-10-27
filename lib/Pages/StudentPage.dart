import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../Style/theme.dart';

import '../SharedPreferences/Prefs.dart';
import 'HomePage.dart';
import 'LoginPage.dart';
import '../Student/MailInboxPage.dart';

class StudentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _StudentPageState();
  }
}

class _StudentPageState extends State<StudentPage> {
  String? academicYearValue, semesterValue;
  Map semestersOptions = new Map();
  bool academicYearSelected = false;
  bool semesterSelected = false;
  List<String> academicYearsOptions = [];
  Student? loggedStudent;
  bool isGoing = false;

  @override
  void initState() {
    super.initState();
    getLoggedStudent();
  }

  Future<void> getLoggedStudent() async {
    loggedStudent = await getUserData() as Student;
    if (loggedStudent!.academicYear != null &&
        loggedStudent!.semester != null) {
      academicYearValue = loggedStudent!.academicYear;
      semesterValue = loggedStudent!.semester;
      academicYearSelected = true;
      semesterSelected = true;
      syncAcadmicYearOptions();
      syncSemesterOptions();
    } else
      syncAcadmicYearOptions();
  }

  Future<void> syncAcadmicYearOptions() async {
    EventObject objectEventYear = await academicYearOptionsStudent(
        loggedStudent!.section!, loggedStudent!.id!);
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

  Future<void> syncSemesterOptions() async {
    EventObject objectEventSemester = await semesterOptions(
        loggedStudent!.section!, academicYearValue!, loggedStudent!.id!);
    if (objectEventSemester.success!) {
      Map? data = objectEventSemester.object as Map?;
      List<dynamic> toto = data!['semisterId'];
      Map semesterArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        semesterArr[data['semisterId'][i]] = data['semisterName'][i];
      }
      setState(() {
        semestersOptions = semesterArr;
      });
    } else {
      String? msg = objectEventSemester.object as String?;
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
            semestersOptions.clear();
            semesterValue = null;
            semesterSelected = false;
            syncSemesterOptions();
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
                .toList()));

    final goButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
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
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .15),
            child: new Icon(
              Icons.person,
              color: AppTheme.appColor,
              size: MediaQuery.of(context).size.height * .15,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: academicYear,
          ),
          academicYearSelected
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: semester,
                )
              : Container(),
          semesterSelected
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

  Future<void> goHomePage() async {
    setState(() {
      isGoing = true;
    });
    loggedStudent!.academicYear = academicYearValue!;
    loggedStudent!.semester = semesterValue!;
    await setUserData(loggedStudent!);
    print(loggedStudent!.type);
    print(loggedStudent!.academicYear);
    print(loggedStudent!.section);
    print(loggedStudent!.id);

    EventObject objectEventStudentHome =
        await goStudentHome(loggedStudent!.id!, loggedStudent!.academicYear!);
    setState(() {
      isGoing = false;
    });
    if (objectEventStudentHome.success!) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                type: loggedStudent!.type!,
                sectionid: loggedStudent!.section!,
                Academicyear: loggedStudent!.academicYear!,
                Id: loggedStudent!.id!)),
      );
    }
    //   else{
    //     setState(() {
    //       isGoing = false;
    //     });
    //     String? msg = objectEventStudentHome.object as String?;
    // /*    Flushbar(
    //       title: "Failed",
    //       message: msg.toString(),
    //       icon: Icon(Icons.close),
    //       backgroundColor: AppTheme.appColor,
    //       duration: Duration(seconds: 3),
    //     )
    //       ..show(context);*/
    //     Fluttertoast.showToast(
    //         msg: msg.toString(),
    //         toastLength: Toast.LENGTH_LONG,
    //         timeInSecForIosWeb: 3,
    //         backgroundColor: AppTheme.appColor,
    //         textColor: Colors.white,
    //         fontSize: 16.0
    //     );
    //   }
  }
}

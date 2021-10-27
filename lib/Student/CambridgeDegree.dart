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
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
import 'LessonsContentPage.dart';

class CambridgeDegree extends StatefulWidget {
  final String type;
  const CambridgeDegree(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _CambridgeDegreeState();
  }
}

class _CambridgeDegreeState extends State<CambridgeDegree> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map sessionOption = new Map();
  String? sessionValue;
  bool sessionSelected = false;
  List<dynamic> listOfSubjects = [];
  List<dynamic> dataShowContent = [];
  List<dynamic> listOfDegree = [];
  bool isLoading = false;
  String? dateValue,
      userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      userSemester,
      userChildren;
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
      userChildren = loggedParent!.regno;
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
      userChildren = loggedStudent!.id;
    }
    syncCambridgeDegreeSession();
  }

  Future<void> syncCambridgeDegreeSession() async {
    EventObject objectEvent = new EventObject();
    if (widget.type == PARENT_TYPE)
      objectEvent = await getSessionCamb(userSection!, userAcademicYear!,
          userStage!, userGrade!, loggedParent!.regno);
    else
      objectEvent = await getSessionCamb(
          userSection!, userAcademicYear!, userStage!, userGrade!, userId!);
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> y = data!['sessionId'];
      Map sessionArr = new Map();
      for (int i = 0; i < y.length; i++) {
        sessionArr[data['sessionId'][i]] = data['sessionName'][i];
      }
      setState(() {
        sessionOption = sessionArr;
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

  Future<void> syncCambridgeDegree() async {
    EventObject objectEventSt;
    if (widget.type == PARENT_TYPE)
      objectEventSt = await viewCambridgeDegree(
          userSection!, userAcademicYear!, loggedParent!.regno, sessionValue!);
    else
      objectEventSt = await viewCambridgeDegree(
          userSection!, userAcademicYear!, userId!, sessionValue!);
    if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      List<dynamic> listOfColumns = dataShowContentData!['subjects'];
      List<dynamic> listOfData = dataShowContentData['data'];
      List<dynamic> listOfDataDegree = dataShowContentData['degree'];
      setState(() {
        listOfSubjects = listOfColumns;
        listOfDegree = listOfDataDegree;
        dataShowContent = listOfData;
        isLoading = true;
      });
    } else {
      String? msg = objectEventSt.object as String?;
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
    final sessionUi = Padding(
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
              syncCambridgeDegree();
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

    final showData = !isLoading
        ? loadingSign
        : Center(
            child: DataTable(
            columns: [
              DataColumn(
                  label: Text("Name",
                      style: TextStyle(
                          color: AppTheme.appColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              for (var i in listOfSubjects)
                DataColumn(
                    label: Text(i.toString(),
                        style: TextStyle(
                            color: AppTheme.appColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16))),
            ],
            rows:
                dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(element,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                              for (var degree
                                  in listOfDegree) //Extracting from Map element the value
                                DataCell(Text(degree,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16))),
                            ],
                          )),
                    )
                    .toList(),
          ));

    final body = Center(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .1),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: sessionUi,
            ),
          ),
          sessionSelected
              ? SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: showData,
                  ),
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

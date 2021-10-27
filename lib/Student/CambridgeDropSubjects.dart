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

class CambridgeDropSubjects extends StatefulWidget {
  final String type;
  const CambridgeDropSubjects(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _CambridgeDropSubjectsState();
  }
}

class _CambridgeDropSubjectsState extends State<CambridgeDropSubjects> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map sessionOption = new Map();
  String? sessionValue;
  bool sessionSelected = false;
  List<dynamic> listOfSubjects = [];
  Map subjectId = new Map();
  Map listOfPaid = new Map();
  Map viewCheckBox = new Map();
  Map checkBoxChecked = new Map();
  bool isLoading = false;
  bool? viewBtnChecked;
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
  List<dynamic> subjectSelected = [];
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

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  Future<void> syncDropSubjects() async {
    EventObject objectEventSt;
    if (widget.type == PARENT_TYPE)
      objectEventSt = await viewDropSubjects(
          userSection!, userAcademicYear!, loggedParent!.regno, sessionValue!);
    else
      objectEventSt = await viewDropSubjects(
          userSection!, userAcademicYear!, userId!, sessionValue!);
    if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      List<dynamic> listOfColumns = dataShowContentData!['subjects'];
      Map listOfSubjectId = dataShowContentData['subjectId'];
      Map listOfDataPaid = dataShowContentData['paid'];
      Map mapCheckBox = dataShowContentData['viewcheckbox'];
      Map checkChecked = dataShowContentData['checkCheckBox'];
      bool viewBtn = dataShowContentData['viewBtn'];
      setState(() {
        listOfSubjects = listOfColumns;
        subjectId = listOfSubjectId;
        listOfPaid = listOfDataPaid;
        viewCheckBox = mapCheckBox;
        checkBoxChecked = checkChecked;
        viewBtnChecked = viewBtn;
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

  Future<void> syncAddDropSubjects() async {
    EventObject objectEventDrop = new EventObject();
    if (widget.type == PARENT_TYPE)
      objectEventDrop = await addDropSubjects(userSection!, userAcademicYear!,
          loggedParent!.regno, sessionValue!, subjectSelected);
    else
      objectEventDrop = await addDropSubjects(userSection!, userAcademicYear!,
          userId!, sessionValue!, subjectSelected);
    setState(() {
      if (objectEventDrop.success!) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CambridgeDropSubjects(userType!)),
        );
        /*   Flushbar(
          title: "Success",
          message: "Please Note That drop action may require additional information and extra fees School register will sufact you if required Thank you",
          icon: Icon(Icons.done_outline),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 2),
        )..show(context);*/
        Fluttertoast.showToast(
            msg:
                "Please Note That drop action may require additional information and extra fees School register will sufact you if required Thank you",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        String? msg = objectEventDrop.object as String?;
        /*   Flushbar(
          title: "Failed",
          message: msg,
          icon: Icon(Icons.close),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 3),
        )..show(context);*/
        Fluttertoast.showToast(
            msg: msg!,
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
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
              syncDropSubjects();
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
                  label: Text("Subject",
                      style: TextStyle(
                          color: AppTheme.appColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              DataColumn(
                  label: Text("Paid",
                      style: TextStyle(
                          color: AppTheme.appColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
              DataColumn(
                  label: Text("Drop Request",
                      style: TextStyle(
                          color: AppTheme.appColor,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 18))),
            ],
            rows:
                listOfSubjects // Loops through dataColumnText, each iteration assigning the value to element
                    .map(
                      ((element) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(element,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                              DataCell(Text(listOfPaid[element],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16))),
                              (viewCheckBox[element] == "Dropped")
                                  ? DataCell(Text(viewCheckBox[element],
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)))
                                  : DataCell(Checkbox(
                                      value: checkBoxChecked[element],
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          checkBoxChecked[element] = newValue;
                                          if (checkBoxChecked[element])
                                            subjectSelected
                                                .add(subjectId[element]);
                                        });
                                      }))
                            ],
                          )),
                    )
                    .toList(),
          ));

    final body = Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: sessionUi,
          ),
          sessionSelected
              ? new Expanded(
                  child: ListView(children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: showData,
                    ),
                  )
                ]))
              : Container(),
          (isLoading && viewBtnChecked!)
              ? RaisedButton(
                  color: AppTheme.appColor,
                  child: Text("ADD", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    syncAddDropSubjects();
                  },
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

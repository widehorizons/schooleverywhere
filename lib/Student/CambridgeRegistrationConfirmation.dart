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

class CambridgeRegistrationConfirmation extends StatefulWidget {
  final String type;
  const CambridgeRegistrationConfirmation(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _CambridgeRegistrationConfirmationState();
  }
}

class _CambridgeRegistrationConfirmationState
    extends State<CambridgeRegistrationConfirmation> {
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
  bool isLoadingBtn = false;
  Map sessionOption = Map();
  Map subjectOption = Map();
  Map ColumnOption = Map();
  Map FeesOption = Map();
  List rowHeaders = [];
  List rowHeadersid = [];
  List columnHeaders = [];
  Map selected = new Map();
  Map confirmationData = new Map();
  List<dynamic> listOfColumns = [];
  List<dynamic> listOfSubjects = [];
  List<dynamic> listOfFees = [];

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

  Future<void> syncGetColumnForSession() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getColumnForSessionConf(userSection!, userAcademicYear!,
        userStage!, userGrade!, userChildren!, sessionValue!);
    if (objectEvent.success!) {
      confirmationData = objectEvent.object as Map;
      List<dynamic> listOfColumn = confirmationData['columname'];
      List<dynamic> subjectData = confirmationData['subjectName'];
      setState(() {
        listOfColumns = listOfColumn;
        listOfSubjects = subjectData;
        isLoading = true;
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

//  Future<void> syncGetColumnFeesForSession() async {
//    EventObject objectEvent = new EventObject();
//    objectEvent = await getColumnFeesSessionConf(userSection,userAcademicYear,userStage,userGrade,userChildren,sessionValue);
//    if (objectEvent.success) {
//      Map data = objectEvent.object;
//      List<dynamic> y = data['feesPrice'];
//      Map FeesArr = new Map();
//      for (int i = 0; i < y.length; i++) {
//        FeesArr[subjectOption[i]] = data['feesPrice'][i].toString();
//      }
//      setState(() {
//        listOfFees = y;
//        FeesOption = FeesArr;
//      });
//    }
//    else
//    {
//      String msg = objectEvent.object;
//      Flushbar(
//        title: "Failed",
//        message: msg.toString(),
//        icon: Icon(Icons.close),
//        backgroundColor: AppTheme.appColor,
//        duration: Duration(seconds: 3),
//      )
//        ..show(context);
//    }
//  }

  Future<void> synConfirmRegistrationConf() async {
    setState(() {
      isLoadingBtn = true;
    });
    EventObject objectEvent = new EventObject();
    objectEvent = await addCambrigeRegistrationConf(
        userSection!, userAcademicYear!, userChildren!, sessionValue!);

    if (objectEvent.success!) {
      /*    Flushbar(
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
              syncGetColumnForSession();
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
        ? Container()
        : Center(
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(
                        label: Text(" Subject",
                            style: TextStyle(
                                color: AppTheme.appColor,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                                fontSize: 18))),
                    for (var i in listOfColumns)
                      DataColumn(
                          label: Text(i.toString(),
                              style: TextStyle(
                                  color: AppTheme.appColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))),
                  ],
                  rows:
                      listOfSubjects // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18))),
                                    for (var names in confirmationData[
                                        element]) //Extracting from Map element the value
                                      DataCell(Text(names.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))),
                                  ],
                                )),
                          )
                          .toList(),
                )));

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          synConfirmRegistrationConf();
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('Confirm', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Column(children: <Widget>[
      SizedBox(
        width: MediaQuery.of(context).size.width * .5,
        child: session,
      ),
      sessionSelected
          ? new Expanded(
              child: ListView(children: <Widget>[
              SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: showData,
                  ))
            ]))
          : Container(),
      sessionSelected
          ? SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: !isLoadingBtn ? loginButton : Container(),
            )
          : Container()
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

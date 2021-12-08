import '../Networking/ApiConstants.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class CambridgeRegisterationID extends StatefulWidget {
  final String type;
  const CambridgeRegisterationID(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _CambridgeRegisterationIDState();
  }
}

class _CambridgeRegisterationIDState extends State<CambridgeRegisterationID> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map sessionOption = new Map();
  String? sessionValue;
  bool sessionSelected = false;
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

  @override
  Widget build(BuildContext context) {
    final sessionUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 80.0),
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

    final goViewButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () async {
          await launch(ApiConstants.CambridgeRegisterationID_API +
              "?myyears=" +
              userAcademicYear! +
              "&regno=" +
              userId! +
              "&sections=" +
              userSection! +
              "&stage=" +
              userStage! +
              "&garde=" +
              userGrade! +
              "&class=" +
              userClass! +
              "&semister=" +
              userSemester! +
              "&sess=" +
              sessionValue!);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('View', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Center(
      child: Column(
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
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .3,
                  child: goViewButton,
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

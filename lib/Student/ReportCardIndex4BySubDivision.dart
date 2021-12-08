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
import '../Networking/ReportCard.dart';
import '../Style/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SharedPreferences/Prefs.dart';
import '../Pages/LoginPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class ReportCardIndex4BySubDivision extends StatefulWidget {
  final String type;
  const ReportCardIndex4BySubDivision(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _ReportCardIndex4BySubDivisionState();
  }
}

class _ReportCardIndex4BySubDivisionState
    extends State<ReportCardIndex4BySubDivision> {
  String? monValue;
  Map monOptions = new Map();
  Student? loggedStudent;
  Parent? loggedParent;

  bool isGoing = false;
  bool monSelected = false;
  String? userAcademicYear,
      userId,
      userType,
      userSection,
      userRegno,
      userSemester,
      userStage,
      userGrade,
      userClass;

  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userSemester = loggedParent!.semester;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      userClass = loggedParent!.classChild;
      userRegno = loggedParent!.regno;
      syncMonthOptions();
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userSemester = loggedStudent!.semester;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userRegno = loggedStudent!.id;
      syncMonthOptions();
    }
  }

  Future<void> syncMonthOptions() async {
    EventObject objectEventDate = await getCard4MonthOptions(
        userSection!,
        userAcademicYear!,
        userSemester!,
        userStage!,
        userGrade!,
        userClass!,
        userRegno!);
    if (objectEventDate.success!) {
      Map? data = objectEventDate.object as Map?;
      List<dynamic> toto = data!['monid'];
      Map monArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        monArr[data['monid'][i]] = data['monname'][i];
      }
      setState(() {
        monOptions = monArr;
      });
    } else {
      String? msg = objectEventDate.object as String?;
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
    final month = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: DropdownButton<String>(
            isExpanded: true,
            value: monValue,
            hint: Text("Select Month"),
            style: TextStyle(color: AppTheme.appColor),
            underline: Container(
              height: 2,
              color: AppTheme.appColor,
            ),
            onChanged: (String? newValue) {
              setState(() {
                monSelected = true;
                monValue = newValue!;
              });
            },
            items: monOptions
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
        onPressed: () async {
          await launch(ReportCard.SCHOOL_REPORT_CARD_FOUR_SUB_DIVISION_LINK +
              "?myyears=" +
              userAcademicYear! +
              "&regno=" +
              userRegno! +
              "&sections=" +
              userSection! +
              "&mydivision=" +
              monValue! +
              "&semister=" +
              userSemester! +
              "&stage=" +
              userStage! +
              "&grade=" +
              userGrade! +
              "&class=" +
              userClass!);
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('GO', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .8,
            child: month,
          ),
          monSelected
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
            Text(FlavorConfig.instance.values.schoolName!),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
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
}

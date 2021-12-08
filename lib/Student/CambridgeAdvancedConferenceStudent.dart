import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Networking/ApiConstants.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Messages.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';

import '../Style/theme.dart';

import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../config/flavor_config.dart';

class CambridgeAdvancedConferenceStudent extends StatefulWidget {
  final String sessionid;
  final String type;

  const CambridgeAdvancedConferenceStudent(this.sessionid, this.type);
  @override
  State<StatefulWidget> createState() {
    return new _CambridgeAdvancedConferenceStudentState();
  }
}

class _CambridgeAdvancedConferenceStudentState
    extends State<CambridgeAdvancedConferenceStudent> {
  Student? loggedStudent;
  Parent? loggedParent;
  int? JoinStaff;
  String? userRegno;
  String? urlConference;
  String? typeUser;
  String? userAcademicYear,
      userId,
      userType,
      userSection,
      childId,
      userstage,
      usergrade,
      userclass,
      usersemester,
      username;
  List<dynamic> listOfMessage = [];
  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getUrlConference() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getUrlConferenceData(userSection!);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['advancedConference'];
      // print( data['advancedConference']);
    }
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userstage = loggedParent!.stage;
      usergrade = loggedParent!.grade;
      childId = loggedParent!.regno;
      userclass = loggedParent!.classChild;
      usersemester = loggedParent!.semester;
      userId = loggedParent!.id;
      username = loggedParent!.name;
      typeUser = "parent";
      _getMessages();
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childId = loggedStudent!.id;
      userstage = loggedStudent!.stage;
      usergrade = loggedStudent!.grade;
      userclass = loggedStudent!.studentClass;
      usersemester = loggedStudent!.semester;
      username = loggedStudent!.name;
      typeUser = "student";
      _getMessages();
    }
    getUrlConference();
  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData =
        await getCambridgeStudentConferenceData(
            childId!, userAcademicYear!, userSection!, widget.sessionid);
    if (objectEventMessageData.success!) {
      Map? messageData = objectEventMessageData.object as Map?;
      List<dynamic> listOfColumns = messageData!['data'];
      setState(() {
        listOfMessage = listOfColumns;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final showData = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              "Teacher",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Subject",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Conference",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Recorde",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
          ],
          rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                element["teacher"],
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                              ),
                            ),
                            DataCell(Text(
                              element["subject"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),
                            DataCell(
                              Text(
                                "Conference",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () async {
                                await launch(ApiConstants.BASE_URL +
                                    "cambrigdeConference/advancedConferenceOneStudent.php?staffid=" +
                                    element["staffid"] +
                                    "&Sessionid=" +
                                    widget.sessionid +
                                    "&subject=" +
                                    element["subjectid"] +
                                    "&sectionid=" +
                                    userSection! +
                                    "&semister=" +
                                    usersemester! +
                                    "&stage=" +
                                    userstage! +
                                    "&grade=" +
                                    usergrade! +
                                    "&class=" +
                                    userclass! +
                                    "&year=" +
                                    userAcademicYear! +
                                    "&regno=" +
                                    childId!);
                              },
                            ),
                            DataCell(
                              Text(
                                "Recorde",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () async {
                                await launch(urlConference! +
                                    "/demo/getrecordingstudent.jsp?meetingID=" +
                                    ApiConstants.ConferenceSchoolName +
                                    "Schooleverywhere" +
                                    element["staffid"] +
                                    element["subjectid"] +
                                    widget.sessionid);
                              },
                            ),
                          ],
                        )),
                  )
                  .toList(),
        ));

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
                        Id: childId!,
                        Academicyear: userAcademicYear!)));
              },
              child: CircleAvatar(
                radius: 20,
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
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: showData,
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

class DetailPage extends StatelessWidget {
  final Messages msg;

  DetailPage(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(msg.messageTitle),
    ));
  }
}

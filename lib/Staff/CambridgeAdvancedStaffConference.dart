import '../Modules/Staff.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Modules/Management.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../config/flavor_config.dart';

class CambridgeAdvancedStaffConference extends StatefulWidget {
  final String sessionid;
  const CambridgeAdvancedStaffConference(this.sessionid);

  @override
  State<StatefulWidget> createState() {
    return new CambridgeAdvancedStaffConferenceState();
  }
}

class CambridgeAdvancedStaffConferenceState
    extends State<CambridgeAdvancedStaffConference> {
  Staff? loggedStaff;
  TextEditingController subjectValue = new TextEditingController();
  String url = ApiConstants.FILE_UPLOAD_MANAGEMENT_BY_SELECT_API;
  String? userSection,
      userAcademicYear,
      userId,
      userType,
      userSemester,
      userStage,
      userGrade,
      userClass;
  List<dynamic> listOfMessage = [];

  String? urlConference, userName;
  int? JoinStaff;

  initState() {
    super.initState();

    getLoggedInUser();
//    getUrlConference();
  }

  /*Future<void> getUrlConference()async{
    EventObject objectEvent = new EventObject();
    objectEvent = await getUrlConferenceData(userSection);
    Map data = objectEvent.object;
    if (objectEvent.success) {
      urlConference = data['advancedConference'];
    }

  }*/
  Future<void> getLoggedInUser() async {
    loggedStaff = await getUserData() as Staff;
    userAcademicYear = loggedStaff!.academicYear;
    userSection = loggedStaff!.section;
    userId = loggedStaff!.id;
    userType = loggedStaff!.type;
    userName = loggedStaff!.name;
    userSemester = loggedStaff!.semester;
    userStage = loggedStaff!.stage;
    userGrade = loggedStaff!.grade;
    userClass = loggedStaff!.staffClass;
    _getMessages();
  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData =
        await getCambridgeAdvancedConferenceStaffStaffData(
            widget.sessionid, userSection!, userAcademicYear!, userId!);
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
              "Subject",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Join",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
            DataColumn(
                label: Text(
              "Record",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
          ],
          rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                              element["subjectname"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),

                            //Extracting from Map element the value
                            DataCell(
                              Text(
                                "Conference",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () async {
                                await launch(ApiConstants.BASE_URL +
                                    "cambrigdeConference/advancedStaffConferenceOne.php?staffid=" +
                                    element["staffid"] +
                                    "&Sessionid=" +
                                    widget.sessionid +
                                    "&subject=" +
                                    element["subjectid"] +
                                    "&sectionid=" +
                                    userSection! +
                                    "&semister=" +
                                    userSemester! +
                                    "&stage=" +
                                    userStage! +
                                    "&grade=" +
                                    userGrade! +
                                    "&class=" +
                                    userClass! +
                                    "&year=" +
                                    userAcademicYear!);
                              },
                            ),
                            DataCell(
                              Text(
                                "Record",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () async {
                                await launch(ApiConstants.BASE_URL +
                                    "cambrigdeConference/recordStaffConferenceOne.php?staffid=" +
                                    element["staffid"] +
                                    "&Sessionid=" +
                                    widget.sessionid +
                                    "&subject=" +
                                    element["subjectid"] +
                                    "&sectionid=" +
                                    userSection!);
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
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  AssetImage('FlavorConfig.instance.values.imagePath!'),
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

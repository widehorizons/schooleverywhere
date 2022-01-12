import 'dart:io';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

import '../Modules/Management.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import 'package:jitsi_meet/jitsi_meet.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'package:path/path.dart' as path;
import 'package:schooleverywhere/config/flavor_config.dart';

class StudentAdvancedConferennceJoin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new StudentAdvancedConferennceJoinState();
  }
}

class StudentAdvancedConferennceJoinState
    extends State<StudentAdvancedConferennceJoin> {
  Management? loggedManagement;

  bool stageSelected = false, gradeSelected = false, classSelected = false;
  TextEditingController messageValue = new TextEditingController();
  TextEditingController subjectValue = new TextEditingController();
  FileType? _pickingType;
  File? filepath;
  String url = ApiConstants.FILE_UPLOAD_MANAGEMENT_BY_SELECT_API;
  bool isLoading = false;
  List<File> selectedFilesList = [];
  List<File> tempSelectedFilesList = [];
  List newFileName = [];
  String? _extension,
      userSection,
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
  List<dynamic> listOfMessage = [];
  Map sectionsOptions = new Map();
  Map stageOptions = new Map();
  Map gradeOptions = new Map();

  String? stageValue, stageName, gradeValue, gradeName, classValue;

  String? urlConference, userName;
  int? JoinStaff;
  final uploader = FlutterUploader();
  initState() {
    super.initState();

    getLoggedInUser();
  }

  Future<void> getUrlConference() async {
    EventObject objectEvent = new EventObject();
    objectEvent = await getUrlConferenceDataByStage(userSection!, stageValue!);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['advancedConference'];
      print(data['conference']);
    }
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    loggedManagement = await getUserData() as Management;
    userAcademicYear = loggedManagement!.academicYear;
    userSection = loggedManagement!.section;
    userId = loggedManagement!.id!;
    userType = loggedManagement!.type!;
    userName = loggedManagement!.name!;
    syncStageOptions();
    getUrlConference();
    if (userName!.length == 0) userName = "Admin";
  }

  Future<void> syncStageOptions() async {
    print("section" + userSection!);
    print("stage" + userSection!);
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

  Future<void> _getMessages() async {
    EventObject objectEventMessageData =
        await getConferenceDataStudentManagement(
            userAcademicYear!, userSection!, stageValue!, gradeValue!);
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
              gradeValue = "";
              gradeName = "";
              gradeSelected = false;
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
              _getMessages();
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

    final showData = ListView(
      children: <Widget>[
        DataTable(
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
              "Recorde",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
          ],
          rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text(
                                element["staffname"],
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () async {
                                await launch(urlConference! +
                                    "/demo/demo_iframeBlank.jsp?username=" +
                                    userName! +
                                    "&meetingname=" +
                                    ApiConstants.ConferenceSchoolName +
                                    "Schooleverywhere" +
                                    element["staffid"] +
                                    element["subjectId"] +
                                    gradeValue! +
                                    "&isModerator=false" +
                                    "&action=create");
                              },
                            ),
                            DataCell(Text(
                              element["subject"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),
                            DataCell(
                              Text(
                                "Recorded",
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () async {
                                await launch(urlConference! +
                                    "/demo/getrecordingstudent.jsp?meetingID=" +
                                    ApiConstants.ConferenceSchoolName +
                                    "Schooleverywhere" +
                                    element["staffid"] +
                                    element["subjectId"] +
                                    gradeValue!);
                              },
                            ),
                            //Extracting from Map element the value
                          ],
                        )),
                  )
                  .toList(),
        )
      ],
    );

    final body = Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
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
          gradeSelected ? new Expanded(child: showData) : Container(),
        ],
      ),
    );

    Widget _buildBody() {
      return body;
    }

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
                  AssetImage('${FlavorConfig.instance.values.imagePath!}'),
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
        child: _buildBody(),
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

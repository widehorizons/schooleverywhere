import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_uploader/flutter_uploader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:schooleverywhere/Modules/Parent.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Management.dart';
import 'package:path/path.dart' as path;
import '../config/flavor_config.dart';

import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/DownloadList.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'package:http/http.dart' as http;
import '../widget/custom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadedTimeTable extends StatefulWidget {
  final String type;
  const UploadedTimeTable({Key? key, required this.type}) : super(key: key);

  @override
  _UploadedTimeTableState createState() => _UploadedTimeTableState();
}

class _UploadedTimeTableState extends State<UploadedTimeTable> {
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
  bool semesterSelected = false;

  List? teacherSelected, studentSelected, parentSelected;
  bool filesize = true;

  Map sectionsOptions = new Map();
  Map stageOptions = new Map();
  Map gradeOptions = new Map();
  Map classOptions = new Map();
  Map semestersOptions = new Map();

  String? stageValue,
      stageName,
      gradeValue,
      gradeName,
      classValue,
      className,
      semesterName,
      semesterValue,
      userSemester,
      childern;

  final uploader = FlutterUploader();

  Staff? loggedStaff;
  Student? loggedStudent;
  Parent? loggedParent;
  List<dynamic> dataShowContent = [];
  String? TeacherValue;

  bool subjectSelected = false;
  bool TeacherSelected = false;
  final CustomDialog _dialog = CustomDialog();

  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == MANAGEMENT_TYPE) {
      loggedManagement = await getUserData() as Management;
      userAcademicYear = loggedManagement!.academicYear;
      userSection = loggedManagement!.section;
      userId = loggedManagement!.id!;
      userType = loggedManagement!.type!;
      userAcademicYear = loggedManagement!.academicYear!;
      syncStageOptions();
    }
    if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userSemester = loggedStudent!.semester;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childern = loggedStudent!.id;
      setState(() {});
    }
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSemester = loggedParent!.semester;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childern = loggedParent!.id;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      childern = loggedParent!.regno;
      userClass = loggedParent!.classChild;
      userSemester = loggedParent!.semester;
      userId = loggedParent!.id;

      setState(() {});
    }
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      setState(() => loadingPath = true);
      try {
        FilePickerResult? result = await FilePicker.platform
            .pickFiles(allowMultiple: true, type: FileType.any);

        if (result != null) {
          tempSelectedFilesList =
              result.paths.map((path) => File(path!)).toList();
        }
        ;
      } on PlatformException catch (e) {
        print("Unsupported operation" + e.toString());
      }
      if (!mounted) return;

      setState(() {
        loadingPath = false;
        if (tempSelectedFilesList.length > 0)
          selectedFilesList = tempSelectedFilesList;
      });
    }
  }

  Future<void> syncSemesterOptions() async {
    EventObject objectEventSemester = await semesterStaffOptions(
        userSection!, userStage!, userGrade!, userAcademicYear!);
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
      /*    Flushbar(
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

  Future<void> syncClassOptions() async {
    EventObject objectEventClass = await classManagenemtOptions(
        userSection!, stageValue!, gradeValue!, userAcademicYear!, userId!);
    if (objectEventClass.success!) {
      Map? data = objectEventClass.object as Map?;
      List<dynamic> m = data!['classId'];
      Map Classarr = new Map();
      for (int i = 0; i < m.length; i++) {
        Classarr[data['classId'][i]] = data['classsName'][i];
      }
      setState(() {
        classOptions = Classarr;
        semesterValue;
        semesterSelected = false;
        print("class map:" + Classarr.toString());
      });
    } else {
      String? msg = objectEventClass.object as String?;
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

  Future<EventObject> getStudentUploadedTable(
      String section, year, stage, grade, classId, semester) async {
    EventObject eventObject = new EventObject();
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    String myUrl = ApiConstants.GET_STUDENT_UPLOADED_TIME_TABLE_API;
    try {
      var response = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json'
      }, body: {
        "section": section,
        "year": year,
        "stage": stage,
        "grade": grade,
        "class": classId,
        "semester": semester
      });
      if (response != null) {
        Map mapValue = json.decode(response.body);
        if (mapValue['success']) {
          eventObject.success = true;
          eventObject.object = mapValue;
          print("Response is ${mapValue['file']}");
          return eventObject;
        } else {
          eventObject.success = false;
          eventObject.object = mapValue['message'];
          return eventObject;
        }
      } else {
        return eventObject;
      }
    } catch (e) {
      return eventObject;
    }
  }

  Future<EventObject> getManagementUploadedTable(
      String section, year, stage, grade, classId, semester) async {
    EventObject eventObject = new EventObject();
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    String myUrl = ApiConstants.GET_MANAGEMENT_UPLOADED_TIME_TABLE_API;
    print(myUrl);
    try {
      var response = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json'
      }, body: {
        "section": section,
        "year": year,
        "stage": stage,
        "grade": grade,
        "class": classId,
        "semester": semester
      });
      print("Response is ${json.decode(response.body)}");
      if (response != null) {
        Map mapValue = json.decode(response.body);
        if (mapValue['success']) {
          eventObject.success = true;
          eventObject.object = mapValue;
          List<dynamic> listOfColumns = mapValue['data'];

          setState(() {
            dataShowContent = listOfColumns;
          });
          return eventObject;
        } else {
          eventObject.success = false;
          eventObject.object = mapValue['message'];
          return eventObject;
        }
      } else {
        return eventObject;
      }
    } catch (e) {
      return eventObject;
    }
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
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
              userStage = newValue;

              stageName = stageOptions[newValue];
              gradeOptions.clear();
              gradeValue;
              gradeName;
              gradeSelected = false;

              classOptions.clear();
              classValue = null;
              className = null;
              classSelected = false;
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
              userGrade = newValue;
              gradeName = gradeOptions[newValue];
              classOptions.clear();
              classValue;
              className;
              classSelected = false;

              syncClassOptions();
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

    final managementclass = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: classValue,
          hint: Text("Select Class"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              classSelected = true;
              classValue = newValue!;
              className = classOptions[newValue];

              syncSemesterOptions();
            });
          },
          items: classOptions
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
                semesterName = semestersOptions[newValue];

                syncSemesterOptions();
                getManagementUploadedTable(userSection!, userAcademicYear!,
                    userStage!, gradeValue!, classValue!, semesterValue!);
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

    final loadingSign = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SpinKitPouringHourGlass(
        color: AppTheme.appColor,
      ),
    );

    final filterBody = SingleChildScrollView(
      child: Center(
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
            gradeSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: managementclass,
                  )
                : Container(),
            classSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: semester,
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
              child: RaisedButton(
                color: AppTheme.appColor,
                textColor: Colors.white,
                onPressed: () => _openFileExplorer(),
                child: new Text("Choose File"),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .7,
              padding: const EdgeInsets.only(bottom: 10.0),
              child: new Scrollbar(
                  child: new ListView.separated(
                shrinkWrap: true,
                itemCount:
                    selectedFilesList.length > 0 && selectedFilesList.isNotEmpty
                        ? selectedFilesList.length
                        : 1,
                itemBuilder: (BuildContext context, int index) {
                  if (selectedFilesList.length > 0) {
                    return new ListTile(
                      title: new Text(
                        path.basename(selectedFilesList[index].path),
                      ),
                    );
                  } else {
                    return Center(child: new Text("No file chosen"));
                  }
                },
                separatorBuilder: (BuildContext context, int index) =>
                    new Divider(),
              )),
            ),
            isLoading
                ? loadingSign
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });

                        if (selectedFilesList.isNotEmpty) {
                          newFileName =
                              await uploadFile(selectedFilesList, url);

                          dataSend = await uploadTimeTable(
                              newFileName,
                              userAcademicYear!,
                              userSection!,
                              stageValue!,
                              gradeValue!,
                              classValue!,
                              semesterValue!);
                          setState(() {
                            isLoading = false;
                          });
                          if (dataSend) {
                            Fluttertoast.showToast(
                                msg: "Message Sent",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                                backgroundColor: AppTheme.appColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            getManagementUploadedTable(
                                userSection!,
                                userAcademicYear!,
                                userStage!,
                                gradeValue!,
                                classValue!,
                                semesterValue!);
                            //  }
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Please Enter Comment or Choose File (max size of file 5 MB)",
                                toastLength: Toast.LENGTH_LONG,
                                timeInSecForIosWeb: 3,
                                backgroundColor: AppTheme.appColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          setState(() {
                            isLoading = false;
                          });

                          Fluttertoast.showToast(
                              msg: "Please Enter Title",
                              toastLength: Toast.LENGTH_LONG,
                              timeInSecForIosWeb: 3,
                              backgroundColor: AppTheme.appColor,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      padding: EdgeInsets.all(12),
                      color: AppTheme.appColor,
                      child:
                          Text('Send', style: TextStyle(color: Colors.white)),
                    ),
                  )
          ],
        ),
      ),
    );

    final showData = Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Stage")),
                    DataColumn(label: Text("Grade")),
                    DataColumn(label: Text("Class")),
                    DataColumn(label: Text("Semester")),
                    DataColumn(label: Text("Attachments")),
                  ],
                  rows:
                      dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element["stage"])),
                                    DataCell(Text(element["grade"])),
                                    DataCell(Text(element["class"])),
                                    DataCell(Text(element["semester"])),
                                    //Extracting from Map element the value
                                    DataCell(
                                        Text(
                                          'show Table',
                                          style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontSize: 14),
                                        ), onTap: () async {
                                      await launch(element['file']['link']);
                                    }),
                                  ],
                                )),
                          )
                          .toList(),
                ))));
    final body = Center(
        child: (widget.type == STUDENT_TYPE && loggedStudent != null)
            ? Center(
                child: FutureBuilder(
                  future: getStudentUploadedTable(
                      loggedStudent!.section ?? "",
                      loggedStudent!.academicYear,
                      loggedStudent!.stage,
                      loggedStudent!.grade,
                      loggedStudent!.studentClass,
                      loggedStudent!.semester),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: SpinKitPouringHourGlass(
                            color: AppTheme.appColor,
                          ),
                        ),
                      );
                    } else {
                      EventObject eventObject = snapshot.data;
                      if (!eventObject.success!) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(eventObject.object.toString()),
                          ),
                        );
                      } else {
                        EventObject eventObject = snapshot.data;
                        Map? mapValue = eventObject.object as Map?;
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          padding: new EdgeInsets.all(
                              MediaQuery.of(context).size.width * 0.01),
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                (mapValue!['file'] != 'not found')
                                    ? DownloadList(
                                        [mapValue['file']],
                                        platform: platform,
                                        title: '',
                                      )
                                    : Container(),
                              ]),
                        );
                      }
                    }
                  },
                ),
              )
            : (widget.type == PARENT_TYPE && loggedParent != null)
                ? Center(
                    child: FutureBuilder(
                      future: getStudentUploadedTable(
                          loggedParent!.childeSectionSelected ?? "",
                          loggedParent!.academicYear,
                          loggedParent!.stage,
                          loggedParent!.grade,
                          loggedParent!.classChild,
                          loggedParent!.semester),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                              child: SpinKitPouringHourGlass(
                                color: AppTheme.appColor,
                              ),
                            ),
                          );
                        } else {
                          EventObject eventObject = snapshot.data;
                          if (!eventObject.success!) {
                            return Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Text(eventObject.object.toString()),
                              ),
                            );
                          } else {
                            EventObject eventObject = snapshot.data;
                            Map? mapValue = eventObject.object as Map?;
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              padding: new EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.01),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    (mapValue!['file'] != 'not found')
                                        ? DownloadList(
                                            [mapValue['file']],
                                            platform: platform,
                                            title: '',
                                          )
                                        : Container(),
                                  ]),
                            );
                          }
                        }
                      },
                    ),
                  )
                : Column(
                    children: <Widget>[
                      if (widget.type == MANAGEMENT_TYPE)
                        Expanded(
                            child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('img/bg.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: filterBody,
                        )),
                      if (dataShowContent.isNotEmpty)
                        Expanded(
                            child: ListView(
                          children: <Widget>[showData],
                        )),
                    ],
                  )
        // : SpinKitPouringHourGlass(
        //     color: AppTheme.appColor,
        //   ),
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
                Navigator.of(context).pop(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: userType!,
                        sectionid: userSection!,
                        Id: childern!,
                        Academicyear: userAcademicYear!)));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    AssetImage('${FlavorConfig.instance.values.imagePath!}'),
              ),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: body,
      // floatingActionButton: (widget.type == MANAGEMENT_TYPE)
      //     ? FloatingActionButton(
      //         onPressed: () => _dialog.buildFullScreenDialog(
      //             context, AddUploadedTimeTable()),
      //         child: Icon(
      //           Icons.add,
      //           size: 20,
      //         ),
      //         backgroundColor: AppTheme.appColor,
      //       )
      //     : SizedBox(),
    );
  }
}

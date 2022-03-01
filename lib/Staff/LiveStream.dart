//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:schooleverywhere/config/flavor_config.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';

class LiveStream extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LiveStreamState();
  }
}

class _LiveStreamState extends State<LiveStream> {
  Staff? loggedStaff;

  String StaffSection = "Loading...";
  String StaffSectionId = "";
  String StaffStage = "Loading...";
  String StaffStageId = "";
  String StaffGrade = "Loading...";
  String StaffGradeId = "";
  String StaffSemester = "Loading...";
  String StaffSemesterId = "";
  String StaffClass = "Loading...";
  String StaffClassId = "";
  String StaffSubject = "Loading...";
  String StaffSubjectId = "";
  String academicYearValue = "Loading...";
  bool isLoading = false, checkSync = true;

  EventObject? datasend;

  TextEditingController titleValue = new TextEditingController();
  TextEditingController descriptionValue = new TextEditingController();
  TextEditingController partValue = new TextEditingController();
  TextEditingController linkValue = new TextEditingController();
  Map staffclassOptions = new Map();
  List? classSelected;
  List<dynamic> classstaff = [];
  String? channel;

  initState() {
    super.initState();
    classSelected = [];
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    StaffSection = loggedStaff!.sectionName!;
    StaffSectionId = loggedStaff!.section!;
    StaffStage = loggedStaff!.stageName!;
    StaffStageId = loggedStaff!.stage!;
    StaffGrade = loggedStaff!.gradeName!;
    StaffGradeId = loggedStaff!.grade!;
    StaffSemester = loggedStaff!.semesterName!;
    StaffSemesterId = loggedStaff!.semester!;
    StaffClass = loggedStaff!.staffClassName!;
    StaffClassId = loggedStaff!.staffClass!;
    StaffSubject = loggedStaff!.subjectName!;
    StaffSubjectId = loggedStaff!.subject!;
    academicYearValue = loggedStaff!.academicYear!;
    syncChannelLink();
    syncClassOptions();
  }

  Future<void> syncChannelLink() async {
    EventObject objectEventClass = await getChannelLink(
        StaffSectionId,
        StaffStageId,
        StaffGradeId,
        academicYearValue,
        loggedStaff!.id!,
        StaffSubjectId);
    if (objectEventClass.success!) {
      Map? data = objectEventClass.object as Map?;
      setState(() {
        channel = data!['data'];
        checkSync = false;
      });
    } else {
      String? msg = objectEventClass.object as String?;
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

  Future<void> syncClassOptions() async {
    EventObject objectEventClass = await getClassStaffData(StaffSectionId,
        StaffStageId, StaffGradeId, academicYearValue, loggedStaff!.id!);
    if (objectEventClass.success!) {
      Map? data = objectEventClass.object as Map?;
      List<dynamic> listOfColumns = data!['data'];
      setState(() {
        classstaff = listOfColumns;
      });
    } else {
      String? msg = objectEventClass.object as String?;
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

  @override
  Widget build(BuildContext context) {
    final selectedClasses = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("Class"),
          validator: (value) {
            if (value == null) return 'Please select one or more class(s)';
          },
          errorText: 'Please select one or more class(s)',
          dataSource: classstaff,
          textField: 'display',
          valueField: 'value',
          required: true,
          initialValue: classSelected,
          onSaved: (value) {
            setState(() {
              classSelected = value;
            });
          }),
    );

    final data = SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height * 1.2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Table(
                        border: TableBorder.all(color: AppTheme.appColor),
                        children: [
                          TableRow(
                              //decoration: ,
                              children: <Widget>[
                                Text(" Section: ",
                                    style: TextStyle(
                                        wordSpacing: 10,
                                        color: AppTheme.appColor,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                                Text(" " + StaffSection,
                                    style: TextStyle(
                                        wordSpacing: 10,
                                        color: AppTheme.appColor,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18)),
                              ]),
                          TableRow(children: <Widget>[
                            Text(" Stage: ",
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text(" " + StaffStage,
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ]),
                          TableRow(children: <Widget>[
                            Text(" Grade: ",
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text(" " + StaffGrade,
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ]),
                          TableRow(children: <Widget>[
                            Text(" Semester: ",
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text(" " + StaffSemester,
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ]),
                          TableRow(children: <Widget>[
                            Text(" Subject: ",
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Text(" " + StaffSubject,
                                style: TextStyle(
                                    wordSpacing: 10,
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ]),
                        ])),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .75,
                  child: selectedClasses,
                ),
                Container(
                  height: MediaQuery.of(context).size.width * .3,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Text(" Channel Link: ",
                          style: TextStyle(
                              wordSpacing: 10,
                              color: AppTheme.appColor,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      checkSync
                          ? Text(" Loading.... ",
                              style: TextStyle(
                                  wordSpacing: 10,
                                  color: Colors.red,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16))
                          : (channel != null)
                              ? FlatButton(
                                  child: Text(
                                    'Click Here',
                                    style: TextStyle(
                                        color: Colors.lightBlue, fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    await launch(channel!);
                                  },
                                )
                              : Text("You Don't Have any Channel Yet",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.red,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                    ],
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.width * .15,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: TextField(
                    controller: titleValue,
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle:
                          TextStyle(color: AppTheme.appColor, fontSize: 16),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppTheme.appColor)),
                    ),
                  ),
                ),
                isLoading
                    ? loadingSign
                    : Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            if (classSelected!.isNotEmpty) {
                              datasend = await addLiveStream(
                                  titleValue.text,
                                  loggedStaff!.id!,
                                  loggedStaff!.academicYear!,
                                  loggedStaff!.section!,
                                  loggedStaff!.stage!,
                                  loggedStaff!.grade!,
                                  classSelected!,
                                  loggedStaff!.subject!);
                              setState(() {
                                isLoading = false;
                              });
                              if (datasend!.success!) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LiveStream()),
                                );
                                /*  Flushbar(
                              title: "Success",
                              message: "Data Sent",
                              icon: Icon(Icons.done_outline),
                              backgroundColor: AppTheme.appColor,
                              duration: Duration(seconds: 3),
                            )..show(context);*/
                                Fluttertoast.showToast(
                                    msg: "Data Sent",
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: AppTheme.appColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                //  }
                              } else {
                                String? msg = datasend!.object as String?;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LiveStream()),
                                );
                                /* Flushbar(
                              title: "Failed",
                              message: msg.toString(),
                              icon: Icon(Icons.close),
                              backgroundColor: AppTheme.appColor,
                              duration: Duration(seconds: 3),
                            )..show(context);*/
                                Fluttertoast.showToast(
                                    msg: msg.toString(),
                                    toastLength: Toast.LENGTH_LONG,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: AppTheme.appColor,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LiveStream()),
                              );
                              /*  Flushbar(
                            title: "Failed",
                            message: "Please Select Class",
                            icon: Icon(Icons.close),
                            backgroundColor: AppTheme.appColor,
                            duration: Duration(seconds: 3),
                          )..show(context);*/
                              Fluttertoast.showToast(
                                  msg: "Please Select Class",
                                  toastLength: Toast.LENGTH_LONG,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: AppTheme.appColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          },
                          padding: EdgeInsets.all(12),
                          color: AppTheme.appColor,
                          child: Text('Send Notification',
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
              ],
            )));

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
                        type: loggedStaff!.type!,
                        sectionid: loggedStaff!.section!,
                        Id: "",
                        Academicyear: "")));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    AssetImage('${FlavorConfig.instance.values.imagePath!}'),
              ),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height * .88,
            ),
            child: Container(
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: data,
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(loggedStaff!.type!, loggedStaff!.id!);
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

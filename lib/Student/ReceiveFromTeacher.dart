import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schooleverywhere/Chat/chat.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
// import 'ShowReceiveFromTeacherContentPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class ReceiveFromTeacher extends StatefulWidget {
  final String type;
  const ReceiveFromTeacher(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _ReceiveFromTeacherState();
  }
}

class _ReceiveFromTeacherState extends State<ReceiveFromTeacher> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map datesOptions = new Map();
  Map subjectOption = new Map();
  Map divisions = new Map();
  Map teacherOption = new Map();
  List<dynamic> dataShowContent = [];
  String? subjectValue;
  String? TeacherValue;
  String? ChildrenId;
  bool subjectSelected = false;
  bool TeacherSelected = false;
  List<Widget> topicsCoveredArr = [];
  List<Widget> previousTopicsCovered = [];
  TextEditingController topicsCoveredController = new TextEditingController();
  String? userId;
  String? userSection;
  String? userAcademicYear;
  initState() {
    super.initState();
    if (widget.type == PARENT_TYPE)
      getLoggedParent();
    else
      getLoggedStudent();
  }

  Future<void> getLoggedParent() async {
    loggedParent = await getUserData() as Parent;
    syncReceiveFromTeacherSubject();
    userId = loggedParent!.id!;
    userSection = loggedParent!.childeSectionSelected;
    userAcademicYear = loggedParent!.academicYear;
    ChildrenId = loggedParent!.regno;
  }

  Future<void> getLoggedStudent() async {
    loggedStudent = await getUserData() as Student;
    syncReceiveFromTeacherSubject();
    userId = loggedStudent!.id!;
    userSection = loggedStudent!.section!;
    userAcademicYear = loggedStudent!.academicYear!;
    ChildrenId = loggedStudent!.id;
  }

  Future<void> syncReceiveFromTeacherSubject() async {
    EventObject objectEvent = new EventObject();
    if (widget.type == PARENT_TYPE) {
      objectEvent = await getSubjectReceiveFromTeacher(
          loggedParent!.childeSectionSelected,
          loggedParent!.academicYear,
          loggedParent!.stage,
          loggedParent!.grade,
          loggedParent!.semester);
    } else {
      objectEvent = await getSubjectReceiveFromTeacher(
          loggedStudent!.section!,
          loggedStudent!.academicYear!,
          loggedStudent!.stage!,
          loggedStudent!.grade!,
          loggedStudent!.semester!);
    }
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> y = data!['subjectId'];
      Map SubjectArr = new Map();
      SubjectArr['All'] = 'All';
      for (int i = 0; i < y.length; i++) {
        SubjectArr[data['subjectId'][i]] = data['subjectName'][i];
      }
      setState(() {
        subjectOption = SubjectArr;
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

  Future<void> syncReceiveFromTeacherTeacher() async {
    EventObject objectEventr = new EventObject();
    if (widget.type == PARENT_TYPE) {
      objectEventr = await getReceiveFromTeacherTeacher(
          loggedParent!.childeSectionSelected,
          loggedParent!.academicYear,
          loggedParent!.stage,
          loggedParent!.grade,
          loggedParent!.semester,
          subjectValue!,
          loggedParent!.classChild);
    } else {
      objectEventr = await getReceiveFromTeacherTeacher(
          loggedStudent!.section!,
          loggedStudent!.academicYear!,
          loggedStudent!.stage!,
          loggedStudent!.grade!,
          loggedStudent!.semester!,
          subjectValue!,
          loggedStudent!.studentClass!);
    }
    if (objectEventr.success!) {
      Map? data = objectEventr.object as Map?;
      List<dynamic> y = data!['staffId'];
      Map TeacherArr = new Map();
      TeacherArr['All'] = 'All';
      for (int i = 0; i < y.length; i++) {
        TeacherArr[data['staffId'][i]] = data['satffName'][i];
      }
      setState(() {
        teacherOption = TeacherArr;
      });
    } else {
      String? msg = objectEventr.object as String?;
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

  Future<void> syncReceiveFromTeacherShow() async {
    EventObject objectEvents = new EventObject();
    if (widget.type == PARENT_TYPE) {
      objectEvents = await getReceiveFromTeacherShow(
          loggedParent!.childeSectionSelected,
          loggedParent!.academicYear,
          loggedParent!.stage,
          loggedParent!.grade,
          loggedParent!.semester,
          subjectValue!,
          TeacherValue!,
          loggedParent!.classChild);
    } else {
      objectEvents = await getReceiveFromTeacherShow(
          loggedStudent!.section!,
          loggedStudent!.academicYear!,
          loggedStudent!.stage!,
          loggedStudent!.grade!,
          loggedStudent!.semester!,
          subjectValue!,
          TeacherValue!,
          loggedStudent!.studentClass!);
    }
    if (objectEvents.success!) {
      Map? dataShowContentdata = objectEvents.object as Map?;
      List<dynamic> listOfColumns = dataShowContentdata!['data'];
      setState(() {
        dataShowContent = listOfColumns;
        print('Response from pre chat API ${dataShowContent}');
      });
    } else {
      String? msg = objectEvents.object as String?;
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
    final SubjectSelect = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: subjectValue,
          hint: Text("Select Subject"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              subjectSelected = true;
              subjectValue = newValue!;
              TeacherValue;
              TeacherSelected = false;
              teacherOption.clear();
              syncReceiveFromTeacherTeacher();
            });
          },
          items: subjectOption
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
    final Teacher = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: TeacherValue,
          hint: Text("Select Teacher"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              TeacherSelected = true;
              TeacherValue = newValue!;
              syncReceiveFromTeacherShow();
            });
          },
          items: teacherOption
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

    final showData = Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Subject")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("")),
                  ],
                  rows:
                      dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element["Subject"])),
                                    DataCell(Text(element["Date"])),
                                    //Extracting from Map element the value
                                    DataCell(
                                      Text(
                                        'Reply',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 14),
                                      ),
                                      onTap: () {
                                        //TODO: Change the module of reply to be like a chat   SendToClassReplyPage(widget.type, widget.id))

                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) => Chat(
                                                    ChildrenId!,
                                                    element["id"].toString(),
                                                    widget.type,
                                                    element['Subjectid'])));
                                      },
                                    ),
                                  ],
                                )),
                          )
                          .toList(),
                ))));

    final body = Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: SubjectSelect,
          ),
          subjectSelected
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: Teacher,
                )
              : Container(),
          TeacherSelected
              ? new Expanded(
                  child: ListView(
                  children: <Widget>[
                    showData,
                  ],
                ))
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
                        type: widget.type,
                        sectionid: userSection!,
                        Id: ChildrenId!,
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
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
            logOut(widget.type, userId!);
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

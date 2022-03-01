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
import 'ShowAssignmentsContentPage.dart';
import 'StudentAssignments.dart';
import 'StudentReplyAssignments.dart';
import 'TeacherReplyAssignmentsContent.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class TeacherReplyAssignments extends StatefulWidget {
  final String type;
  const TeacherReplyAssignments(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _TeacherReplyAssignmentsState();
  }
}

class _TeacherReplyAssignmentsState extends State<TeacherReplyAssignments> {
  Parent? loggedParent;
  Student? loggedStudent;
  bool isLoading = false;
  List<dynamic> dataShowContent = [];
  String? userId,
      userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userType,
      userClass,
      userSemester,
      childern;
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
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      userSemester = loggedParent!.semester;
      childern = loggedParent!.regno;
    } else {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      userSemester = loggedStudent!.semester;
      childern = loggedStudent!.id;
    }
    syncTeacherReplyAssignmentsShow();
  }

  Future<void> syncTeacherReplyAssignmentsShow() async {
    EventObject objectEvents = new EventObject();
    objectEvents = await getTeacherReplyAssignments(
        userSection!,
        userAcademicYear!,
        userStage!,
        userGrade!,
        userClass!,
        userSemester!,
        childern!);
    if (objectEvents.success!) {
      Map? dataShowContentdata = objectEvents.object as Map?;
      List<dynamic> listOfColumns = dataShowContentdata!['data'];
      setState(() {
        dataShowContent = listOfColumns;
        isLoading = true;
      });
    } else {
      String? msg = objectEvents.object as String?;
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

  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => StudentAssignments(widget.type)));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => TeacherReplyAssignments(widget.type)));
          break;
        case 2:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => StudentReplyAssignments(widget.type)));
          break;
      }
    });
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );
  @override
  Widget build(BuildContext context) {
    final showData = Center(
        child: !isLoading
            ? loadingSign
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Subject")),
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("Description")),
                  ],
                  rows:
                      dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    DataCell(Text(element["Subject"])),
                                    DataCell(Text(element["Name"])),
                                    DataCell(Text(element["Date"])),
                                    //Extracting from Map element the value
                                    DataCell(
                                      Text(
                                        'Read Description',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 14),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    TeacherReplyAssignmentsContent(
                                                        element["id"]
                                                            .toString(),
                                                        widget.type)));
                                      },
                                    ),
                                  ],
                                )),
                          )
                          .toList(),
                )));

    final body = ListView(children: <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: showData,
        ),
      ),
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
                        type: widget.type,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Assignments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Teacher Reply',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reply_all),
            label: 'My Reply',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.appColor,
        onTap: _onItemTapped,
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

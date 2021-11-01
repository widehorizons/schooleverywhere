import 'package:flutter/material.dart';
import 'package:schooleverywhere/Constants/StringConstants.dart';
import 'package:schooleverywhere/Modules/Parent.dart';
import 'package:schooleverywhere/Modules/Staff.dart';
import 'package:schooleverywhere/Modules/Student.dart';
import 'package:schooleverywhere/Pages/HomePage.dart';
import 'package:schooleverywhere/SharedPreferences/Prefs.dart';
import 'package:schooleverywhere/Style/theme.dart';

class UploadedTimeTable extends StatefulWidget {
  final String type;
  const UploadedTimeTable({Key? key, required this.type}) : super(key: key);

  @override
  _UploadedTimeTableState createState() => _UploadedTimeTableState();
}

class _UploadedTimeTableState extends State<UploadedTimeTable> {
  Staff? loggedStaff;
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
      childern;
  List<dynamic> dataShowContent = [];
  String? subjectValue;
  String? TeacherValue;
  Map datesOptions = {"option1": "one"};
  Map teacherOption = {"option1": "one"};
  Map subjectOption = {"option1": "one"};
  bool subjectSelected = false;
  bool TeacherSelected = false;
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
      childern = loggedParent!.regno;
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
      childern = loggedStudent!.id;
    } else {
      loggedStaff = await getUserData() as Staff;
      userSection = loggedStaff!.section;
      userAcademicYear = loggedStaff!.academicYear;
      userStage = loggedStaff!.stage;
      userGrade = loggedStaff!.grade;
      userClass = loggedStaff!.staffClass;
      userSemester = loggedStaff!.semester;
      userId = loggedStaff!.id;
      userType = loggedStaff!.type;
      childern = loggedStaff!.id;
    }
    // syncTimeTablePeriod();
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

              subjectValue = newValue;
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

              TeacherValue = newValue;
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
                                    DataCell(Text(element["Subject"])),
                                    DataCell(Text(element["Date"])),
                                    //Extracting from Map element the value
                                    DataCell(
                                      Text(
                                        'Read Comment',
                                        style: TextStyle(
                                            color: Colors.lightBlue,
                                            fontSize: 14),
                                      ),
                                      onTap: () {
                                        //TODO: Change the module of reply to be like a chat   SendToClassReplyPage(widget.type, widget.id))
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
          // SizedBox(
          //   width: MediaQuery.of(context).size.width * .5,
          //   child: SubjectSelect,
          // ),
          // subjectSelected
          //     ? SizedBox(
          //         width: MediaQuery.of(context).size.width * .5,
          //         child: Teacher,
          //       )
          //     : Container(),
          new Expanded(
              child: ListView(
            children: <Widget>[
              showData,
            ],
          )),
        ],
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(SCHOOL_NAME),
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
                backgroundImage: AssetImage('img/logo.png'),
              ),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your onPressed code here!
        },
        child: Icon(
          Icons.add,
          size: 20,
        ),
        backgroundColor: AppTheme.appColor,
      ),
    );
  }
}

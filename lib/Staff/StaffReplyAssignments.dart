import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Modules/Staff.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
import 'Assignments.dart';
import 'PreviousAssignment.dart';
import 'StaffReplyAssignmentsContent.dart';
import 'StudentAssignmentsReply.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class StaffReplyAssignments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _StaffReplyAssignmentsState();
  }
}

class _StaffReplyAssignmentsState extends State<StaffReplyAssignments> {
  Staff? loggedStaff;
  bool isLoading = false;
  List<dynamic> dataShowContent = [];
  String? userId,
      StaffSectionId,
      academicYearValue,
      StaffStageId,
      StaffGradeId,
      StaffSubjectId,
      StaffClassId,
      StaffSemesterId;
  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    loggedStaff = await getUserData() as Staff;
    StaffSectionId = loggedStaff!.section;
    StaffStageId = loggedStaff!.stage;
    StaffGradeId = loggedStaff!.grade;
    StaffSemesterId = loggedStaff!.semester;
    StaffClassId = loggedStaff!.staffClass;
    StaffSubjectId = loggedStaff!.subject;
    userId = loggedStaff!.id;
    academicYearValue = loggedStaff!.academicYear;
    syncStaffReplyAssignmentsShow();
  }

  Future<void> syncStaffReplyAssignmentsShow() async {
    EventObject objectEvents = new EventObject();
    objectEvents = await getStaffReplyAssignments(
        StaffSectionId!,
        academicYearValue!,
        StaffStageId!,
        StaffGradeId!,
        StaffClassId!,
        StaffSemesterId!,
        userId!);
    if (objectEvents.success!) {
      Map? dataShowContentdata = objectEvents.object as Map?;
      List<dynamic> listOfColumns = dataShowContentdata!['data'];
      setState(() {
        dataShowContent = listOfColumns;
        isLoading = true;
      });
    } else {
      String? msg = objectEvents.object as String?;
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

  int _selectedIndex = 3;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => Assignments()));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => PreviousAssignments()));
          break;
        case 2:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => StudentAssignmentsReplyFromStaff()));
          break;
        case 3:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => StaffReplyAssignments()));
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
                    DataColumn(label: Text("Name")),
                    DataColumn(label: Text("Date")),
                    DataColumn(label: Text("")),
                  ],
                  rows:
                      dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
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
                                                    StaffReplyAssignmentsContent(
                                                        element["id"]
                                                            .toString())));
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
                        type: loggedStaff!.type!,
                        sectionid: loggedStaff!.section!,
                        Id: "",
                        Academicyear: "")));
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
            icon: Icon(Icons.add_comment),
            title: Text('New'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.low_priority),
            title: Text('Previous'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            title: Text('Student Reply'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reply_all),
            title: Text('My Reply'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.appColor,
        onTap: _onItemTapped,
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

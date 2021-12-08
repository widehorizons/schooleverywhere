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
import 'StaffReplyAssignments.dart';
import 'StaffReplyAssignmentsContent.dart';
import 'StudentAssignmentsReply.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class PreviousAssignments extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PreviousAssignmentsState();
  }
}

class _PreviousAssignmentsState extends State<PreviousAssignments> {
  Staff? loggedStaff;
  bool isLoading = false, checkBoxValue = false;
  List<dynamic> dataShowContent = [];
  String? userId,
      StaffSectionId,
      academicYearValue,
      StaffStageId,
      StaffGradeId,
      StaffSubjectId,
      StaffClassId,
      StaffSemesterId;
  List<dynamic> dropAssignments = [];

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
    syncPreviousAssignmentsShow();
  }

  Future<void> syncPreviousAssignmentsShow() async {
    EventObject objectEvents = new EventObject();
    objectEvents = await getPreviousAssignments(
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

  Future<void> syncDeleteAssignments() async {
    EventObject objectEventSt = await deleteAssignments(dropAssignments);
    setState(() {
      Navigator.of(context).pop();
      if (objectEventSt.success!) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PreviousAssignments()),
        );
        /*    Flushbar(
          title: "Success",
          message: "Deleted",
          icon: Icon(Icons.done_outline),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 2),
        )
          ..show(context);*/
        Fluttertoast.showToast(
            msg: "Deleted",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        String? msg = objectEventSt.object as String?;
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
    });
  }

  int _selectedIndex = 1;
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
    final deleteBtn = Padding(
      padding: EdgeInsets.symmetric(
          vertical: 30.0, horizontal: MediaQuery.of(context).size.width * .25),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          syncDeleteAssignments();
        },
        padding: EdgeInsets.all(12),
        color: Colors.red,
        child: Text('Delete', style: TextStyle(color: Colors.white)),
      ),
    );

    final showData = Center(
        child: !isLoading
            ? loadingSign
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("")),
                    DataColumn(label: Text("From")),
                    DataColumn(label: Text("To")),
                    DataColumn(label: Text("Description")),
                  ],
                  rows:
                      dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                          .map(
                            ((element) => DataRow(
                                  cells: <DataCell>[
                                    element["showCheckBox"]
                                        ? DataCell(Checkbox(
                                            value: element["checkBoxChecked"],
                                            onChanged: (bool? newValue) {
                                              setState(() {
                                                element["checkBoxChecked"] =
                                                    newValue;
                                                if (newValue!)
                                                  dropAssignments
                                                      .add(element["id"]);
                                                else
                                                  dropAssignments
                                                      .remove(element["id"]);
                                              });
                                            }))
                                        : DataCell(Text("")),
                                    DataCell(Text(element["dateFrom"])),
                                    DataCell(Text(element["dateTo"])),
                                    DataCell(Text(element["workdescrip"])),
                                  ],
                                )),
                          )
                          .toList(),
                )));

    final body = Column(
      children: <Widget>[
        Expanded(
            child: ListView(children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: showData,
            ),
          ),
        ])),
        isLoading ? deleteBtn : Container(),
      ],
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
                        type: loggedStaff!.type!,
                        sectionid: loggedStaff!.section!,
                        Id: "",
                        Academicyear: "")));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
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

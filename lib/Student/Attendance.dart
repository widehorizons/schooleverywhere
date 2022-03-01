import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
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
import 'package:schooleverywhere/config/flavor_config.dart';

class Attendance extends StatefulWidget {
  final String type;
  const Attendance(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _AttendanceState();
  }
}

class _AttendanceState extends State<Attendance> {
  Parent? loggedParent;
  Student? loggedStudent;
  String userId = "";
  String userSection = "";
  String userAcademicYear = "";
  String? monthValue;
  bool monthSelected = false;
  Map monthOption = new Map();
  List<dynamic> dataShowContent = [];

  initState() {
    super.initState();
    monthOption["1"] = "January";
    monthOption["2"] = "February";
    monthOption["3"] = "March";
    monthOption["4"] = "April";
    monthOption["5"] = "May";
    monthOption["6"] = "June";
    monthOption["7"] = "July";
    monthOption["8"] = "August";
    monthOption["9"] = "September";
    monthOption["10"] = "October";
    monthOption["11"] = "November";
    monthOption["12"] = "December";
    if (widget.type == PARENT_TYPE)
      getLoggedParent();
    else
      getLoggedStudent();
  }

  Future<void> getLoggedParent() async {
    loggedParent = await getUserData() as Parent;

    userId = loggedParent!.regno;
    userAcademicYear = loggedParent!.academicYear;
    userSection = loggedParent!.childeSectionSelected;
  }

  Future<void> getLoggedStudent() async {
    loggedStudent = await getUserData() as Student;

    userId = loggedStudent!.id!;
    userAcademicYear = loggedStudent!.academicYear!;
    userSection = loggedStudent!.section!;
  }

  Future<void> syncGetAttendance() async {
    EventObject objectEvents = new EventObject();
    objectEvents =
        await getStudentAttendance(userId, userAcademicYear, monthValue!);
    // print(objectEvents.object.toString());
    if (objectEvents.success!) {
      Map? dataShowContentdata = objectEvents.object as Map?;
      List<dynamic> listOfColumns = dataShowContentdata!['data'];
      setState(() {
        dataShowContent = listOfColumns;
      });
    } else {
      String? msg = objectEvents.object as String?;
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

  @override
  Widget build(BuildContext context) {
    final MonthSelect = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: monthValue,
          hint: Text("Select Month"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              monthSelected = true;
              monthValue = newValue!;

              syncGetAttendance();
            });
          },
          items: monthOption
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
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Text("Day")),
                DataColumn(label: Text("Statue")),
              ],
              rows:
                  dataShowContent // Loops through dataColumnText, each iteration assigning the value to element
                      .map(
                        ((element) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(element["day"])),
                                //Extracting from Map element the value
                                DataCell(
                                  Text(element["status"]),
                                ),
                              ],
                            )),
                      )
                      .toList(),
            )));

    final body = SingleChildScrollView(
        child: Center(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: MonthSelect,
          ),
          monthSelected
              ? SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: showData,
                )
              : Container(),
        ],
      ),
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
                        type: widget.type,
                        sectionid: userSection,
                        Id: userId,
                        Academicyear: userAcademicYear)));
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
            logOut(widget.type, userId);
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

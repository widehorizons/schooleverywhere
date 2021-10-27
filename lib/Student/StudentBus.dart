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
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';

class StudentBus extends StatefulWidget {
  final String type;
  const StudentBus(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _StudentBusState();
  }
}

class _StudentBusState extends State<StudentBus> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map installmentOptions = new Map();
  String? userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      childern;
  bool isLoading = false;
  List<dynamic> busData = [];
  List<dynamic> paidData = [];

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
      childern = loggedStudent!.id;
    }
    syncBusDetails();
  }

  Future<void> syncBusDetails() async {
    EventObject objectEventSt;
    if (widget.type == PARENT_TYPE)
      objectEventSt = await getBusDetails(
          userSection!, userAcademicYear!, loggedParent!.regno);
    else
      objectEventSt =
          await getBusDetails(userSection!, userAcademicYear!, userId!);
    if (objectEventSt == null) {
      setState(() {
        isLoading = true;
      });
      Fluttertoast.showToast(
          msg: 'Bus Data not available',
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      List<dynamic> listOfColumns = dataShowContentData!['data'];
      List<dynamic> listOfPaidColumns = dataShowContentData['paid'];
      setState(() {
        busData = listOfColumns;
        paidData = listOfPaidColumns;
        isLoading = true;
      });
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
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );
  @override
  Widget build(BuildContext context) {
    final showBusDetails = !isLoading
        ? loadingSign
        : Column(
            children: <Widget>[
              DataTable(
                columns: [
                  DataColumn(
                      label: Text(
                    "Amount",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Bus",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Route",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Period",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Supervisor",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Phone",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "Driver",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                  DataColumn(
                      label: Text(
                    "DriverPhone",
                    style: TextStyle(color: AppTheme.appColor, fontSize: 18),
                  )),
                ],
                rows:
                    busData // Loops through dataColumnText, each iteration assigning the value to element
                        .map(
                          ((element) => DataRow(
                                cells: <DataCell>[
                                  DataCell(Text(
                                    element["amount"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                  DataCell(Text(
                                    element["bus"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                  DataCell(Text(
                                    element["route"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                  DataCell(Text(
                                    element["period"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                  DataCell(Text(
                                    element["supervisor"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                  DataCell(Text(
                                    element["supervisorPhone"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                  DataCell(Text(
                                    element["driver"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                  DataCell(Text(
                                    element["DriverPhone"].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  )),
                                ],
                              )),
                        )
                        .toList(),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.width * .1)),
              Text(
                "Paid",
                style: TextStyle(color: Colors.blue, fontSize: 20),
              ),
              paidData != null
                  ? DataTable(
                      columns: [
                        DataColumn(
                            label: Text(
                          "Price",
                          style:
                              TextStyle(color: AppTheme.appColor, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          "Discount",
                          style:
                              TextStyle(color: AppTheme.appColor, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          "After Discount",
                          style:
                              TextStyle(color: AppTheme.appColor, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          "Paid",
                          style:
                              TextStyle(color: AppTheme.appColor, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          "Date",
                          style:
                              TextStyle(color: AppTheme.appColor, fontSize: 18),
                        )),
                        DataColumn(
                            label: Text(
                          "Time",
                          style:
                              TextStyle(color: AppTheme.appColor, fontSize: 18),
                        )),
                      ],
                      rows:
                          paidData // Loops through dataColumnText, each iteration assigning the value to element
                              .map(
                                ((element) => DataRow(
                                      cells: <DataCell>[
                                        DataCell(Text(
                                          element["price"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        )),
                                        DataCell(Text(
                                          element["discount"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        )),
                                        DataCell(Text(
                                          element["afterDiscount"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        )),
                                        DataCell(Text(
                                          element["paidFees"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        )),
                                        DataCell(Text(
                                          element["paidDate"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        )),
                                        DataCell(Text(
                                          element["paidTime"].toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        )),
                                      ],
                                    )),
                              )
                              .toList(),
                    )
                  : Container(),
            ],
          );

    final body = ListView(children: <Widget>[
      SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: showBusDetails,
        ),
      ),
    ]);

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(SCHOOL_NAME),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
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
      body: Container(
        width: MediaQuery.of(context).size.width,
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

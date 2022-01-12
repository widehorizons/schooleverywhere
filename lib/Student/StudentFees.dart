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
import 'package:schooleverywhere/config/flavor_config.dart';

class StudentFees extends StatefulWidget {
  final String type;
  const StudentFees(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _StudentFeesState();
  }
}

class _StudentFeesState extends State<StudentFees> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map installmentOptions = new Map();
  String? installmentValue,
      userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      childern;
  bool installmentSelected = false;
  bool isLoading = false;
  List<dynamic>? feesData = [];
  List<dynamic>? paidData = [];
  List<dynamic>? refundData = [];
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
    syncInstallment();
  }

  Future<void> syncInstallment() async {
    EventObject objectEventDates = await getInstallment();
    if (objectEventDates.success!) {
      Map? data = objectEventDates.object as Map?;
      List<dynamic> toto = data!['id'];
      Map installmentArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        installmentArr[data['id'][i]] = data['name'][i];
      }
      setState(() {
        installmentOptions = installmentArr;
      });
    } else {
      String? msg = objectEventDates.object as String?;
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

  Future<void> syncFeesData() async {
    EventObject objectEventSt;
    if (widget.type == PARENT_TYPE)
      objectEventSt = await getFeesData(userSection!, userAcademicYear!,
          loggedParent!.regno, installmentValue!);
    else
      objectEventSt = await getFeesData(
          userSection!, userAcademicYear!, userId!, installmentValue!);
    if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      print(
          "dataShowContentData['refund'] ==> ${dataShowContentData!['refund']}");
      List<dynamic>? listOfColumns = dataShowContentData['data']!;
      List<dynamic>? listOfPaidColumns = dataShowContentData['paid']!;
      List<dynamic>? listOfRefundColumns = dataShowContentData['refund'] ?? [];
      setState(() {
        feesData = listOfColumns!;
        paidData = listOfPaidColumns!;
        refundData = listOfRefundColumns!;
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
    final installmentUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: installmentValue,
          hint: Text("Select Installment"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              installmentSelected = true;
              installmentValue = newValue!;
              syncFeesData();
            });
          },
          items: installmentOptions
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

    final showFees = !isLoading
        ? loadingSign
        : Center(
            child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                children: <Widget>[
                  DataTable(
                    columns: [
                      DataColumn(label: Text("")),
                      DataColumn(
                          label: Text(
                        "Price",
                        style:
                            TextStyle(color: AppTheme.appColor, fontSize: 18),
                      )),
                    ],
                    rows:
                        feesData! // Loops through dataColumnText, each iteration assigning the value to element
                            .map(
                              ((element) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                        element["fees"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      )),
                                      DataCell(Text(
                                        element["feesvalue"].toString(),
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
                              style: TextStyle(
                                  color: AppTheme.appColor, fontSize: 18),
                            )),
                            DataColumn(
                                label: Text(
                              "Date",
                              style: TextStyle(
                                  color: AppTheme.appColor, fontSize: 18),
                            )),
                            DataColumn(
                                label: Text(
                              "Time",
                              style: TextStyle(
                                  color: AppTheme.appColor, fontSize: 18),
                            )),
                          ],
                          rows:
                              paidData! // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
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
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.width * .1)),
                  (refundData!.isNotEmpty)
                      ? Text(
                          "Refund",
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                        )
                      : Container(),
                  (refundData!.isNotEmpty)
                      ? DataTable(
                          columns: [
                            DataColumn(
                                label: Text(
                              "Price",
                              style: TextStyle(
                                  color: AppTheme.appColor, fontSize: 18),
                            )),
                            DataColumn(
                                label: Text(
                              "Date",
                              style: TextStyle(
                                  color: AppTheme.appColor, fontSize: 18),
                            )),
                            DataColumn(
                                label: Text(
                              "Time",
                              style: TextStyle(
                                  color: AppTheme.appColor, fontSize: 18),
                            )),
                          ],
                          rows:
                              refundData! // Loops through dataColumnText, each iteration assigning the value to element
                                  .map(
                                    ((element) => DataRow(
                                          cells: <DataCell>[
                                            DataCell(Text(
                                              element["refundFees"].toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            )),
                                            DataCell(Text(
                                              element["refundDate"].toString(),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16),
                                            )),
                                            DataCell(Text(
                                              element["refundTime"].toString(),
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
              ),
            ),
          ));

    final body = Center(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * .2),
            child: installmentUi,
          ),
          installmentSelected ? showFees : Container(),
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

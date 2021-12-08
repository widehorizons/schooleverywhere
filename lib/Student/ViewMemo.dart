import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
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

class ViewMemo extends StatefulWidget {
  final String type;
  const ViewMemo(this.type);
  @override
  State<StatefulWidget> createState() {
    return new _ViewMemoState();
  }
}

class _ViewMemoState extends State<ViewMemo> {
  Parent? loggedParent;
  Student? loggedStudent;
  bool isLoading = false;
  String? timeArrival,
      breakValue,
      lunchValue,
      snackValue,
      napValue,
      napFromValue,
      napToValue,
      commentValue;
  List<dynamic> iWas = [];
  List<dynamic> iNeed = [];
  List<dynamic> studentIpotty = [];
  String? childrenId;
  String? userId;
  String? userSection;
  String? userAcademicYear;
  final format = DateFormat("yyyy-MM-dd");
  TextEditingController dateFrom = new TextEditingController();

  initState() {
    super.initState();
    if (widget.type == PARENT_TYPE)
      getLoggedParent();
    else
      getLoggedStudent();
  }

  Future<void> getLoggedParent() async {
    loggedParent = await getUserData() as Parent;
    userId = loggedParent!.id!;
    userSection = loggedParent!.childeSectionSelected;
    userAcademicYear = loggedParent!.academicYear;
    childrenId = loggedParent!.regno;
  }

  Future<void> getLoggedStudent() async {
    loggedStudent = await getUserData() as Student;
    userId = loggedStudent!.id!;
    userSection = loggedStudent!.section!;
    userAcademicYear = loggedStudent!.academicYear!;
    childrenId = loggedStudent!.id;
  }

  Future<void> syncReceiveMemoStudent() async {
    EventObject objectEvent = new EventObject();
    if (widget.type == PARENT_TYPE) {
      objectEvent = await getMemoForStudent(
          loggedParent!.regno,
          loggedParent!.academicYear,
          dateFrom.text.toString(),
          loggedParent!.childeSectionSelected,
          loggedParent!.stage,
          loggedParent!.grade,
          loggedParent!.classChild);
    } else {
      objectEvent = await getMemoForStudent(
          loggedStudent!.id!,
          loggedStudent!.academicYear!,
          dateFrom.text.toString(),
          loggedStudent!.section!,
          loggedStudent!.stage!,
          loggedStudent!.grade!,
          loggedStudent!.studentClass!);
    }
    if (objectEvent.success!) {
      Map? data = objectEvent.object as Map?;
      List<dynamic> iWasList = data!['iwas'];
      List<dynamic> iNeedList = data['ineed'];
      List<dynamic> listOfColumnsIPotty = data['dataIpotty'];
      String time = data['timearrival'];
      String breakfast = data['breakfast'];
      String lunch = data['lunch'];
      String snack = data['snack'];
      String nap = data['nap'];
      String napFrom = data['napfrom'];
      String napTo = data['napto'];
      String comment = data['comment'];
      setState(() {
        timeArrival = time;
        iWas = iWasList;
        iNeed = iNeedList;
        studentIpotty = listOfColumnsIPotty;
        breakValue = breakfast;
        lunchValue = lunch;
        snackValue = snack;
        napValue = nap;
        napFromValue = napFrom;
        napToValue = napTo;
        commentValue = comment;
        isLoading = true;
      });
    } else {
      String? msg = objectEvent.object as String?;
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
    final dateField = Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Column(
          children: <Widget>[
            Text('Date',
                style: TextStyle(
                    color: AppTheme.appColor,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                    fontSize: 18)),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                child: Container(
                    width: MediaQuery.of(context).size.width * .5,
                    height: MediaQuery.of(context).size.height * .05,
                    child: DateTimeField(
                      format: format,
                      controller: dateFrom,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: AppTheme.appColor)),
                      ),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1996),
                            initialDate: DateTime.now(),
                            lastDate: DateTime(2050));
                      },
                    ))),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onPressed: () async {
                syncReceiveMemoStudent();
              },
              padding: EdgeInsets.all(12),
              color: AppTheme.appColor,
              child: Text('View', style: TextStyle(color: Colors.white)),
            ),
          ],
        ));
    final pottyBody = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
            child: DataTable(
          columns: [
            DataColumn(
                label: Text("Potty",
                    style: TextStyle(
                        wordSpacing: 10,
                        color: AppTheme.appColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
            DataColumn(
                label: Text("Number",
                    style: TextStyle(
                        wordSpacing: 10,
                        color: AppTheme.appColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
          ],
          rows:
              studentIpotty // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(element["potty"].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(Text(element["number"].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)))
                          ],
                        )),
                  )
                  .toList(),
        )));
    final wasBody = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
            child: DataTable(
          columns: [
            DataColumn(
                label: Text("I Was",
                    style: TextStyle(
                        wordSpacing: 10,
                        color: AppTheme.appColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
          ],
          rows:
              iWas // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(element["iwas"].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                          ],
                        )),
                  )
                  .toList(),
        )));
    final needBody = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
            child: DataTable(
          columns: [
            DataColumn(
                label: Text("I Need",
                    style: TextStyle(
                        wordSpacing: 10,
                        color: AppTheme.appColor,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 18))),
          ],
          rows:
              iNeed // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(element["ineed"].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)))
                          ],
                        )),
                  )
                  .toList(),
        )));
    final allData = Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width * .75,
          child: dateField,
        ),
        (dateFrom.text.isNotEmpty && isLoading)
            ? Column(
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      child: Table(
                          border: TableBorder.all(color: AppTheme.appColor),
                          children: [
                            TableRow(
                                //decoration: ,
                                children: <Widget>[
                                  Text(" Time Arrival: ",
                                      style: TextStyle(
                                          wordSpacing: 10,
                                          color: AppTheme.appColor,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                  Text(" " + timeArrival!,
                                      style: TextStyle(
                                          wordSpacing: 10,
                                          color: Colors.black,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18)),
                                ]),
                            TableRow(children: <Widget>[
                              Text(" Date: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + dateFrom.text,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                            TableRow(children: <Widget>[
                              Text(" Breakfast: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + breakValue!,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                            TableRow(children: <Widget>[
                              Text(" Lunch: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + lunchValue!,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                            TableRow(children: <Widget>[
                              Text(" Snack: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + snackValue!,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                            TableRow(children: <Widget>[
                              Text(" Nap: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + napValue!,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                            TableRow(children: <Widget>[
                              Text(" Time From: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + napFromValue!,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                            TableRow(children: <Widget>[
                              Text(" Time To: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + napToValue!,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                            TableRow(children: <Widget>[
                              Text(" Comment: ",
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: AppTheme.appColor,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text(" " + commentValue!,
                                  style: TextStyle(
                                      wordSpacing: 10,
                                      color: Colors.black,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                            ]),
                          ])),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: wasBody,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: needBody,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: pottyBody,
                  )
                ],
              )
            : Container()
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
                          type: widget.type,
                          sectionid: userSection!,
                          Id: childrenId!,
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
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(
                height: MediaQuery.of(context).size.height * 1.8,
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
                child: allData,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 55,
            onPressed: () {
              logOut(widget.type, userId!);
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
            )));
  }
}

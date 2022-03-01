import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import '../Pages/LoginPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class Memo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MemoState();
  }
}

class _MemoState extends State<Memo> {
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
  bool isLoading = false;
  bool studentSelected = false;
  bool breakSelected = false;
  bool lunchSelected = false;
  bool snackSelected = false;
  bool napSelected = false;
  String? studentName,
      breakfastName,
      lunchName,
      snackName,
      napName,
      studentValue,
      breakfastvalue,
      lunchvalue,
      snackvalue,
      napvalue;
  List<dynamic> studentList = [];
  Map studentOptions = new Map();
  List<dynamic> PottySelected = [];
  EventObject? datasend;
  TextEditingController CommentValue = new TextEditingController();
  Map<String, TextEditingController> pottyValue = new Map();
  TextEditingController dateFrom = new TextEditingController();
  TextEditingController timeFrom = new TextEditingController();
  TextEditingController napTimeFrom = new TextEditingController();
  TextEditingController napTimeTo = new TextEditingController();
  Map staffclassOptions = new Map();
  List<dynamic> studentIwas = [];
  List<dynamic> studentIneed = [];
  List<dynamic> studentIatebreakId = [];
  List<dynamic> studentIatelunchId = [];
  List<dynamic> studentIatesnackId = [];
  List<dynamic> studentInapId = [];
  List<dynamic> studentIpotty = [];
  List<dynamic> pottyArr = [];
  Map studentbreak = new Map();
  Map studentlunch = new Map();
  Map studentsnack = new Map();
  Map studentnap = new Map();
  Map studentnaptime = new Map();
  List? iwasSelected, ineedSelected;
  bool checkbox = false;
  final format = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("h:mm a");

  initState() {
    super.initState();
    iwasSelected = [];
    ineedSelected = [];
    PottySelected = [];
    pottyArr = [];
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
    syncStudentOptions();
    syncMemoOptions();
    setState(() {});
  }

  Future<void> syncStudentOptions() async {
    EventObject objectEventStudent = await getStudentMemo(StaffSectionId,
        StaffStageId, StaffGradeId, StaffClassId, academicYearValue);
    if (objectEventStudent.success!) {
      Map? data = objectEventStudent.object as Map?;
      List<dynamic> x = data!['studentId'];
      Map Stuarr = new Map();
      for (int i = 0; i < x.length; i++) {
        Stuarr[data['studentId'][i]] = data['studentName'][i];
      }
      setState(() {
        studentOptions = Stuarr;
      });
    } else {
      String? msg = objectEventStudent.object as String?;
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

  Future<void> syncMemoOptions() async {
    EventObject objectEventIwas = await getStudentMemoOptions(StaffSectionId,
        StaffStageId, StaffGradeId, StaffClassId, academicYearValue);
    if (objectEventIwas.success!) {
      Map? data = objectEventIwas.object as Map?;
      List<dynamic> listOfColumnsIWas = data!['dataIwas'];
      List<dynamic> listOfColumnsINeed = data['dataIneed'];
      List<dynamic> listOfColumnsIPotty = data['dataIpotty'];
      List<dynamic> listOfColumnsIbreakID = data['dataIatebreakId'];
      List<dynamic> listOfColumnsIlunchID = data['dataIatelunchId'];
      List<dynamic> listOfColumnsIsnackID = data['dataIatesnackId'];
      List<dynamic> listOfColumnsInapID = data['dataInapId'];
      Map listOfColumnsIbreak = new Map();
      for (int i = 0; i < listOfColumnsIbreakID.length; i++) {
        listOfColumnsIbreak[data['dataIatebreakId'][i]] =
            data['dataIatebreak'][i];
      }
      Map listOfColumnsIlunch = new Map();
      for (int i = 0; i < listOfColumnsIlunchID.length; i++) {
        listOfColumnsIlunch[data['dataIatelunchId'][i]] =
            data['dataIatelunch'][i];
      }
      Map listOfColumnsIsnack = new Map();
      for (int i = 0; i < listOfColumnsIsnackID.length; i++) {
        listOfColumnsIsnack[data['dataIatesnackId'][i]] =
            data['dataIatesnack'][i];
      }
      Map listOfColumnsInap = new Map();
      for (int i = 0; i < listOfColumnsInapID.length; i++) {
        listOfColumnsInap[data['dataInapId'][i]] = data['dataInap'][i];
      }
      Map listOfColumnsInapTime = new Map();
      for (int i = 0; i < listOfColumnsInapID.length; i++) {
        listOfColumnsInapTime[data['dataInapId'][i]] = data['dataInapTime'][i];
      }
      for (int i = 0; i < listOfColumnsIPotty.length; i++) {
        pottyValue[data['datapottyids'][i]] = new TextEditingController();
      }
      setState(() {
        studentIwas = listOfColumnsIWas;
        studentIneed = listOfColumnsINeed;
        studentIpotty = listOfColumnsIPotty;
        studentbreak = listOfColumnsIbreak;
        studentIatebreakId = listOfColumnsIbreakID;
        studentlunch = listOfColumnsIlunch;
        studentIatelunchId = listOfColumnsIlunchID;
        studentsnack = listOfColumnsIsnack;
        studentIatesnackId = listOfColumnsIsnackID;
        studentnap = listOfColumnsInap;
        studentInapId = listOfColumnsInapID;
        studentnaptime = listOfColumnsInapTime;
      });
    } else {
      String? msg = objectEventIwas.object as String?;
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

  Future<void> addMemoValue() async {
    isLoading = true;
    for (int i = 0; i < PottySelected.length; i++) {
      pottyArr.add(pottyValue[PottySelected[i]]!.text.toString());
    }
    datasend = await addMemo(
        StaffSectionId,
        StaffStageId,
        StaffGradeId,
        academicYearValue,
        studentValue!,
        dateFrom.text.toString(),
        timeFrom.text.toString(),
        CommentValue.text,
        iwasSelected!,
        ineedSelected!,
        PottySelected,
        pottyArr,
        breakfastvalue!,
        lunchvalue!,
        snackvalue!,
        napvalue!,
        napTimeFrom.text,
        napTimeTo.text);
    setState(() {
      isLoading = false;
    });
    if (datasend!.success!) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Memo()),
      );
      /* Flushbar(
        title: "Success",
        message: "Memo Sent",
        icon: Icon(Icons.done_outline),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
      Fluttertoast.showToast(
          msg: "Memo Sent",
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
        MaterialPageRoute(builder: (context) => Memo()),
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
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final student = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: studentValue,
          hint: Text("Select Student"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              studentSelected = true;
              studentValue = newValue!;
              studentName = studentOptions[newValue];
            });
          },
          items: studentOptions
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
    final selectedIWas = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("I was"),
          validator: (value) {
            if (value == null) return 'Please select one or more';
          },
          errorText: 'Please select one or more',
          dataSource: studentIwas,
          textField: 'display',
          valueField: 'value',
          required: false,
          initialValue: iwasSelected,
          onSaved: (value) {
            setState(() {
              iwasSelected = value;
            });
          }),
    );
    final selectedINeed = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: MultiSelectFormField(
          title: Text("I need"),
          validator: (value) {
            if (value == null) return 'Please select one or more';
          },
          errorText: 'Please select one or more',
          dataSource: studentIneed,
          textField: 'display',
          valueField: 'value',
          required: false,
          initialValue: ineedSelected,
          onSaved: (value) {
            setState(() {
              ineedSelected = value;
            });
          }),
    );
    final selectedIPotty = Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
            child: DataTable(
          columns: [
            DataColumn(
                label: Text(
              "",
            )),
            DataColumn(
                label: Text(
              "",
            )),
            DataColumn(
                label: Text(
              "",
            )),
          ],
          rows:
              studentIpotty // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Checkbox(
                                value: element["checkBoxValue"],
                                onChanged: (newValue) {
                                  setState(() {
                                    element["checkBoxValue"] = newValue;
                                    if (newValue!)
                                      PottySelected.add(element["value"]);
                                    else
                                      PottySelected.remove(element["value"]);
                                  });
                                })),
                            DataCell(Text(element["display"].toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14))),
                            DataCell(TextField(
                              controller: pottyValue[element["value"]],
                              maxLines: 1,
                              decoration: new InputDecoration(labelText: ""),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[],
                            ))
                          ],
                        )),
                  )
                  .toList(),
        )));
    final breakfast = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: breakfastvalue,
          hint: Text("Select"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              breakSelected = true;
              breakfastvalue = newValue!;
              breakfastName = studentbreak[newValue];
            });
          },
          items: studentbreak
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
    final lunch = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: lunchvalue,
          hint: Text("Select"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              lunchSelected = true;
              lunchvalue = newValue!;
              lunchName = studentlunch[newValue];
            });
          },
          items: studentlunch
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
    final snack = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: snackvalue,
          hint: Text("Select"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              snackSelected = true;
              snackvalue = newValue!;
              snackName = studentsnack[newValue];
            });
          },
          items: studentsnack
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
    final nap = Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: napvalue,
          hint: Text("Select"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              napSelected = true;
              napvalue = newValue!;
              napName = studentnap[newValue];
            });
          },
          items: studentnap
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
    final data = SingleChildScrollView(
        child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height * 2.2,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * .58,
                  child: student,
                ),
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
                                borderSide:
                                    BorderSide(color: AppTheme.appColor)),
                          ),
                          onShowPicker: (context, currentValue) {
                            return showDatePicker(
                                context: context,
                                firstDate: DateTime(1996),
                                initialDate: DateTime.now(),
                                lastDate: DateTime(2050));
                          },
                        ))),
                (studentSelected)
                    ? Container(
                        child: Column(
                          children: <Widget>[
                            Text(" Time of arrival ",
                                style: TextStyle(
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    height: MediaQuery.of(context).size.height *
                                        .05,
                                    child: DateTimeField(
                                      format: timeFormat,
                                      controller: timeFrom,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppTheme.appColor)),
                                      ),
                                      onShowPicker:
                                          (context, currentValue) async {
                                        final time = await showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.fromDateTime(
                                              currentValue!),
                                        );
                                        return DateTimeField.convert(time);
                                      },
                                    ))),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .75,
                              child: selectedIWas,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .75,
                              child: selectedINeed,
                            ),
                            Text('Potty / Changing Diapers',
                                style: TextStyle(
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .75,
                              child: selectedIPotty,
                            ),
                            Text('I ate BreakFast',
                                style: TextStyle(
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .45,
                              child: breakfast,
                            ),
                            Text('I ate Lunch',
                                style: TextStyle(
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .45,
                              child: lunch,
                            ),
                            Text('I ate Snack',
                                style: TextStyle(
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .45,
                              child: snack,
                            ),
                            Text('Nap Time',
                                style: TextStyle(
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: nap,
                            ),
                            (studentnaptime[napvalue] == "on")
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        Text(" From ",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .05,
                                                child: DateTimeField(
                                                  format: timeFormat,
                                                  controller: napTimeFrom,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: AppTheme
                                                                .appColor)),
                                                  ),
                                                  onShowPicker: (context,
                                                      currentValue) async {
                                                    final time =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay
                                                          .fromDateTime(
                                                              currentValue!),
                                                    );
                                                    return DateTimeField
                                                        .convert(time);
                                                  },
                                                ))),
                                        Text(" To ",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontStyle: FontStyle.italic,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                        Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 20),
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .5,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .05,
                                                child: DateTimeField(
                                                  format: timeFormat,
                                                  controller: napTimeTo,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: AppTheme
                                                                .appColor)),
                                                  ),
                                                  onShowPicker: (context,
                                                      currentValue) async {
                                                    final time =
                                                        await showTimePicker(
                                                      context: context,
                                                      initialTime: TimeOfDay
                                                          .fromDateTime(
                                                              currentValue!),
                                                    );
                                                    return DateTimeField
                                                        .convert(time);
                                                  },
                                                )))
                                      ],
                                    ),
                                  )
                                : Container(),
                            Text(" Comment ",
                                style: TextStyle(
                                    color: AppTheme.appColor,
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: TextField(
                                controller: CommentValue,
                                maxLines: null,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppTheme.appColor)),
                                ),
                              ),
                            ),
                            isLoading
                                ? loadingSign
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                      onPressed: () async {
                                        if (studentSelected &&
                                            dateFrom.text.isNotEmpty) {
                                          addMemoValue();
                                        } else {
                                          String msg =
                                              "Please Select Student and Date";
                                          /*  Flushbar(
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
                                              backgroundColor:
                                                  AppTheme.appColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        }
                                      },
                                      padding: EdgeInsets.all(12),
                                      color: AppTheme.appColor,
                                      child: Text('Send',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  )
                          ],
                        ),
                      )
                    : Container(),
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

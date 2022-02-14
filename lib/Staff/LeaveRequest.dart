import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'PreviousLeaveRequest.dart';

class LeaveRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LeaveRequestState();
  }
}

class _LeaveRequestState extends State<LeaveRequest> {
  Staff? loggedStaff;
  Map leaveTypeOptions = new Map();
  Map leaveNameOptions = new Map();
  bool leaveTypeSelected = false;
  bool leaveNameSelected = false, isLoading = false;
  String? leaveTypeValue, leaveNameValue;
  TextEditingController reasonValue = new TextEditingController();
  TextEditingController date = new TextEditingController();
  TextEditingController timeFrom = new TextEditingController();
  TextEditingController timeTo = new TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  final timeFormat = DateFormat("h:mm a");

  initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    syncLeaveType();
  }

  Future<void> syncLeaveType() async {
    EventObject objectEventDates = await getLeaveTypeOptions();
    if (objectEventDates.success!) {
      Map? data = objectEventDates.object as Map?;
      List<dynamic> toto = data!['id'];
      Map leaveTypeArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        leaveTypeArr[data['id'][i]] = data['name'][i];
      }
      setState(() {
        leaveTypeOptions = leaveTypeArr;
      });
    } else {
      String? msg = objectEventDates.object as String?;
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

  Future<void> syncLeaveName() async {
    EventObject objectEventDates = await getLeaveNameOptions(leaveTypeValue!);
    if (objectEventDates.success!) {
      Map? data = objectEventDates.object as Map?;
      List<dynamic> toto = data!['id'];
      Map leaveNameArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        leaveNameArr[data['id'][i]] = data['name'][i];
      }
      setState(() {
        leaveNameOptions = leaveNameArr;
      });
    } else {
      String? msg = objectEventDates.object as String?;
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

  Future<void> syncAddLeaveRequest() async {
    isLoading = true;
    if (date != null && timeFrom != null && timeTo != null) {
      EventObject objectEventAdd = await addLeaveRequest(
          loggedStaff!.id!,
          loggedStaff!.academicYear!,
          leaveTypeValue!,
          leaveNameValue!,
          reasonValue.text,
          date.text,
          timeFrom.text,
          timeTo.text);
      setState(() {
        Navigator.of(context).pop();
        if (objectEventAdd.success!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LeaveRequest()),
          );
          /*   Flushbar(
            title: "Success",
            message: "Added",
            icon: Icon(Icons.done_outline),
            backgroundColor: AppTheme.appColor,
            duration: Duration(seconds: 2),
          )
            ..show(context);*/
          Fluttertoast.showToast(
              msg: "Added",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          String? msg = objectEventAdd.object as String?;
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
    } else {
      /*  Flushbar(
        title: "Failed",
        message: 'Please Fill All Required Data',
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: "Please Fill All Required Data",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => LeaveRequest()));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => PreviousLeaveRequest(loggedStaff!.id!,
                      loggedStaff!.academicYear!, loggedStaff!.section!)));
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
    final leaveTypeUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: leaveTypeValue,
          hint: Text("Select leave Type"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              leaveTypeSelected = true;
              leaveTypeValue = newValue!;
              leaveNameOptions.clear();
              leaveNameValue = '';
              leaveNameSelected = false;
              syncLeaveName();
            });
          },
          items: leaveTypeOptions
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

    final leaveNameUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: leaveNameValue,
          hint: Text("Select leave Name"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              leaveNameSelected = true;
              leaveNameValue = newValue!;
            });
          },
          items: leaveNameOptions
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

    final data = Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(" Reason ",
            style: TextStyle(
                color: AppTheme.appColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: TextField(
            controller: reasonValue,
            maxLines: null,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.appColor)),
            ),
          ),
        ),
        Text('Date',
            style: TextStyle(
                color: AppTheme.appColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
                width: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.height * .05,
                child: DateTimeField(
                  format: format,
                  controller: date,
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
        Text('From',
            style: TextStyle(
                color: AppTheme.appColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
                width: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.height * .05,
                child: DateTimeField(
                  format: timeFormat,
                  controller: timeFrom,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.appColor)),
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue!),
                    );
                    return DateTimeField.convert(time);
                  },
                ))),
        Text('To',
            style: TextStyle(
                color: AppTheme.appColor,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Container(
                width: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.height * .05,
                child: DateTimeField(
                  format: timeFormat,
                  controller: timeTo,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.appColor)),
                  ),
                  onShowPicker: (context, currentValue) async {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue!),
                    );
                    return DateTimeField.convert(time);
                  },
                ))),
        !isLoading
            ? Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: MediaQuery.of(context).size.width * .25),
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  onPressed: () {
                    syncAddLeaveRequest();
                  },
                  padding: EdgeInsets.all(12),
                  color: AppTheme.appColor,
                  child: Text('ADD', style: TextStyle(color: Colors.white)),
                ),
              )
            : loadingSign,
      ],
    );

    final body = Center(
      widthFactor: 2,
      child: Container(
        width: MediaQuery.of(context).size.width * .75,
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .5,
              child: leaveTypeUi,
            ),
            leaveTypeSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: leaveNameUi,
                  )
                : Container(),
            leaveNameSelected ? data : Container(),
          ],
        ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            label: 'New Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.low_priority),
            label: 'Previous',
          ),
        ],
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

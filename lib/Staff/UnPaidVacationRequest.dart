import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';

import '../Pages/LoginPage.dart';
import 'PreviousUnPaidVacationRequest.dart';

class UnPaidVacationRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UnPaidVacationRequestState();
  }
}

class _UnPaidVacationRequestState extends State<UnPaidVacationRequest> {
  Staff? loggedStaff;
  Map vacationTypeOptions = new Map();
  Map vacationNameOptions = new Map();
  bool vacationTypeSelected = false;
  bool vacationNameSelected = false, isLoading = false;
  String? vacationTypeValue, vacationNameValue;
  TextEditingController reasonValue = new TextEditingController();
  TextEditingController dateFrom = new TextEditingController();
  TextEditingController dateTo = new TextEditingController();
  final format = DateFormat("yyyy-MM-dd");

  initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    syncVacationType();
  }

  Future<void> syncVacationType() async {
    EventObject objectEventDates = await getVacationTypeOptions();
    if (objectEventDates.success!) {
      Map? data = objectEventDates.object as Map?;
      List<dynamic> toto = data!['id'];
      Map vacationTypeArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        vacationTypeArr[data['id'][i]] = data['name'][i];
      }
      setState(() {
        vacationTypeOptions = vacationTypeArr;
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

  Future<void> syncVacationName() async {
    EventObject objectEventDates =
        await getVacationNameOptions(vacationTypeValue!);
    if (objectEventDates.success!) {
      Map? data = objectEventDates.object as Map?;
      List<dynamic> toto = data!['id'];
      Map vacationNameArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        vacationNameArr[data['id'][i]] = data['name'][i];
      }
      setState(() {
        vacationNameOptions = vacationNameArr;
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

  Future<void> syncAddUnPaidVacationRequest() async {
    isLoading = true;
    if (dateFrom != null && dateTo != null) {
      EventObject objectEventAdd = await addUnPaidVacationRequest(
          loggedStaff!.id!,
          loggedStaff!.academicYear!,
          vacationTypeValue!,
          vacationNameValue!,
          reasonValue.text,
          dateFrom.text,
          dateTo.text);
      setState(() {
        Navigator.of(context).pop();
        if (objectEventAdd.success!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => UnPaidVacationRequest()),
          );
          /*  Flushbar(
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
          /*Flushbar(
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
      /* Flushbar(
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

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => UnPaidVacationRequest()));
          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => PreviousUnPaidVacationRequest(
                      loggedStaff!.id!,
                      loggedStaff!.academicYear!,
                      loggedStaff!.section!)));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final vacationTypeUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: vacationTypeValue,
          hint: Text("Select Vacation Type"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              vacationTypeSelected = true;
              vacationTypeValue = newValue!;
              vacationNameOptions.clear();
              vacationNameValue = '';
              vacationNameSelected = false;
              syncVacationName();
            });
          },
          items: vacationTypeOptions
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

    final vacationNameUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: vacationNameValue,
          hint: Text("Select Vacation Name"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              vacationNameSelected = true;
              vacationNameValue = newValue!;
            });
          },
          items: vacationNameOptions
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
        Text('to',
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
                  controller: dateTo,
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
                    syncAddUnPaidVacationRequest();
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
              child: vacationTypeUi,
            ),
            vacationTypeSelected
                ? SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: vacationNameUi,
                  )
                : Container(),
            vacationNameSelected ? data : Container(),
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
            Text(SCHOOL_NAME),
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

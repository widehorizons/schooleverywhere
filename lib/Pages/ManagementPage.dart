import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schooleverywhere/config/flavor_config.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Management.dart';
import '../Networking/Futures.dart';
import '../Style/theme.dart';

import '../SharedPreferences/Prefs.dart';
import 'HomePage.dart';
import 'LoginPage.dart';

class ManagementPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _ManagementPageState();
  }
}

class _ManagementPageState extends State<ManagementPage> {
  String? academicYearValue, sectionValue, sectionNameVal;
  bool sectionSelected = false;
  bool academicYearSelected = false;
  Map sectionsOptions = new Map();
  List<String> academicYearsOptions = [];
  Management? loggedManagement;

  @override
  initState() {
    super.initState();
    getLoggedManagement();
  }

  Future<void> getLoggedManagement() async {
    loggedManagement = await getUserData() as Management;
    if (loggedManagement!.section != null &&
        loggedManagement!.academicYear != null) {
      sectionValue = loggedManagement!.section;
      sectionNameVal = loggedManagement!.sectionName;
      academicYearValue = loggedManagement!.academicYear;
      sectionSelected = true;
      academicYearSelected = true;
      syncSectionOptions();
      syncAcademicYearOptions();
    } else
      syncSectionOptions();
  }

  Future<void> syncSectionOptions() async {
    EventObject objectEventSection =
        await sectionOptions(loggedManagement!.id!);
    if (objectEventSection.success!) {
      Map? toto = objectEventSection.object as Map?;
      List<dynamic> x = toto!['sectionId'];
      Map Sectionarr = new Map();
      for (int i = 0; i < x.length; i++) {
        Sectionarr[toto['sectionId'][i]] = toto['sectionName'][i];
      }
      setState(() {
        sectionsOptions = Sectionarr;
      });
    } else {
      String? msg = objectEventSection.object as String?;
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

  Future<void> syncAcademicYearOptions() async {
    EventObject objectEventYear = await academicYearOptions(sectionValue!);
    if (objectEventYear.success!) {
      List? toto = objectEventYear.object as List?;
      List<String> convert = [];
      for (int i = 0; i < toto!.length; i++) {
        convert.add(toto[i].toString());
      }
      setState(() {
        academicYearsOptions = convert;
      });
      print("Data: " + toto.toString());
    } else {
      String? msg = objectEventYear.object as String?;
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
    final section = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: sectionValue,
          hint: Text("Select Your Section"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              sectionSelected = true;
              sectionValue = newValue!;
              sectionNameVal = sectionsOptions[newValue];
              academicYearsOptions.clear();
              academicYearValue;
              academicYearSelected = false;
              syncAcademicYearOptions();
            });
          },
          items: sectionsOptions
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
    final academicYear = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
        isExpanded: true,
        value: academicYearValue,
        hint: Text("Select Academic Year"),
        style: TextStyle(color: AppTheme.appColor),
        underline: Container(
          height: 2,
          color: AppTheme.appColor,
        ),
        onChanged: (String? newValue) {
          setState(() {
            academicYearSelected = true;
            academicYearValue = newValue!;
          });
        },
        items:
            academicYearsOptions.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );

    final goButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          goHomePage();
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('GO', style: TextStyle(color: Colors.white)),
      ),
    );
    final body = Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * .15),
            child: new Icon(
              Icons.person,
              color: AppTheme.appColor,
              size: MediaQuery.of(context).size.height * .15,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: section,
          ),
          sectionSelected
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .5,
                  child: academicYear,
                )
              : Container(),
          academicYearSelected
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * .4,
                  child: goButton,
                )
              : Container(),
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
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.transparent,
              backgroundImage:
                  AssetImage('FlavorConfig.instance.values.imagePath!'),
            )
          ],
        ),
        backgroundColor: AppTheme.appColor,
      ),
      body: Container(
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
            logOut(loggedManagement!.type!, loggedManagement!.id!);
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

  Future<void> goHomePage() async {
    loggedManagement!.section = sectionValue!;
    loggedManagement!.sectionName = sectionNameVal!;
    loggedManagement!.academicYear = academicYearValue!;
    await setUserData(loggedManagement!);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
              type: loggedManagement!.type!,
              sectionid: loggedManagement!.section!,
              Id: loggedManagement!.id!,
              Academicyear: loggedManagement!.academicYear!)),
    );
  }
}

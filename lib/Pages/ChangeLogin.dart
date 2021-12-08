import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schooleverywhere/config/flavor_config.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';

import 'HomePage.dart';
import 'LoginPage.dart';

class ChangeLogin extends StatefulWidget {
  final String type;
  const ChangeLogin(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _ChangeLoginState();
  }
}

class _ChangeLoginState extends State<ChangeLogin> {
  Staff? loggedStaff;
  Parent? loggedParent;
  Student? loggedStudent;
  Map userNameData = new Map();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController reTypePasswordController = new TextEditingController();
  bool isLoading = false;
  bool isLoadingTwo = false;
  bool _obscureTextPass = true;

  String? userSection, userAcademicYear, userId, userType, userChildren;
  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userSection = loggedParent!.childeSectionSelected;
      userAcademicYear = loggedParent!.academicYear;
      userId = loggedParent!.id!;
      userType = loggedParent!.type!;
      userChildren = loggedParent!.regno;
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userId = loggedStudent!.id!;
      userType = loggedStudent!.type!;
      userChildren = loggedStudent!.id!;
    } else {
      loggedStaff = await getUserData() as Staff;
      userSection = loggedStaff!.section;
      userAcademicYear = loggedStaff!.academicYear;
      userId = loggedStaff!.id!;
      userType = loggedStaff!.type!;
      userChildren = loggedStaff!.id!;
    }
    syncChangeLoginData();
  }

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  Future<void> syncChangeLoginData() async {
    EventObject objectEventDates =
        await getChangeLoginUserName(userType!, userId!);
    if (objectEventDates.success!) {
      userNameData = objectEventDates.object as Map;
      setState(() {
        isLoading = true;
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

  Future<void> changeData() async {
    setState(() {
      isLoadingTwo = true;
    });

    if (userNameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      if (reTypePasswordController.text == passwordController.text) {
        EventObject objectEvent = await changeUserNameAndPassword(userType!,
            userId!, userNameController.text, passwordController.text);
        setState(() {
          isLoadingTwo = false;
        });
        if (objectEvent.success!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                    type: userType!,
                    sectionid: userSection!,
                    Id: userChildren!,
                    Academicyear: userAcademicYear!)),
          );
          /* Flushbar(
          title: "Success",
          message: "Changes",
          icon: Icon(Icons.done_outline),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 2),
        )..show(context);*/
          Fluttertoast.showToast(
              msg: "Changes",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
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
      } else {
        /* Flushbar(
          title: "Failed",
          message: "Password Does Not Match",
          icon: Icon(Icons.close),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 3),
        )
          ..show(context);*/
        Fluttertoast.showToast(
            msg: "Password Does Not Match",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          passwordController.clear();
          reTypePasswordController.clear();
          isLoadingTwo = false;
        });
      }
    } else {
      /*  Flushbar(
        title: "Failed",
        message: "Please Enter Data",
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: "Please Enter Data",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        passwordController.clear();
        reTypePasswordController.clear();
        isLoadingTwo = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    userNameController.text = userNameData['username'] ?? "";

    final rules = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .08),
      child: Text(
          "Minimum 8 Characters\ncombination of Letters and Numbers\nEnglish Language only allowed ",
          style: TextStyle(
              color: Colors.red,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 14)),
    );

    final userName = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .08),
      child: TextField(
        controller: userNameController,
        autofocus: false,
        decoration: InputDecoration(
          labelText: "UserName",
          labelStyle: TextStyle(color: AppTheme.appColor, fontSize: 18),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final password = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .08),
      child: TextField(
        controller: passwordController,
        autofocus: true,
        obscureText: _obscureTextPass,
        decoration: InputDecoration(
          labelText: "Password",
          labelStyle: TextStyle(color: AppTheme.appColor, fontSize: 18),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final reTypePassword = Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * .08),
      child: TextField(
        controller: reTypePasswordController,
        autofocus: false,
        obscureText: _obscureTextPass,
        decoration: InputDecoration(
          labelText: "ReType Password",
          labelStyle: TextStyle(color: AppTheme.appColor, fontSize: 18),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          changeData();
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('Change', style: TextStyle(color: Colors.white)),
      ),
    );

    final body = !isLoading
        ? loadingSign
        : Center(
            child: SingleChildScrollView(
                child: Column(
            children: <Widget>[
              rules,
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * .05)),
              userName,
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * .05)),
              password,
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * .05)),
              reTypePassword,
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.width * .05)),
              !isLoadingTwo ? loginButton : loadingSign,
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
                        type: userType!,
                        sectionid: userSection!,
                        Id: userChildren!,
                        Academicyear: userAcademicYear!)));
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

import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Modules/Management.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'CambridgeStaffConference.dart';
import '../config/flavor_config.dart';

class cambridgeConference extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new cambridgeConferenceState();
  }
}

class cambridgeConferenceState extends State<cambridgeConference> {
  Management? loggedManagement;
  String? userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass;
  Map sessionOptions = new Map();
  String? sessionValue;
  bool sessionSelected = false;

  initState() {
    super.initState();

    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    loggedManagement = await getUserData() as Management;
    userAcademicYear = loggedManagement!.academicYear;
    userSection = loggedManagement!.section;
    userId = loggedManagement!.id!;
    userType = loggedManagement!.type!;

    syncSessionOptions();
  }

  Future<void> syncSessionOptions() async {
    EventObject objectEventStage =
        await sessionCambridgeOptions(userSection!, userAcademicYear!);
    if (objectEventStage.success!) {
      Map? data = objectEventStage.object as Map?;
      List<dynamic> x = data!['sessionId'];
      Map Sessionarr = new Map();
      for (int i = 0; i < x.length; i++) {
        Sessionarr[data['sessionId'][i]] = data['sessionName'][i];
      }
      setState(() {
        sessionOptions = Sessionarr;
        print("session map:" + Sessionarr.toString());
      });
    } else {
      String? msg = objectEventStage.object as String?;
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
  }

  @override
  Widget build(BuildContext context) {
    final session = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: sessionValue,
          hint: Text("Select Session"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              sessionSelected = true;
              sessionValue = newValue!;
            });
          },
          items: sessionOptions
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

    final body = SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width * .02),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: session,
                  ),
                  SizedBox(
                    height: 40.0,
                    width: 150,
                    child: RaisedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CambridgeStaffConference(sessionValue!)),
                        );
                      },
                      child: Text(
                        "View",
                        style: TextStyle(color: Colors.white),
                      ),
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    Widget _buildBody() {
      return body;
    }

    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(FlavorConfig.instance.values.schoolName!),
            CircleAvatar(
              radius: 20,
              backgroundImage:
                  AssetImage('${FlavorConfig.instance.values.imagePath!}'),
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
        child: _buildBody(),
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

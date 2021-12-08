import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Constants/StringConstants.dart';
import '../Modules/Staff.dart';
import '../Modules/User.dart';
import '../Pages/ManagementPage.dart';
import '../Pages/StudentPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../config/flavor_config.dart';
import 'BusPage.dart';
import 'LoginPage.dart';
import 'ParentPage.dart';
import 'StaffPage.dart';
import 'SupervisorStaffPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  late User? loggedUser;
  late Staff loggedStaff;
  bool checkSupervisor = false;
  @override
  void initState() {
    super.initState();

    checkLogin().whenComplete(() {
      Future.delayed(Duration(seconds: 5), () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => nextPage(loggedUser),
            ));
      });
    });
    ;
  }

  StatefulWidget nextPage(User? loggedUser) {
    print(loggedUser);
    if (loggedUser != null) {
      if (loggedUser.type == STUDENT_TYPE) {
        return new StudentPage();
      } else if (loggedUser.type == MANAGEMENT_TYPE) {
        return new ManagementPage();
      } else if (loggedUser.type == STAFF_TYPE) {
        if (checkSupervisor)
          return new SupervisorStaffPage();
        else
          return new StaffPage();
      } else if (loggedUser.type == PARENT_TYPE) {
        return new ParentPage();
      } else {
        return new BusPage();
      }
    } else {
      return new LoginPage();
    }
  }

  checkLoginStaff() async {
    loggedStaff = await getUserData() as Staff;
    if (loggedStaff.supervisorStaff != null)
      checkSupervisor = loggedStaff.supervisorStaff!;
  }

  checkLogin() async {
    User? user = await getUserData();
    print("Retrived user data  is $user");
    loggedUser = user ?? null;
    if (loggedUser!.type == STAFF_TYPE) {
      checkLoginStaff();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('img/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: MediaQuery.of(context).size.width * .20,
            backgroundImage:
                AssetImage('${FlavorConfig.instance.values.imagePath!}'),
          ),
        ],
      ),
    ));
  }
}

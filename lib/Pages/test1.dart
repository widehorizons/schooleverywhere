import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/Student.dart';
import '../Style/theme.dart';

import '../SharedPreferences/Prefs.dart';
import 'LoginPage.dart';

class test1 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _test1State();
  }
}

class _test1State extends State<test1> {
  late Student loggedStudent;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .15),
              child: Text("")),
        ],
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(SCHOOL_NAME),
            CircleAvatar(
              backgroundColor: Colors.transparent,
              radius: 20,
              backgroundImage: AssetImage('img/logo.png'),
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
        onPressed: () {
          removeUserData();
          while (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Icon(FontAwesomeIcons.doorOpen),
        backgroundColor: AppTheme.floatingButtonColor,
      ),
    );
  }
}

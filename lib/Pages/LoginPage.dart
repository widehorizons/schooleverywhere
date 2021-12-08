import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:schooleverywhere/config/flavor_config.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/ManagementPage.dart';
import '../Style/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'BusPage.dart';
import 'ParentPage.dart';
import 'StaffPage.dart';
import 'StudentPage.dart';
import 'SupervisorStaffPage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  String? dropdownValue;
  List<String> options = [];
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool isLoading = false;
  bool _obscureTextPass = true;
  String _token = "";
  Stream<String>? _tokenStream;
  Future<void> syncOptions() async {
    EventObject objectEventoption = await loginTypeOptions();
    if (objectEventoption.success!) {
      List<dynamic>? toto = objectEventoption.object as List?;
      //List<dynamic> toto = data['loginType'];
      print("loginType" + toto.toString());
      List<String> convert = [];
      for (int i = 0; i < toto!.length; i++) {
        convert.add(toto[i].toString());
      }
      setState(() {
        options = convert;
      });
      print("Data: " + toto.toString());
    } else {
      String? msg = objectEventoption.object as String?;
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

  void setToken(String? token) {
    print('FCM Token: $token');
    setState(() {
      _token = token!;
    });
  }

  @override
  initState() {
    super.initState();
    FirebaseMessaging.instance.getToken().then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream!.listen(setToken);
    syncOptions();
  }

  @override
  Widget build(BuildContext context) {
    final logo = CircleAvatar(
      radius: MediaQuery.of(context).size.width * .20,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage('${FlavorConfig.instance.values.imagePath!}'),
    );
    final userSelect = DropdownButton<String>(
      isExpanded: true,
      value: dropdownValue,
      hint: Text("Select"),
      style: TextStyle(color: AppTheme.appColor),
      underline: Container(
        height: 2,
        color: AppTheme.appColor,
      ),
      onChanged: (String? newValue) {
        setState(() {
          dropdownValue = newValue!;
        });
      },
      items: options.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
    final email = Padding(
      padding: EdgeInsets.only(left: 10, right: 20),
      child: TextField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: InputDecoration(
          hintText: 'Your User Name',
          icon: new Icon(Icons.person, color: AppTheme.appColor),
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        ),
      ),
    );

    final password = Padding(
      padding: EdgeInsets.only(left: 10, right: 20),
      child: TextField(
        controller: passwordController,
        autofocus: false,
        obscureText: _obscureTextPass,
        decoration: InputDecoration(
          hintText: 'Your Password',
          suffixIcon: GestureDetector(
            onTap: _togglePass,
            child: Icon(
                _obscureTextPass
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye,
                color: AppTheme.appColor,
                size: 20.0),
          ),
          icon: new Icon(Icons.lock, color: AppTheme.appColor),
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
          loginData();
        },
        padding: EdgeInsets.all(12),
        color: AppTheme.appColor,
        child: Text('Log In', style: TextStyle(color: Colors.white)),
      ),
    );

    final loadingSign = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: SpinKitPouringHourGlass(
        color: AppTheme.appColor,
      ),
    );

    final schoolWebsiteLabel = FlatButton(
      child: Text(
        'School Website',
        style: TextStyle(color: AppTheme.appColor),
      ),
      onPressed: () async {
        await launch(FlavorConfig.instance.values.baseUrl!);
      },
    );

    return Scaffold(
//      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text(FlavorConfig.instance.values.schoolName!),
        backgroundColor: AppTheme.appColor,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints.tightFor(
              height: MediaQuery.of(context).size.height * .89,
            ),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/bg.png'),
                  fit: BoxFit.cover,
                ),
              ),
              height: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: logo,
                  ),
                  new Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .5,
                      child: userSelect,
                    ),
                  ),
                  email,
                  password,
                  !isLoading ? loginButton : loadingSign,
                  schoolWebsiteLabel
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginData() async {
    print("strtoken: " + _token);
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      if (dropdownValue != null) {
        setState(() {
          isLoading = true;
        });
        EventObject objectEvent = await login(emailController.text,
            passwordController.text, dropdownValue!, _token);
        setState(() {
          isLoading = false;
        });
        if (objectEvent.success!) {
          Map? mapValue = objectEvent.object as Map?;
          bool checkSupervisor = false;
          print('Token value : ${mapValue.toString()}');
          if (dropdownValue == STAFF_TYPE)
            checkSupervisor = mapValue!['checkSupervisor'];
          if (dropdownValue != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      nextPage(dropdownValue!, checkSupervisor)),
            );
          }
        } else {
          String? msg = objectEvent.object as String?;
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
      } else {
        // please choose ur account type
        Fluttertoast.showToast(
            msg: "please choose ur account type",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIosWeb: 3,
            backgroundColor: AppTheme.appColor,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      /*   Flushbar(
          title: "Failed",
          message: "Please Enter Username Or Password",
          icon: Icon(Icons.close),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 3),
        )
          ..show(context);*/

      Fluttertoast.showToast(
          msg: "Please Enter Username Or Password",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoading = false;
      });
    }
  }

  void _togglePass() {
    setState(() {
      _obscureTextPass = !_obscureTextPass;
    });
  }

  StatefulWidget nextPage(String loggedUser, bool checkSupervisor) {
    if (loggedUser == STUDENT_TYPE) {
      return new StudentPage();
    } else if (loggedUser == MANAGEMENT_TYPE) {
      return new ManagementPage();
    } else if (loggedUser == STAFF_TYPE) {
      if (checkSupervisor)
        return new SupervisorStaffPage();
      else
        return new StaffPage();
    } else if (loggedUser == PARENT_TYPE) {
      return new ParentPage();
    } else {
      return new BusPage();
    }
  }
}

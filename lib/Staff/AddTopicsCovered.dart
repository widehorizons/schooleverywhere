import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:schooleverywhere/config/flavor_config.dart';
import '../Constants/StringConstants.dart';
import '../Pages/HomePage.dart';
import '../Pages/LoginPage.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Networking/Futures.dart';

import 'TopicsCovered.dart';

class AddTopicsCovered extends StatefulWidget {
  final String dateId;

  const AddTopicsCovered({required this.dateId});
  @override
  State<StatefulWidget> createState() {
    return new _AddTopicsCoveredState();
  }
}

class _AddTopicsCoveredState extends State<AddTopicsCovered> {
  Staff? loggedStaff;
  List? classSelected;
  List<dynamic> classstaff = [];

  initState() {
    super.initState();
    classSelected = [];
    getLoggedStaff();
  }

  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    syncClassOptions();
    syncGetDivision();
  }

  Future<void> syncClassOptions() async {
    EventObject objectEventClass = await getClassStaffData(
        loggedStaff!.section!,
        loggedStaff!.stage!,
        loggedStaff!.grade!,
        loggedStaff!.academicYear!,
        loggedStaff!.id!);
    if (objectEventClass.success!) {
      Map? data = objectEventClass.object as Map?;
      List<dynamic> listOfColumns = data!['data'];
      setState(() {
        classstaff = listOfColumns;
      });
    } else {
      String? msg = objectEventClass.object as String?;
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

  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );

  List<Widget> addCommentDivision = [];
  Map<String, TextEditingController> addTopicsCommentArr = new Map();
  List<dynamic> divisionArr = [];
  List<String> commentArr = [];
  bool isLoading = false;

  Future<void> syncGetDivision() async {
    EventObject objectEventGetDivision = await getDivisionTopicsCovered(
        loggedStaff!.section!,
        loggedStaff!.academicYear!,
        loggedStaff!.stage!,
        loggedStaff!.grade!,
        loggedStaff!.subject!);

    if (objectEventGetDivision.success!) {
      Map? data = objectEventGetDivision.object as Map?;
      List<dynamic> toto = data!['division'];
      Map<String, TextEditingController> addTopicsComment = new Map();
      List<Widget> commentsBox = [];

      for (int i = 0; i < toto.length; i++) {
        addTopicsComment[data['division'][i]] = new TextEditingController();
        print("devission: " + data['division'][i].toString());
        commentsBox.add(
          Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    data['divisionName'][i].toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: AppTheme.appColor),
                  )),
              Card(
                child: new TextField(
                  maxLines: null,
                  keyboardType: TextInputType.text,
                  controller: addTopicsComment[data['division'][i]],
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Your Topic',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      setState(() {
        addTopicsCommentArr = addTopicsComment;
        divisionArr = toto;
        addCommentDivision = commentsBox;
      });
    } else {
      String? msg = objectEventGetDivision.object as String?;
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

  Future<void> addTopic() async {
    if (classSelected!.isNotEmpty) {
      isLoading = true;
      for (int i = 0; i < divisionArr.length; i++) {
        commentArr.add(addTopicsCommentArr[divisionArr[i]]!.text);
      }
      EventObject objectEventTopics = await addTopicsCovered(
          loggedStaff!.id!,
          loggedStaff!.section!,
          loggedStaff!.academicYear!,
          loggedStaff!.stage!,
          loggedStaff!.grade!,
          classSelected!,
          loggedStaff!.subject!,
          widget.dateId,
          divisionArr,
          commentArr);
      setState(() {
        Navigator.of(context).pop();
        if (objectEventTopics.success!) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TopicsCovered()),
          );
          /*   Flushbar(
          title: "Success",
          message: "Added",
          icon: Icon(Icons.done_outline),
          backgroundColor: AppTheme.appColor,
          duration: Duration(seconds: 2),
        )..show(context);*/
          Fluttertoast.showToast(
              msg: "Added",
              toastLength: Toast.LENGTH_LONG,
              timeInSecForIosWeb: 3,
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        } else {
          String? msg = objectEventTopics.object as String?;
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
              backgroundColor: AppTheme.appColor,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } else {
      /* Flushbar(
        title: "Failed",
        message: "Please select one or more class",
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )..show(context);*/
      Fluttertoast.showToast(
          msg: "Please select one or more class",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final body = Center(
        child: SingleChildScrollView(
            child: ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        height: MediaQuery.of(context).size.height * 1.4,
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            width: MediaQuery.of(context).size.width * .75,
            child: MultiSelectFormField(
                autovalidate: false,
                title: Text("Class"),
                validator: (value) {
                  if (value == null)
                    return 'Please select one or more class(s)';
                },
                errorText: 'Please select one or more class(s)',
                dataSource: classstaff,
                textField: 'display',
                valueField: 'value',
                required: true,
                initialValue: classSelected,
                onSaved: (value) {
                  setState(() {
                    classSelected = value;
                    print("selected class:" + classSelected.toString());
                  });
                }),
          ),
          Container(
            width: MediaQuery.of(context).size.width * .8,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Expanded(
                    child: ListView(
                  children: addCommentDivision,
                )),
                !isLoading
                    ? RaisedButton(
                        color: AppTheme.appColor,
                        child:
                            Text("ADD", style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          addTopic();
                        },
                      )
                    : loadingSign
              ],
            ),
          ),
        ],
      ),
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

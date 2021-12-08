import '../Pages/DownloadList.dart';
import '../Networking/TopicCover.dart';
import 'package:expandable/expandable.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Networking/Futures.dart';
import '../Pages/LoginPage.dart';
import 'StudentTopicsCoveredReadComment.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class StudentTopicsCovered extends StatefulWidget {
  final String type;
  const StudentTopicsCovered(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _StudentTopicsCoveredState();
  }
}

class _StudentTopicsCoveredState extends State<StudentTopicsCovered> {
  Parent? loggedParent;
  Student? loggedStudent;
  Map datesOptions = new Map();
  Map subjectOptions = new Map();
  Map divisions = new Map();
  String? dateValue,
      userSection,
      userAcademicYear,
      userStage,
      userGrade,
      userId,
      userType,
      userClass,
      childern;
  bool dateSelected = false;
  bool chkAttach = false;
  List<dynamic> previousTopicsCovered = [];
  List<dynamic> files = [];
  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userSection = loggedParent!.childeSectionSelected;
      userAcademicYear = loggedParent!.academicYear;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      userClass = loggedParent!.classChild;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childern = loggedParent!.regno;
    } else {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass = loggedStudent!.studentClass;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childern = loggedStudent!.id;
    }
    syncDates();
  }

  Future<void> syncDates() async {
    EventObject objectEventDates = await getTopicsCoveredDates(
        userSection!, userAcademicYear!, userStage!, userGrade!, userType!);
    if (objectEventDates.success!) {
      Map? data = objectEventDates.object as Map?;
      List<dynamic> toto = data!['id'];
      Map datesArr = new Map();
      for (int i = 0; i < toto.length; i++) {
        datesArr[data['id'][i]] = data['name'][i];
      }
      setState(() {
        datesOptions = datesArr;
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

  Future<void> syncPreviousStudentTopics() async {
    EventObject objectEventSt = await previousStudentTopics(userSection!,
        userAcademicYear!, userStage!, userGrade!, userClass!, dateValue!);
    if (objectEventSt.success!) {
      Map? dataShowContentData = objectEventSt.object as Map?;
      List<dynamic> listOfColumns = dataShowContentData!['data'];
      setState(() {
        files = dataShowContentData['attach'];
        chkAttach = dataShowContentData['checkattach'];
        previousTopicsCovered = listOfColumns;
      });
    } else {
      String? msg = objectEventSt.object as String?;
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

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;

    final dateUi = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: DropdownButton<String>(
          isExpanded: true,
          value: dateValue,
          hint: Text("Select Date"),
          style: TextStyle(color: AppTheme.appColor),
          underline: Container(
            height: 2,
            color: AppTheme.appColor,
          ),
          onChanged: (String? newValue) {
            setState(() {
              dateSelected = true;
              dateValue = newValue!;
              syncPreviousStudentTopics();
            });
          },
          items: datesOptions
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

    int le;
    final showData = Center(
      child: Column(
        children: <Widget>[
          (previousTopicsCovered != null)
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text(
                        "Subject",
                        style:
                            TextStyle(color: AppTheme.appColor, fontSize: 16),
                      )),
                      DataColumn(
                          label: Text(
                        "Division",
                        style:
                            TextStyle(color: AppTheme.appColor, fontSize: 16),
                      )),
                      DataColumn(
                          label: Text(
                        "Comment",
                        style:
                            TextStyle(color: AppTheme.appColor, fontSize: 16),
                      )),
                    ],
                    rows:
                        previousTopicsCovered // Loops through dataColumnText, each iteration assigning the value to element
                            .map(
                              ((element) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                        element["Subject"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )),
                                      DataCell(Text(
                                        element["namedivision"],
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 14),
                                      )),
                                      DataCell(
                                        Text(
                                          "Read Comment",
                                          style: TextStyle(
                                              color: Colors.lightBlue,
                                              fontSize: 14),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              new MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentTopicsCoveredReadComment(
                                                          element["Comment"],
                                                          userType!)));
                                        },
                                      ),
                                    ],
                                  )),
                            )
                            .toList(),
                  ))
              : Container(),
        ],
      ),
    );

    final goButton = SizedBox(
      width: MediaQuery.of(context).size.width * .5,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.25),
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          onPressed: () async {
            await launch(TopicCover.SCHOOL_TOPIC_COVER_LINK +
                "?myyears=" +
                userAcademicYear! +
                "&sections=" +
                userSection! +
                "&stage=" +
                userStage! +
                "&grade=" +
                userGrade! +
                "&class=" +
                userClass! +
                "&dta=" +
                dateValue!);
          },
          padding: EdgeInsets.all(12),
          color: AppTheme.appColor,
          child: Text('Overall', style: TextStyle(color: Colors.white)),
        ),
      ),
    );

    final body = Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .5,
            child: dateUi,
          ),
          (dateSelected && chkAttach)
              ? DownloadList(
                  files,
                  platform: platform,
                  title: '',
                )
              : Container(),
          dateSelected
              ? new Expanded(
                  child: ListView(
                    children: <Widget>[showData, goButton],
                  ),
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
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: userType!,
                        sectionid: userSection!,
                        Id: childern!,
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

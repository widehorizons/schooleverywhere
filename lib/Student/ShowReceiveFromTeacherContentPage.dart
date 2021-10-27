import 'package:dio/dio.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/DownloadList.dart';
import '../Pages/LoginPage.dart';
import '../Student/MailInboxContentsPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'SendToClassReplyPage.dart';
import '../Student/viewAudioPage.dart';

class ShowReceiveFromTeacherContentPage extends StatefulWidget {
  dynamic id;
  final String type;

  ShowReceiveFromTeacherContentPage(this.id, this.type);
  @override
  State<StatefulWidget> createState() {
    return new _ShowReceiveFromTeacherContentPageState();
  }
}

class _ShowReceiveFromTeacherContentPageState
    extends State<ShowReceiveFromTeacherContentPage> {
  Map DataRec = new Map();
  Parent? loggedParent;
  Student? loggedStudent;
  dynamic attachment;
  String commentRec = "Loading.....";

  initState() {
    super.initState();
    getData();
    getLoggedStudent();
  }

  Future<void> getLoggedStudent() async {
    if (widget.type == "Student") {
      loggedStudent = await getUserData() as Student;
    } else {
      loggedParent = await getUserData() as Parent;
    }
    InsertSeenRec();
    //  print("ParentData "+loggedParent.regno.toString());
  }

  Future<void> InsertSeenRec() async {
    if (widget.type == "Student") {
      await SeenMessage_ReceiveFromTeacher(
          widget.id,
          loggedStudent!.id!,
          loggedStudent!.academicYear!,
          loggedStudent!.section!,
          loggedStudent!.stage!,
          loggedStudent!.grade!,
          loggedStudent!.studentClass!,
          loggedStudent!.semester!);
    } else {
      await SeenMessage_ReceiveFromTeacher(
          widget.id,
          loggedParent!.regno,
          loggedParent!.academicYear,
          loggedParent!.childeSectionSelected,
          loggedParent!.stage,
          loggedParent!.grade,
          loggedParent!.classChild,
          loggedParent!.semester);
    }
  }

  Future<void> getData() async {
    // print("ID:"+ widget.id.toString());
    EventObject eventObject = await getUserDataRec(widget.id.toString());
    if (eventObject.success!) {
      Map? DataRec = eventObject.object as Map?;
      setState(() {
        DataRec;
        commentRec = DataRec!['Comment'].toString();
      });
    } else {
      String? msg = eventObject.object as String?;
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final platform = Theme.of(context).platform;
    final replyButton = Center(
        child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    SendToClassReplyPage(widget.type, widget.id)));
      },
      padding: EdgeInsets.all(12),
      color: AppTheme.appColor,
      child: Text('Reply', style: TextStyle(color: Colors.white)),
    ));
    final body = Padding(
      padding: EdgeInsets.symmetric(vertical: 100.0),
      child: Center(
        child: FutureBuilder(
          future: getUserDataRec(widget.id.toString()),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: SpinKitPouringHourGlass(
                    color: AppTheme.appColor,
                  ),
                ),
              );
            } else {
              EventObject eventObject = snapshot.data;
              if (!eventObject.success!) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(eventObject.object.toString()),
                  ),
                );
              } else {
                EventObject eventObject = snapshot.data;
                Map? mapValue = eventObject.object as Map?;
                print("Record API Response: $mapValue");

                return Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Center(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(mapValue!['data']['Comment'].toString()),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .03),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * .5,
                        child: replyButton,
                      ),
                    ),
                    (mapValue['data']['File'] != 'not found')
                        ? DownloadList(
                            mapValue['data']['File'],
                            platform: platform,
                            title: '',
                          )
                        : Container(),
                    (mapValue['data']['Voice'] != 'not found')
                        ? Container(
                            child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => viewAudioPage(
                                          mapValue['data']['Voice'])));
                            },
                            padding: EdgeInsets.all(12),
                            color: AppTheme.appColor,
                            child: Text('Voice Recorder',
                                style: TextStyle(color: Colors.white)),
                          ))
                        : Container(),
                  ],
                );
              }
            }
          },
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
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('img/logo.png'),
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

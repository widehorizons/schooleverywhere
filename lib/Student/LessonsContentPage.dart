import 'dart:async';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/DownloadList.dart';
import '../Pages/HomePage.dart';
import '../Style/theme.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SharedPreferences/Prefs.dart';
import '../Pages/LoginPage.dart';
import 'viewVideoPage.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class LessonsContentPage extends StatefulWidget {
  final String lessonId;
  final String tableName;
  final String type;
  final String id;
  final String section;
  final String academicyear;
  LessonsContentPage(this.lessonId, this.tableName, this.type, this.id,
      this.section, this.academicyear);
  @override
  State<StatefulWidget> createState() {
    return new _LessonsContentPageState(
        this.lessonId, this.tableName, this.academicyear);
  }
}

class _LessonsContentPageState extends State<LessonsContentPage> {
  _LessonsContentPageState(this.lessonId, this.tableName, this.academicyear);
  final String lessonId;
  final String tableName;
  final String academicyear;
  bool isLoading = true;
  String errorLesson = " ";
  Map data = new Map();
  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );
  Future<void> syncLessons() async {
    setState(() {
      isLoading = true;
    });
    EventObject eventObject =
        await getLessonDetails(lessonId, tableName, academicyear, widget.id);
    if (eventObject.success!) {
      data = eventObject.object as Map;
      print("id lesson: " + lessonId);
      print("Lesson details === > $data");
      setState(() {
        data;
        isLoading = false;
      });
    } else {
      String? lesson = eventObject.object as String?;
      errorLesson = lesson!;
      /*  Flushbar(
        title: "Failed",
        message: lesson.toString(),
        icon: Icon(Icons.close),
        backgroundColor: AppTheme.appColor,
        duration: Duration(seconds: 3),
      )
        ..show(context);*/
      Fluttertoast.showToast(
          msg: lesson.toString(),
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIosWeb: 3,
          backgroundColor: AppTheme.appColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  var progress = "";
  bool downloading = false;

  @override
  void initState() {
    super.initState();
    syncLessons();
  }

  @override
  Widget build(BuildContext context) {
    final platform = Theme.of(context).platform;
    final body = Center(
      child: isLoading
          ? loadingSign
          : data == null
              ? Text(errorLesson)
              : Column(
                  children: <Widget>[
                    new Expanded(
                        flex: 1,
                        child: new SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Stack(children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * .9,
                              padding: new EdgeInsets.all(3.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    DataTable(
                                      columns: [
                                        DataColumn(label: Text("")),
                                        DataColumn(label: Text(""))
                                      ],
                                      rows: [
                                        DataRow(cells: [
                                          DataCell(Text(
                                            "Date",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontSize: 14),
                                          )),
                                          DataCell(Text(
                                            data['filedate'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text(
                                            "Title",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontSize: 14),
                                          )),
                                          DataCell(Text(
                                            data['title'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ))
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text(
                                            "Description",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontSize: 14),
                                          )),
                                          DataCell(Text(
                                            data['description'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text(
                                            "Part",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontSize: 14),
                                          )),
                                          DataCell(Text(
                                            data['filepart'],
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text(
                                            "Link",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontSize: 14),
                                          )),
                                          DataCell(FlatButton(
                                            child: Text(
                                              data['link'] ?? "",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 16),
                                            ),
                                            onPressed: () async {
                                              await launch(data['link']);
                                            },
                                          )),
                                        ]),
                                        if (data['path'] != 'not found')
                                          DataRow(cells: [
                                            DataCell(Text(
                                              "",
                                              style: TextStyle(
                                                  color: AppTheme.appColor,
                                                  fontSize: 14),
                                            )),
                                            DataCell(
                                              FlatButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                viewVideoPage(data[
                                                                    'path'])));
                                                  },
                                                  child: Text(
                                                    data['fileHight'],
                                                    style: TextStyle(
                                                        color: Colors.blue,
                                                        fontSize: 16),
                                                  )),
                                            ),
                                            /*DataCell(FlatButton(
                                          child: Text("View",
                                            style: TextStyle(color: Colors.blue, fontSize: 16),
                                          )),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  new MaterialPageRoute(
                                                      builder: (context) => VideoPlayerApp(data["path"])));
                                            }
                                        ),*/
                                          ]),
                                      ],
                                      headingRowHeight: 0,
                                      horizontalMargin: 15,
                                    ),
                                    data['setupdownload'] == "1"
                                        ? data['attachment'] != null
                                            ? DownloadList(
                                                data['attachment']!,
                                                platform: platform,
                                                title: '',
                                              )
                                            : Container()
                                        : Container()
                                  ]),
                            )
                          ]),
                        )),
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
                        type: widget.type,
                        sectionid: widget.section,
                        Id: "",
                        Academicyear: "")));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage:
                    AssetImage('${FlavorConfig.instance.values.imagePath!}'),
              ),
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
          child: body),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(widget.type, widget.id);
            removeUserData();
            while (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
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

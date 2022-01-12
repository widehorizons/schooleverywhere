import 'package:dio/dio.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Networking/Futures.dart';
import '../Pages/DownloadList.dart';
import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import 'AssignmentReplyPageFromStaff.dart';
import 'package:schooleverywhere/config/flavor_config.dart';

class StudentReplyAssignmentsFromStaffContent extends StatefulWidget {
  dynamic id;
  StudentReplyAssignmentsFromStaffContent(this.id);
  @override
  State<StatefulWidget> createState() {
    return new _StudentReplyAssignmentsFromStaffContentState();
  }
}

class _StudentReplyAssignmentsFromStaffContentState
    extends State<StudentReplyAssignmentsFromStaffContent> {
  Map DataRec = new Map();
  dynamic attachment;
  bool viewReplayStatus = false;
  initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    EventObject eventObject =
        await getStudentReplyAssignmentsContentFromStaff(widget.id.toString());
    if (eventObject.success!) {
      setState(() {
        Map? DataRec = eventObject.object as Map?;
      });
    } else {
      String? msg = eventObject.object as String?;
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
                builder: (context) => AssignmentReplyPageFromStaff(widget.id)));
      },
      padding: EdgeInsets.all(12),
      color: AppTheme.appColor,
      child: Text('Reply', style: TextStyle(color: Colors.white)),
    ));

    final body = Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.width * 0.03),
      child: Center(
        child: FutureBuilder(
          future:
              getStudentReplyAssignmentsContentFromStaff(widget.id.toString()),
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
                return ListView(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: new EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.01),
                      child: Column(
                          //mainAxisSize: MainAxisSize.max,
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
                                        color: AppTheme.appColor, fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    mapValue!['data']['Date'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  )),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text(
                                    "Name",
                                    style: TextStyle(
                                        color: AppTheme.appColor, fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    mapValue['data']['Name'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  )),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text(
                                    "Description",
                                    style: TextStyle(
                                        color: AppTheme.appColor, fontSize: 14),
                                  )),
                                  DataCell(Text(
                                    mapValue['data']['Comment'],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 14),
                                  ))
                                ]),
                              ],
                              headingRowHeight: 0,
                              horizontalMargin: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .5,
                              child: replyButton,
                            ),
                            (mapValue['data']['File'] != 'not found')
                                ? DownloadList(
                                    mapValue['data']['File'],
                                    platform: platform,
                                    title: '',
                                  )
                                : Container(),
                          ]),
                    )
                    // ),
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

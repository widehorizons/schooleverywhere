import 'dart:async';
import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Messages.dart';
import '../Networking/Futures.dart';
import '../Pages/DownloadList.dart';
import '../Pages/HomePage.dart';
import '../Student/MailInboxReplyPage.dart';
import '../Style/theme.dart';
import '../SharedPreferences/Prefs.dart';
import '../Pages/LoginPage.dart';

class MailInboxContentsPage extends StatefulWidget {
  final String msgId;
  final String type;
  final String id;
  final String section;
  final String childId;
  MailInboxContentsPage(
      this.msgId, this.type, this.id, this.section, this.childId);
  @override
  State<StatefulWidget> createState() {
    return new _MailInboxContentsPageState(this.msgId);
  }
}

class _MailInboxContentsPageState extends State<MailInboxContentsPage> {
  _MailInboxContentsPageState(this.msgId);
  final String msgId;
  late Messages msg;
  bool isLoading = true;
  String? errorMsg;
  Map data = new Map();
  final loadingSign = Padding(
    padding: EdgeInsets.symmetric(vertical: 16.0),
    child: SpinKitPouringHourGlass(
      color: AppTheme.appColor,
    ),
  );
  Future<void> syncMessages() async {
    setState(() {
      isLoading = true;
    });
    EventObject eventObject =
        await getMessageDetails(msgId, widget.section, "I");
    if (eventObject.success!) {
      Map? data = eventObject.object as Map?;
      print("attachments: >>" + data!['attachment'].toString());
      setState(() {
        isLoading = false;
      });

      msg = Messages(
          data['id'].toString(),
          data['datemsg'].toString(),
          data['see'].toString(),
          data['sender'].toString(),
          data['messageTitle'].toString(),
          data['messageBody'].toString(),
          data['messageBodyPart'].toString(),
          data['attachment'],
          data['messageReplayStatus'].toString(),
          data['senderName'].toString(),
          data['path'].toString());
      setState(() {
        data;
        print("id2m" + msg.messageReplayStatus.toString());
        print("attach" + data['attachment'].toString());
        if (msg.messageReplayStatus.toString() == "true") {
          vmessageReplayStatus = true;
        }
        insertSeenMessageMailBox();

        isLoading = false;
      });
    } else {
      String? msg = eventObject.object as String?;
      errorMsg = msg!;
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

  bool vmessageReplayStatus = false;
  bool messageReplayStatus = false;
  var commentWidgets = <Widget>[];
  var progress;
  bool downloading = false;

  @override
  void initState() {
    super.initState();
    syncMessages();
  }

  Future<void> insertSeenMessageMailBox() async {
    EventObject objectEventMessageData = await seenMessageMailBox(data['id']);
    if (objectEventMessageData.success = false) {
      String? msg = objectEventMessageData.object as String?;
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
                    MailInboxReplyPage(msg.id, msg.messageTitle, widget.type)));
      },
      padding: EdgeInsets.all(12),
      color: AppTheme.appColor,
      child: Text('Reply', style: TextStyle(color: Colors.white)),
    ));
    final body = Center(
      child: isLoading
          ? loadingSign
          : msg == null
              ? Text(errorMsg!)
              : Column(
                  children: <Widget>[
                    new Expanded(
                        flex: 1,
                        child: SingleChildScrollView(
                          child: Stack(children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height,
                              padding: new EdgeInsets.all(3.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    DataTable(
                                      columns: [
                                        DataColumn(label: Text("hh")),
                                        DataColumn(label: Text("mm"))
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
                                            msg.date,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          )),
                                        ]),
                                        DataRow(cells: [
                                          DataCell(Text(
                                            "From",
                                            style: TextStyle(
                                                color: AppTheme.appColor,
                                                fontSize: 14),
                                          )),
                                          DataCell(Text(
                                            msg.senderName,
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
                                            msg.messageTitle,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14),
                                          ))
                                        ]),
                                      ],
                                      headingRowHeight: 0,
                                      horizontalMargin: 15,
                                    ),
                                    new Expanded(
                                        flex: 1,
                                        child: SingleChildScrollView(
                                          child: Container(
                                            margin: EdgeInsets.all(15.0),
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(msg.messageBody,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14)),
                                          ),
                                        )),
                                    Container(
                                      child: msg.attachment.isEmpty
                                          ? Container()
                                          : DownloadList(msg.attachment,
                                              platform: platform,
                                              title: 'Attachments'),
                                    ),
                                    vmessageReplayStatus
                                        ? SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .5,
                                            child: replyButton,
                                          )
                                        : Container(),
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
            Text(SCHOOL_NAME),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(
                    builder: (context) => HomePage(
                        type: widget.type,
                        sectionid: widget.section,
                        Id: widget.childId,
                        Academicyear: "")));
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage('img/logo.png'),
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

class Attachments {
  final String name;

  Attachments(this.name);
}

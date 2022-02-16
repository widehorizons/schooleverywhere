import 'dart:async';
import '../Modules/Management.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Messages.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../Student/MailInboxCompose.dart';
import '../Style/theme.dart';

import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';
import 'MailInboxContentsPage.dart';
import 'SendMailInbox.dart';

class MailInboxPage extends StatefulWidget {
  final String type;

  MailInboxPage(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _MailInboxPageState();
  }
}

class _MailInboxPageState extends State<MailInboxPage> {
  Staff? loggedStaff;
  Parent? loggedParent;
  Student? loggedStudent;
  Management? loggedManagement;
  bool isLoading = false;
  String? userAcademicYear, userId, userType, userSection, childId;
  List<dynamic> listOfMessage = [];
  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childId = loggedParent!.regno;

      print("userAcademicYear: " + userAcademicYear.toString());
      print("userSection: " + userSection.toString());
      print("userId: " + userId.toString());
      print("userType: " + userType.toString());
      print("childId: " + childId.toString());
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childId = loggedStudent!.id;
    } else if (widget.type == MANAGEMENT_TYPE) {
      loggedManagement = await getUserData() as Management;
      userAcademicYear = loggedManagement!.academicYear;
      userSection = loggedManagement!.section;
      userId = loggedManagement!.id;
      userType = loggedManagement!.type;
      childId = loggedManagement!.id;
    } else {
      loggedStaff = await getUserData() as Staff;
      userAcademicYear = loggedStaff!.academicYear;
      userSection = loggedStaff!.section;
      userId = loggedStaff!.id;
      userType = loggedStaff!.type;
      childId = loggedStaff!.id;
    }
    _getMessages();
  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData =
        await getMailStudent(userId!, userAcademicYear!);
    if (objectEventMessageData.success!) {
      Map messageData = objectEventMessageData.object as Map;
      List<dynamic> listOfColumns = messageData['data'];
      print(messageData['data'].toString());
      setState(() {
        listOfMessage = listOfColumns;
      });
    } else {
      String? msg = objectEventMessageData.object as String;
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

  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => MailInboxCompose(userType!, userId!)));

          break;
        case 1:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => SendMailInbox(userType!)));

          break;
        case 2:
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => MailInboxPage(userType!)));

          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final showData = Center(
        child: ListView(
      children: <Widget>[
        DataTable(
          columns: [
            DataColumn(
                label: Text(
              "Sender Name",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
              overflow: TextOverflow.ellipsis,
            )),
            DataColumn(
                label: Text(
              "Title",
              style: TextStyle(color: AppTheme.appColor, fontSize: 16),
            )),
          ],
          rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                    ((element) => DataRow(
                          cells: <DataCell>[
                            DataCell(Text(
                              element["senderName"],
                              style:
                                  TextStyle(color: Colors.black, fontSize: 14),
                            )),
                            //Extracting from Map element the value
                            DataCell(
                              Text(
                                element["messageTitle"],
                                style: TextStyle(
                                    color: Colors.lightBlue, fontSize: 14),
                              ),
                              onTap: () {
                                print("elid" +
                                    element["id"] +
                                    "userType" +
                                    userType! +
                                    "userSection" +
                                    userSection! +
                                    "childId" +
                                    childId!);
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            MailInboxContentsPage(
                                                element["id"],
                                                userType!,
                                                userId!,
                                                userSection!,
                                                childId!)));
                              },
                            ),
                          ],
                        )),
                  )
                  .toList(),
        )
      ],
    ));
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
                        type: userType!,
                        sectionid: userSection!,
                        Id: childId!,
                        Academicyear: userAcademicYear!)));
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
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('img/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0), child: showData),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.add_comment),
            label: 'Compose',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.done_outline),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.email),
            label: 'Recieve',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.appColor,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(userType!, userId!);
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

class DetailPage extends StatelessWidget {
  final Messages msg;

  DetailPage(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: Text(msg.messageTitle),
    ));
  }
}

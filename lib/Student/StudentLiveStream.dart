import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Messages.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../Style/theme.dart';

import '../Pages/LoginPage.dart';
import '../SharedPreferences/Prefs.dart';

class StudentLiveStream extends StatefulWidget {
  final String type;

  const StudentLiveStream(this.type);

  @override
  State<StatefulWidget> createState() {
    return new _StudentLiveStreamState();
  }
}

class _StudentLiveStreamState extends State<StudentLiveStream> {

   Parent? loggedParent;
   Student? loggedStudent;


   String? userAcademicYear,userId,userType,userSection,childId,userstage,usergrade,userclass,usersemester;
  List<dynamic>  listOfMessage = [];
  @override
  void initState() {
    super.initState();
    getLoggedInUser();
  }
  Future<void> getLoggedInUser() async {
    if(widget.type == PARENT_TYPE){
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childId=loggedParent!.regno;
      userstage=loggedParent!.stage;
      usergrade=loggedParent!.grade;
      userclass=loggedParent!.classChild;
      usersemester=loggedParent!.semester;
    }
    else if(widget.type == STUDENT_TYPE){
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childId=loggedStudent!.id;
      userstage=loggedStudent!.stage;
      usergrade=loggedStudent!.grade;
      userclass=loggedStudent!.studentClass;
      usersemester=loggedStudent!.semester;
    }

    _getMessages();
  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData = await getLiveStream(
        childId!, userAcademicYear!,userSection!,userstage!,usergrade!,userclass!,usersemester!);
    if (objectEventMessageData.success!) {
      Map? messageData = objectEventMessageData.object as Map?;
      List<dynamic> listOfColumns = messageData!['data'];
      setState(() {
        listOfMessage = listOfColumns;
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    final showData = Center(
        child: ListView(
          children: <Widget>[
            DataTable(
              columns: [
                DataColumn(label: Text("Teacher",style: TextStyle(color: AppTheme.appColor, fontSize: 16),overflow: TextOverflow.ellipsis,)),
                DataColumn(label: Text("Subject",style: TextStyle(color: AppTheme.appColor, fontSize: 16),overflow: TextOverflow.ellipsis,)),
                DataColumn(label: Text("Live",style: TextStyle(color: AppTheme.appColor, fontSize: 16),)),
              ],
              rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                ((element) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(element["teacher"],style: TextStyle(color: Colors.black, fontSize: 14),)),
                    DataCell(Text(element["subject"],style: TextStyle(color: Colors.black, fontSize: 14),)),
                    //Extracting from Map element the value
                    DataCell(
                      Text("Channel",style: TextStyle(color: Colors.lightBlue, fontSize: 14),),
                      onTap: () async { await launch(element["live"]);
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
                Navigator.of(context).pushReplacement(
                    new  MaterialPageRoute(builder: (context) => HomePage(type: userType!, sectionid: userSection!, Id: childId!, Academicyear: userAcademicYear!)));
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
        child:
        Padding(padding: EdgeInsets.symmetric(vertical: 10.0), child: showData),
      ),

      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: (){
            logOut(userType!,userId!);
            removeUserData();
            while(Navigator.canPop(context)){
              Navigator.pop(context);
            }
            Navigator.of(context).pushReplacement(
                new  MaterialPageRoute(builder: (context) => LoginPage()));
          },
          child:Icon(FontAwesomeIcons.doorOpen,color: AppTheme.floatingButtonColor, size: 30,),
          backgroundColor: Colors.transparent,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0),)

      ),
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

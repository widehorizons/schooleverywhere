import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

class StudentTopicsCoveredReadComment extends StatefulWidget {
  final String message;
  final String type;
  const StudentTopicsCoveredReadComment(this.message,this.type);

  @override
  State<StatefulWidget> createState() {
    return new _StudentTopicsCoveredReadCommentState();
  }
}

class _StudentTopicsCoveredReadCommentState extends State<StudentTopicsCoveredReadComment> {
   Parent? loggedParent;
   Student? loggedStudent;
  Map datesOptions = new Map();
  Map subjectOptions = new Map();
  Map divisions = new Map();
   String? dateValue,userSection,userAcademicYear,userStage,userGrade,userId,userType,userClass,childern;
  bool dateSelected = false;
  List<dynamic> previousTopicsCovered = [];
  initState() {
    super.initState();
    getLoggedInUser();
  }

  Future<void> getLoggedInUser() async {
    if(widget.type == PARENT_TYPE){
      loggedParent = await getUserData() as Parent;
      userSection = loggedParent!.childeSectionSelected;
      userAcademicYear = loggedParent!.academicYear;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      userClass= loggedParent!.classChild;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      childern=loggedParent!.regno;
    }
    else {
      loggedStudent = await getUserData() as Student;
      userSection = loggedStudent!.section;
      userAcademicYear = loggedStudent!.academicYear;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userClass= loggedStudent!.studentClass;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      childern=loggedStudent!.id;
    }

  }

  @override
  Widget build(BuildContext context) {

 final showData=Center(child: ListView(
   children: <Widget>[
     Text(widget.message,style: TextStyle(color: AppTheme.appColor, fontSize: 16),)
   ],
 ));


    final body = Center(
    child: Column(
    children: <Widget>[
    Padding(
    padding: EdgeInsets.only(top: 10),
    ),

      showData,
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
             Navigator.of(context).pushReplacement(
                 new  MaterialPageRoute(builder: (context) => HomePage(type: userType!, sectionid: userSection!, Id: childern!, Academicyear: userAcademicYear!)));
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
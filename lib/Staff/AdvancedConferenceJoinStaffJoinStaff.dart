import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Networking/ApiConstants.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Staff.dart';
import '../Networking/Futures.dart';
import '../Pages/HomePage.dart';
import '../SharedPreferences/Prefs.dart';
import '../Style/theme.dart';
import '../Pages/LoginPage.dart';


class AdvancedConferenceJoinStaffJoinStaff extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _AdvancedConferenceJoinStaffJoinStaffState();
  }
}

class _AdvancedConferenceJoinStaffJoinStaffState extends State<AdvancedConferenceJoinStaffJoinStaff> {

  Staff? loggedStaff;

  String StaffSection = "Loading...";
  String StaffSectionId = "";
  String StaffStage = "Loading...";
  String StaffStageId = "";
  String StaffGrade = "Loading...";
  String StaffGradeId = "";
  String StaffSemester = "Loading...";
  String StaffSemesterId = "";
  String StaffClass = "Loading...";
  String StaffClassId = "";
  String StaffSubject = "Loading...";
  String StaffSubjectId = "";
  String academicYearValue ="Loading...";
  String? staffid;
  bool isLoading = false, checkSync =true;
  String? urlConference;
  int? JoinStaff;
  String? IdRowJoin;
  List<dynamic>  listOfMessage = [];
  @override
  void initState() {
    super.initState();
    getLoggedStaff();
  }

  Future<void> getUrlConference()async{
    EventObject objectEvent = new EventObject();
    objectEvent = await getUrlConferenceData(StaffSectionId);
    // print("kkkkkkk" + objectEvent.object);
    Map? data = objectEvent.object as Map?;
    if (objectEvent.success!) {
      urlConference = data!['conference'];
      print( data['conference']);
    }

  }
  Future<void> getLoggedStaff() async {
    loggedStaff = await getUserData() as Staff;
    StaffSection = loggedStaff!.sectionName!;
    StaffSectionId = loggedStaff!.section!;
    StaffStage = loggedStaff!.stageName!;
    StaffStageId = loggedStaff!.stage!;
    StaffGrade = loggedStaff!.gradeName!;
    StaffGradeId = loggedStaff!.grade!;
    StaffSemester = loggedStaff!.semesterName!;
    StaffSemesterId = loggedStaff!.semester!;
    StaffClass = loggedStaff!.staffClassName!;
    StaffClassId = loggedStaff!.staffClass!;
    StaffSubject = loggedStaff!.subjectName!;
    StaffSubjectId = loggedStaff!.subject!;
    staffid=loggedStaff!.id;
    academicYearValue = loggedStaff!.academicYear!;
    getUrlConference();
    _getMessages();


  }

  Future<void> _getMessages() async {
    EventObject objectEventMessageData = await getAdvancedConferenceStaffData();
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
                DataColumn(label: Text("Staff Name",style: TextStyle(color: AppTheme.appColor, fontSize: 16),overflow: TextOverflow.ellipsis,)),

                DataColumn(label: Text("Start",style: TextStyle(color: AppTheme.appColor, fontSize: 16),)),
                DataColumn(label: Text("Join",style: TextStyle(color: AppTheme.appColor, fontSize: 16),)),
              ],
              rows:
              listOfMessage // Loops through dataColumnText, each iteration assigning the value to element
                  .map(
                ((element) => DataRow(
                  cells: <DataCell>[
                    DataCell(Text(element["staffname"],style: TextStyle(color: Colors.black, fontSize: 14),)),

                    DataCell(Text(element["startdate"],style: TextStyle(color: Colors.black, fontSize: 14),)),

                    //Extracting from Map element the value
                    DataCell(
                      Text("Conference",style: TextStyle(color: Colors.lightBlue, fontSize: 14),),
                      onTap: () async {
//                        _joinMeeting(ApiConstants.ConferenceSchoolName+"Schooleverywhere"+element["staffid"]);
//                        SetConferenceJoinId(element["id"]);
//                        JoinConferenceStatus(element["id"]);
                        await launch(
                            ApiConstants.BASE_URL+"staff/joinStaffAdvancedConferenceStaffOne.php?s="+element["staffid"]+"&myid="+staffid!+"&i="+element["id"]+"&section="+StaffSectionId);


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
                        type: loggedStaff!.type!,
                        sectionid: loggedStaff!.section!,
                        Id: loggedStaff!.id!,
                        Academicyear: loggedStaff!.academicYear!)));
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
            logOut(loggedStaff!.type!, loggedStaff!.id!);
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



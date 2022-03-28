// import 'package:get_version/get_version.dart';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:schooleverywhere/Staff/UploadedTimeTable.dart';
import 'package:schooleverywhere/config/flavor_config.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Constants/StringConstants.dart';
import '../Management/AdvancedPage.dart';
import '../Management/AdvancedStaffConferenceMangementPage.dart';
import '../Management/ByClassPage.dart';
import '../Management/BySelect.dart';
import '../Management/SMSPage.dart';
import '../Management/StaffConferenceMangementPage.dart';
import '../Management/StaffMail.dart';
import '../Management/StudentAttendance.dart';
import '../Management/StudentConferenceMangementPage.dart';
import '../Management/cambridgeAdvancedConference.dart';
import '../Management/cambridgeConference.dart';
import '../Modules/EventObject.dart';
import '../Modules/Management.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Networking/ApiConstants.dart';
import '../Networking/Futures.dart';
import '../Networking/ReportCard.dart';
import '../SharedPreferences/Prefs.dart';
import '../Staff/AddLessonsByClass.dart';
import '../Staff/AdvancedConferenceJoinStaffJoinStaff.dart';
import '../Staff/AdvancedConferenceStaffJoinStaff.dart';
import '../Staff/AdvancedConferenceStaffJoinStaffRecorded.dart';
import '../Staff/AdvancedStaffConferencePage.dart';
import '../Staff/AdvancedStudentConferencePage.dart';
import '../Staff/Assignments.dart';
import '../Staff/CambridgeAdvancedStudentConferencePage.dart';
import '../Staff/CambridgeStudentConferencePage.dart';
import '../Staff/ConferenceStaffJoinStaff.dart';
import '../Staff/ConferenceStaffstaff.dart';
import '../Staff/LeaveRequest.dart';
import '../Staff/LiveStream.dart';
import '../Staff/MaintenanceLocation.dart';
import '../Staff/Memo.dart';
import '../Staff/ProgressReportStaffIndex.dart';
import '../Staff/SendToClass.dart';
import '../Staff/StaffConferencePage.dart';
import '../Staff/StudentConferencePage.dart';
import '../Staff/TakeAttendance.dart';
import '../Staff/TopicsCovered.dart';
import '../Staff/UnPaidLeaveRequest.dart';
import '../Staff/UnPaidVacationRequest.dart';
import '../Staff/VacationRequest.dart';
import '../Student/AdvancedConferenceStudent.dart';
import '../Student/Attendance.dart';
import '../Student/AutomaticTimeTable.dart';
import '../Student/CambridgeConferenceStudentSession.dart';
import '../Student/CambridgeDegree.dart';
import '../Student/CambridgeDropSubjects.dart';
import '../Student/CambridgeRegisterationID.dart';
import '../Student/CambridgeRegistrationConfirmation.dart';
import '../Student/CambrigeRegistration.dart';
import '../Student/ConferenceStudent.dart';
import '../Student/GeolocationHome.dart';
import '../Student/MailInboxPage.dart';
import '../Student/ProgressReportIndex.dart';
import '../Student/ProgressReportIndex2.dart';
import '../Student/ReceiveFromTeacher.dart';
import '../Student/ReportCardIndex.dart';
import '../Student/ReportCardIndex4.dart';
import '../Student/ReportCardIndex4BySubDivision.dart';
import '../Student/ReportCardIndex4LandScape.dart';
import '../Student/ReportCardIndex4WithBorder.dart';
import '../Student/StudentAssignments.dart';
import '../Student/StudentBus.dart';
import '../Student/StudentFees.dart';
import '../Student/StudentLiveStream.dart';
import '../Student/StudentTopicsCovered.dart';
import '../Student/TimeTable.dart';
import '../Student/ViewLessons.dart';
import '../Student/ViewMemo.dart';
import '../Style/theme.dart';
import '../widget/updateDialog.dart';
import 'ChangeLogin.dart';
import 'LoginPage.dart';
import 'Meeting.dart';

class HomePage extends StatefulWidget {
  final String type;
  final String sectionid;
  final String Id;
  final String Academicyear;

  HomePage({
    required this.type,
    required this.sectionid,
    required this.Id,
    required this.Academicyear,
  });

  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

// initState() {
//   super.initState();
//
// // } print(type);
//
class _HomePageState extends State<HomePage> {
  //  String? typeOptions;
  // String? typename;
  String? checkVersionCode, _projectCode;

  Future<void> getTypeProgressReportAlt() async {
    EventObject objectEventtype =
        await typeProgressReportAlt(widget.sectionid, widget.Academicyear);
    if (objectEventtype.success!) {
      String? toto = objectEventtype.object as String?;
      setState(() {
        String typeOptions = toto!;
      });
      print("Data1: " + toto.toString());
    } else {}
  }

  Future<dynamic> homePageAllPages(String linkName, String type) async {
    if (type == STAFF_TYPE) {
      if (linkName == "Send To Class") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SendToClass()),
        );
      } else if (linkName == "Topics Covered") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TopicsCovered()),
        );
      } else if (linkName == "Mail Box" || linkName == "New Mailbox") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MailInboxPage(type)),
        );
      } else if (linkName == "Change Login") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangeLogin(type)),
        );
      } else if (linkName == "Time Table") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimeTable(widget.type)),
        );
      } else if (linkName == "Automatic Timetable") {
        /* return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AutomaticTimeTable(widget.type)),
        );*/
      } else if (linkName == "Student Attendance") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TakeAttendance()),
        );
      } else if (linkName == "Assignments") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Assignments()),
        );
      } else if (linkName == "Calender") {
        await launch(ApiConstants.CALENDER_API +
            "?year=" +
            widget.Academicyear +
            "&section=" +
            widget.sectionid);
      } else if (linkName == "Meeting") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Meeting(widget.type)),
        );
      } else if (linkName == "Add Lessons By Class") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddLessonsByClass()),
        );
      } else if (linkName == "Maintenance-Location") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MaintenanceLocation()),
        );
      } else if (linkName == "Progress Report") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProgressReportStaffIndex()),
        );
      } else if (linkName == "Leave Request") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LeaveRequest()),
        );
      } else if (linkName == "Unpaid Leave Request") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UnPaidLeaveRequest()),
        );
      } else if (linkName == "Vacation Request") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VacationRequest()),
        );
      } else if (linkName == "Unpaid Vacation Request") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UnPaidVacationRequest()),
        );
      } else if (linkName == "Live Stream") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LiveStream()),
        );
      } else if (linkName == "Progress") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //ProgressReport()),
//        );
      } else if (linkName == "Memo") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Memo()),
        );
      } else if (linkName == "Student Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentConferencePage(widget.type,
                  widget.sectionid, widget.Id, widget.Academicyear)),
        );
      } else if (linkName == "Cambridge Advanced Student Conference") {
        int typePage = 3;
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CambridgeAdvancedStudentConferencePage(
                  widget.type,
                  widget.sectionid,
                  widget.Id,
                  widget.Academicyear)),
        );
      } else if (linkName == "Advanced Student Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvancedStudentConferencePage(widget.type,
                  widget.sectionid, widget.Id, widget.Academicyear)),
        );
      } else if (linkName == "Cambridge Student Conference") {
        int typePage = 1;
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CambridgeStudentConferencePage(widget.type,
                  widget.sectionid, widget.Id, widget.Academicyear)),
        );
      } else if (linkName == "Staff Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StaffConferencePage(widget.type,
                  widget.sectionid, widget.Id, widget.Academicyear)),
        );
      } else if (linkName == "Advanced Staff Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvancedStaffConferencePage(widget.type,
                  widget.sectionid, widget.Id, widget.Academicyear)),
        );
      } else if (linkName == "Staff Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConferenceStaffstaff()),
        );
      } else if (linkName == "Join Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConferenceStaffJoinStaff()),
        );
      } else if (linkName == "Advanced Staff Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvancedConferenceStaffJoinStaff()),
        );
      } else if (linkName == "Advanced Join Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvancedConferenceJoinStaffJoinStaff()),
        );
      } else if (linkName == "Staff Recorded Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvancedConferenceStaffJoinStaffRecorded()),
        );
      } else if (linkName == "Other Staff Recorded Conference") {
        await launch(ApiConstants.BASE_URL +
            "staff/StaffAdvancedConferenceStaffRecorded.php");
      }
    } else if (type == STUDENT_TYPE || type == PARENT_TYPE) {
      print("from home page");

      if (linkName == "Receive From Teacher") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReceiveFromTeacher(widget.type)),
        );
      } else if (linkName == "Live Streaming") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentLiveStream(widget.type)),
        );
      } else if (linkName == "Print Topics Covered") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentTopicsCovered(widget.type)),
        );
      } else if (linkName == "Mail Box" || linkName == "New Mailbox") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MailInboxPage(widget.type)),
        );
      } else if (linkName == "Time Table") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TimeTable(widget.type)),
        );
      } else if (linkName == "Uploaded Time Table") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadedTimeTable(
                    type: widget.type,
                  )),
        );
      } else if (linkName == "Automatic Time Table") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AutomaticTimeTable(widget.type)),
        );
      } else if (linkName == "Progress Report") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProgressReportIndex(widget.type, "one")),
        );
      } else if (linkName == "Progress Report2") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProgressReportIndex2(widget.type)),
        );
      } else if (linkName == "Progress Report Alt") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProgressReportIndex(widget.type, "two")),
        );
      } else if (linkName == "Change Login") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangeLogin(type)),
        );
      } else if (linkName == "Uploads To Students") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //UploadsToStudents()),
//        );
      } else if (linkName == "Calender") {
        await launch(ApiConstants.CALENDER_API +
            "?year=" +
            widget.Academicyear +
            "&section=" +
            widget.sectionid);
      } else if (linkName == "Students class") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //Studentsclass()),
//        );
      } else if (linkName == "Revision") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //Revision()),
//        );
      } else if (linkName == "Lessons") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewLessons(widget.type)),
        );
      } else if (linkName == "Change Language") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //ChangeLanguage()),
//        );
      } else if (linkName == "Meeting") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Meeting(widget.type)),
        );
      } else if (linkName == "Assignments") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentAssignments(widget.type)),
        );
      } else if (linkName == "Attendance") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Attendance(widget.type)),
        );
      } else if (linkName == "School Year") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //School Year()),
//        );
      } else if (linkName == "Profile") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //Profile()),
//        );
      } else if (linkName == "Report Card 1") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportCardIndex(widget.type)),
        );
      } else if (linkName == "Report Card 2") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_TWO_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!); //        return  Navigator.push(
      } else if (linkName == "Report Card 3") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_THERE_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!); //        return  Navigator.push(
      } else if (linkName == "Report Card 4") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportCardIndex4(widget.type)),
        );
      } else if (linkName == "Report Card 4 By SubDivision") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportCardIndex4BySubDivision(widget.type)),
        );
      } else if (linkName == "Report Card 4(With Border)") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportCardIndex4WithBorder(widget.type)),
        );
      } else if (linkName == "Report Card 4(Land Scape)") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportCardIndex4LandScape(widget.type)),
        );
      } else if (linkName == "Report Card 5") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_FIVE_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 5(With Border)") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_FIVE_WITH_BORDER_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 5(Land Scape)") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_FIVE_LAND_SCAPE_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 6") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_SIX_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 6(With Border)") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_SIX_WITH_BORDER_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 6(Land Scape)") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_SIX_LAND_SCAPE_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 6(Landscape With Border)") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_SIX_LAND_SCAPE_BORDER_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 7") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_SEVEN_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 8") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_EIGHT_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 9") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_NINE_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 10") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_TEN_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 11") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_ELEVEN_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 12") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_TWELVE_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Report Card 13") {
        await launch(ReportCard.SCHOOL_REPORT_CARD_THIRTEEN_LINK +
            "?myyears=" +
            userAcademicYear! +
            "&regno=" +
            userRegno! +
            "&sections=" +
            userSection! +
            "&semister=" +
            userSemester! +
            "&stage=" +
            userStage! +
            "&grade=" +
            userGrade! +
            "&class=" +
            userClass!);
      } else if (linkName == "Geolocation") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GeolocationHome()),
        );
      } else if (linkName == "Fees") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentFees(widget.type)),
        );
      } else if (linkName == "Bus") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentBus(widget.type)),
        );
      } else if (linkName == "Memo") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ViewMemo(widget.type)),
        );
      } else if (linkName == "Exam Schedule") {
//        return  Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//            //ExamSchedule()),
//        );
      } else if (linkName == "Cambridge Registration") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CambrigeRegistration(widget.type)),
        );
      } else if (linkName == "Drop Subjects") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CambridgeDropSubjects(widget.type)),
        );
      } else if (linkName == "Cambridge Degree") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CambridgeDegree(widget.type)),
        );
      } else if (linkName == "Cambridge Registeration ID") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CambridgeRegisterationID(widget.type)),
        );
      } else if (linkName == "Cambridge Registration Confirmation") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CambridgeRegistrationConfirmation(widget.type)),
        );
      } else if (linkName == "Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConferenceStudent(widget.type)),
        );
      } else if (linkName == "Advanced Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvancedConferenceStudent(widget.type)),
        );
      } else if (linkName == "Cambridge conference") {
        int typePage = 1;
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CambridgeConferenceStudentSession(widget.type, typePage)),
        );
      } else if (linkName == "Advanced Conference Cambridge") {
        int typePage = 2;
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  CambridgeConferenceStudentSession(widget.type, typePage)),
        );
      }
    } else if (type == MANAGEMENT_TYPE) {
      if (linkName == "Mail Box") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MailInboxPage(widget.type)),
        );
      } else if (linkName == "Uploaded Time Table") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UploadedTimeTable(
                    type: widget.type,
                  )),
        );
      } else if (linkName == "By Select") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BySelectPage()),
        );
      } else if (linkName == "By Class") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ByClassPage()),
        );
      } else if (linkName == "Advanced") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AdvancedPage()),
        );
      } else if (linkName == "SMS") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SMSPage()),
        );
      } else if (linkName == "Student Attendance") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentAttendance()),
        );
      } else if (linkName == "Staff Mail") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StaffMail()),
        );
      } else if (linkName == "Student Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StudentConferenceMangementPage(widget.type,
                  widget.sectionid, widget.Id, widget.Academicyear)),
        );
      } else if (linkName == "Staff Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StaffConferenceMangementPage(widget.type,
                  widget.sectionid, widget.Id, widget.Academicyear)),
        );
      } else if (linkName == "Advanced Staff Confernce") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdvancedStaffConferenceMangementPage(
                  widget.type,
                  widget.sectionid,
                  widget.Id,
                  widget.Academicyear)),
        );
      } else if (linkName == "Cambridge Staff Conference") {
        return Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => cambridgeConference()),
        );
      } else if (linkName == "Cambridge Advanced Staff Confernce") {
        return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => cambridgeAdvancedConference()),
        );
      }
    }
  }

  Staff? loggedStaff;
  Parent? loggedParent;
  Student? loggedStudent;
  Management? loggedManagement;
  bool isLoading = false;
  String? userAcademicYear,
      userId,
      userType,
      userSection,
      userStage,
      userGrade,
      userSemester,
      userClass,
      userRegno,
      userSupervisor;
  bool checkSupervisor = false;

  @override
  initState() {
    super.initState();
    initPlatformState();
    getLoggedInUser();
    getTypeProgressReportAlt();
  }

  Future<void> getLoggedInUser() async {
    if (widget.type == PARENT_TYPE) {
      loggedParent = await getUserData() as Parent;
      userAcademicYear = loggedParent!.academicYear;
      userSection = loggedParent!.childeSectionSelected;
      userStage = loggedParent!.stage;
      userGrade = loggedParent!.grade;
      userId = loggedParent!.id;
      userType = loggedParent!.type;
      userSemester = loggedParent!.semester;
      userClass = loggedParent!.classChild;
      userRegno = loggedParent!.regno;
    } else if (widget.type == STUDENT_TYPE) {
      loggedStudent = await getUserData() as Student;
      userAcademicYear = loggedStudent!.academicYear;
      userSection = loggedStudent!.section;
      userStage = loggedStudent!.stage;
      userGrade = loggedStudent!.grade;
      userId = loggedStudent!.id;
      userType = loggedStudent!.type;
      userSemester = loggedStudent!.semester;
      userClass = loggedStudent!.studentClass;
      userRegno = loggedStudent!.id;
    } else if (widget.type == MANAGEMENT_TYPE) {
      loggedManagement = await getUserData() as Management;
      userAcademicYear = loggedManagement!.academicYear;
      userSection = loggedManagement!.section;
      userId = loggedManagement!.id;
      userType = loggedManagement!.type;
    } else {
      loggedStaff = await getUserData() as Staff;
      userAcademicYear = loggedStaff!.academicYear;
      userSection = loggedStaff!.section;
      userId = loggedStaff!.id;
      userType = loggedStaff!.type;
      userSupervisor = loggedStaff!.supervisorId;
      checkSupervisor = loggedStaff!.supervisorStaff!;
      print("userSupervisor" + userSupervisor.toString());
    }
  }

  initPlatformState() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String? projectCode;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      projectCode = await packageInfo.buildNumber;
    } catch (e) {
      projectCode;
    }
    if (!mounted) return;

    setState(() {
      _projectCode = projectCode;
    });
  }

  Widget build(BuildContext context) {
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
          child: ((widget.type != STAFF_TYPE) ||
                  ((widget.type == STAFF_TYPE) && (userSupervisor != null)))
              ? FutureBuilder(
                  future: homePageOptions(
                      widget.type,
                      widget.sectionid,
                      widget.Id,
                      widget.Academicyear,
                      checkSupervisor,
                      userSupervisor),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    EventObject? objectEvent = snapshot.data;
                    if (!snapshot.hasData) {
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: SpinKitPouringHourGlass(
                            color: AppTheme.appColor,
                          ),
                        ),
                      );
                    } else if (objectEvent!.success == false) {
                      String? msg = objectEvent.object as String?;
                      return Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text(msg.toString()),
                        ),
                      );
                    } else {
                      print("SNAP_SHOT_DATA: " + objectEvent.toString());
                      print("DATA_SENT: " +
                          widget.type +
                          " " +
                          widget.sectionid +
                          "ID" +
                          widget.Id +
                          " " +
                          widget.Academicyear);
                      Map? data = objectEvent.object as Map?;
                      print(
                          "Data Retrived here is ===> ${data!['versionCode']}");
                      if (FlavorConfig.instance.flavor == Flavor.TANTAROYAL &&
                          Platform.isAndroid) {
                        checkVersionCode = data['versionCode_andriod'];
                      } else {
                        checkVersionCode = data['versionCode'];
                      }
                      if ((checkVersionCode == null) ||
                          (checkVersionCode == _projectCode) ||
                          (_projectCode == null)) {
                        List<dynamic> y = data['page'];
                        List<Widget> PageOptions = [];
                        Map Pagearr = new Map();
                        int studCon = 0;
                        int stuconadv = 0;
                        int staffCon = 0;
                        int advstaffCon = 0;
                        int studConMan = 0;
                        int staffConMan = 0;
                        int AdvstaffConMan = 0;
                        for (int i = 0; i < y.length; i++) {
                          Pagearr[data['page'][i]] = data['url'][i];
                          if ((data['page'][i].toString() == "Conference" ||
                                  data['page'][i].toString() ==
                                      "Join Supervisour Conference") &&
                              studCon == 0 &&
                              widget.type == STAFF_TYPE) {
                            studCon++;
                            String LinkName = "Student Conference";
                            String imageUrl =
                                FlavorConfig.instance.values.baseUrl! +
                                    "staff/linksImages/conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                  "Create Conference Cambridge") ||
                              data['page'][i].toString() ==
                                      "Join Supervisour Conference Cambridge" &&
                                  studCon == 0 &&
                                  widget.type == STAFF_TYPE) {
                            studCon++;
                            String LinkName =
                                "Cambridge Advanced Student Conference";
                            String imageUrl =
                                FlavorConfig.instance.values.baseUrl! +
                                    "staff/linksImages/conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                  "Conference Cambridge") ||
                              data['page'][i].toString() ==
                                      "Join Supervisour Advanced Conference Cambridge" &&
                                  stuconadv == 0 &&
                                  widget.type == STAFF_TYPE) {
                            studCon++;
                            String LinkName = "Cambridge Student Conference";
                            String imageUrl =
                                FlavorConfig.instance.values.baseUrl! +
                                    "staff/linksImages/conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                      "Create Conference" ||
                                  data['page'][i].toString() ==
                                      "Join Supervisour Advanced Conference" ||
                                  data['page'][i].toString() ==
                                      "Recorded Conference") &&
                              stuconadv == 0 &&
                              widget.type == STAFF_TYPE) {
                            stuconadv++;
                            String LinkName = "Advanced Student Conference";
                            String imageUrl =
                                FlavorConfig.instance.values.baseUrl! +
                                    "staff/linksImages/advanced_conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                      "Staff Conference" ||
                                  data['page'][i].toString() ==
                                      "Join Conference") &&
                              staffCon == 0 &&
                              widget.type == STAFF_TYPE) {
                            staffCon++;
                            String LinkName = "Staff Conference";
                            String imageUrl =
                                FlavorConfig.instance.values.baseUrl! +
                                    "staff/linksImages/staff_conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                      "Advanced Staff Conference" ||
                                  data['page'][i].toString() ==
                                      "Advanced Join Conference" ||
                                  data['page'][i].toString() ==
                                      "Staff Recorded Conference" ||
                                  data['page'][i].toString() ==
                                      "Other Staff Recorded Conference") &&
                              advstaffCon == 0 &&
                              widget.type == STAFF_TYPE) {
                            advstaffCon++;
                            String LinkName = "Advanced Staff Conference";
                            String imageUrl = FlavorConfig
                                    .instance.values.baseUrl! +
                                "staff/linksImages/advanced_staff_conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                      "Conference" ||
                                  data['page'][i].toString() ==
                                      "advanced Conference") &&
                              studConMan == 0 &&
                              widget.type == MANAGEMENT_TYPE) {
                            studConMan++;
                            String LinkName = "Student Conference";
                            String imageUrl =
                                FlavorConfig.instance.values.baseUrl! +
                                    "staff/linksImages/conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                      "Staff Confernce" ||
                                  data['page'][i].toString() ==
                                      "Join Conference") &&
                              staffConMan == 0 &&
                              widget.type == MANAGEMENT_TYPE) {
                            staffConMan++;
                            String LinkName = "Staff Conference";
                            String imageUrl =
                                FlavorConfig.instance.values.baseUrl! +
                                    "staff/linksImages/staff_conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if ((data['page'][i].toString() ==
                                      "Advanced Staff Confernce" ||
                                  data['page'][i].toString() ==
                                      "Advanced Staff Join Conference" ||
                                  data['page'][i].toString() ==
                                      "Advanced Staff Recorded Conference" ||
                                  data['page'][i].toString() ==
                                      "Advanced Other Staff Recorded") &&
                              AdvstaffConMan == 0 &&
                              widget.type == MANAGEMENT_TYPE) {
                            AdvstaffConMan++;
                            String LinkName = "Advanced Staff Confernce";
                            String imageUrl = FlavorConfig
                                    .instance.values.baseUrl! +
                                "staff/linksImages/advanced_staff_conference.png";
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        MediaQuery.of(context).size.width * .10,
                                    backgroundColor: Colors.transparent,
                                    child: Image.network(imageUrl),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          } else if (!(((data['page'][i].toString() ==
                                          "Conference" ||
                                      data['page'][i].toString() ==
                                          "Join Supervisour Conference" ||
                                      data['page'][i].toString() ==
                                          "Create Conference" ||
                                      data['page'][i].toString() ==
                                          "Join Supervisour Advanced Conference" ||
                                      data['page'][i].toString() ==
                                          "Recorded Conference" ||
                                      data['page'][i].toString() ==
                                          "Staff Conference" ||
                                      data['page'][i].toString() ==
                                          "Join Conference" ||
                                      data['page'][i].toString() ==
                                          "Advanced Staff Conference" ||
                                      data['page'][i].toString() ==
                                          "Advanced Join Conference" ||
                                      data['page'][i].toString() ==
                                          "Staff Recorded Conference" ||
                                      data['page'][i].toString() ==
                                          "Other Staff Recorded Conference") &&
                                  widget.type == STAFF_TYPE) ||
                              (data['page'][i].toString() == "Conference" ||
                                      data['page'][i].toString() ==
                                          "advanced Conference" ||
                                      data['page'][i].toString() ==
                                          "Staff Confernce" ||
                                      data['page'][i].toString() ==
                                          "Join Conference" ||
                                      data['page'][i].toString() ==
                                          "Advanced Staff Confernce" ||
                                      data['page'][i].toString() ==
                                          "Advanced Staff Join Conference" ||
                                      data['page'][i].toString() ==
                                          "Advanced Staff Recorded Conference" ||
                                      data['page'][i].toString() ==
                                          "Advanced Other Staff Recorded") &&
                                  widget.type == MANAGEMENT_TYPE)) {
                            String LinkName = data['page'][i].toString();
                            String imageUrl = data['url'][i].toString();
                            String numNot = data['no'][i].toString();
                            int num = data['no'][i];
                            print("show no notifization: " + numNot);
                            PageOptions.add(GestureDetector(
                              onTap: () {
                                setState(() {
                                  homePageAllPages(LinkName, widget.type);
                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  (num != 0)
                                      ? Badge(
                                          badgeContent: Text(numNot),
                                          child: CircleAvatar(
                                            radius: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .10,
                                            backgroundColor: Colors.transparent,
                                            child: Image.network(imageUrl),
                                          ))
                                      : CircleAvatar(
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              .10,
                                          backgroundColor: Colors.transparent,
                                          child: Image.network(imageUrl),
                                        ),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20.0),
                                      child: Center(
                                        child: Text(
                                          LinkName,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              fontStyle: FontStyle.italic,
                                              color: AppTheme.appColor),
                                        ),
                                      ))
                                ],
                              ),
                            ));
                          }
                        }
                        return Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: GridView.count(
                              crossAxisCount: 2,
                              children: PageOptions,
                            ));
                      } else {
                        print(" check try " + checkVersionCode!);
                        print(" check version " + _projectCode!);
                                                return UpdateDialog();

                      }
                    }
                  },
                )
              : Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: SpinKitPouringHourGlass(
                      color: AppTheme.appColor,
                    ),
                  ),
                )),
      floatingActionButton: FloatingActionButton(
          elevation: 55,
          onPressed: () {
            logOut(widget.type, widget.Id);
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

import '../config/flavor_config.dart';
import 'MainConstant.dart';

class ApiConstants extends MainConstant {
  static final String ConferenceSchoolName =
      MainConstant.ConferenceSchoolNameBasic;
  static final String BASE_URL = FlavorConfig.instance.values.baseUrl! + "api/";
  static final String CALENDER_API =
      FlavorConfig.instance.values.baseUrl! + "calendar/calendar.php";
  static final String CambridgeRegisterationID_API =
      FlavorConfig.instance.values.baseUrl! + "student/printstudregid.php";
  static final String LOGIN_API = BASE_URL + "login.php";
  static final String LOGOUT_API = BASE_URL + "logOut.php";
  static final String LOGIN_OPTIONS_API = BASE_URL + "loginType.php";
  static final String ACADEMIC_YEARS_API = BASE_URL + "getYear.php";
  static final String SECTIONS_STAFF_API = BASE_URL + "getSectionsStaff.php";
  static final String STAGE_STAFF_API = BASE_URL + "getStage.php";
  static final String GRADE_STAFF_API = BASE_URL + "getGrade.php";
  static final String CLASS_STAFF_API = BASE_URL + "getClassStaff.php";
  static final String CLASS_STAFF_DATA_API = BASE_URL + "getClassStaffData.php";
  static final String SUBJECT_STAFF_API = BASE_URL + "getSubjectStaff.php";
  static final String SECTIONS_API = BASE_URL + "getSections.php";
  static final String SEMESTER_API = BASE_URL + "getSemisterStudent.php";
  static final String GET_STAFF_SUPERVISOR_API =
      BASE_URL + "getStaffSupervisors.php";
  static final String SEMESTER_STAFF_API = BASE_URL + "getSemister.php";
  static final String PAGES_STAFF_API = BASE_URL + "getPagesStaff.php";
  static final String PAGES_STUDENT_API = BASE_URL + "getStudentPages.php";
  static final String PAGES_PARENT_API = BASE_URL + "getParentPages.php";
  static final String GET_STUDENT_OF_Subject_API =
      BASE_URL + "student/getSubjectRecevieFromTeacher.php";
  static final String PAGES_MANAGEMENT_API =
      BASE_URL + "getPagesManagement.php";
  static final String GET_STUDENT_DATA_API = BASE_URL + "getStudentData.php";
  static final String GET_STUDENT_OF_PARENT_API =
      BASE_URL + "getStudentOfParent.php";
  static final String GET_TOPICS_COVERED_STAFF_DATE_API =
      BASE_URL + "staff/topic_covered_staff/sendTopicCoverDates.php";
  static final String GET_TOPICS_COVERED_STAFF_API =
      BASE_URL + "staff/topic_covered_staff/showTopicCover.php";
  static final String GET_TOPICS_COVERED_DIVISION_API =
      BASE_URL + "staff/topic_covered_staff/getDivision.php";
  static final String DELETE_TOPICS_COVERED_API =
      BASE_URL + "staff/topic_covered_staff/delete.php";
  static final String EDIT_TOPICS_COVERED_API =
      BASE_URL + "staff/topic_covered_staff/edit.php";
  static final String ADD_TOPICS_COVERED_API =
      BASE_URL + "staff/topic_covered_staff/addTopicCover.php";
  static final String GET_TOPICS_COVERED_STUDENT_API =
      BASE_URL + "student/showTopicCover.php";
  static final String GET_TOPICS_COVERED_Subject_API =
      BASE_URL + "student/getSubject.php";
  static final String GET_STUDENT_OF_MailBox_API =
      BASE_URL + "student/getMailStudent.php";
  static final String ADD_SEND_TO_CLASS_API =
      BASE_URL + "staff/addSendToClass.php";
  static final String FILE_UPLOAD_SEND_TO_CLASS_API =
      BASE_URL + "staff/uploadSendToClass.php";
  static final String SeenMessage_MailBox_API =
      BASE_URL + "student/seenMessage.php";
  static final String GET_STUDENT_OF_Teacher_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherTeacher.php";

  static final String MAIL_INBOX_STUDENT_MANAGER_DATA_API =
      BASE_URL + "student/MangerDataMailIndox.php";
  static final String MAIL_INBOX_STAFF_MANAGER_DATA_API =
      BASE_URL + "staff/getMangerMailInbox.php";
  static final String GET_SENT_OF_MAILBOX_API =
      BASE_URL + "student/getSentMails.php";
  static final String GET_STUDENT_OF_RECEIVE_FROM_TEACHER_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherData.php";
  static final String GET_STUDENT_OF_RECEIVE_FROM_TEACHER_DATA_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherDataOne.php";
  static final String STUDENT_CHAT_MESSAGES =
      BASE_URL + "student/getreplayfromsendtoclass.php";
  static final String READ_REPLY_SENT_TO_CLASS =
      BASE_URL + "staff/readReplaysenttoclass.php";
  static final String GET_STUDENT_OF_RECEIVE_FROM_TEACHER_DATA_SEEN_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherDataOneSeen.php";
  static final String Teacher_Data_Mail_Inbox_API =
      BASE_URL + "student/TeacherDataMailIndox.php";
  static final String STUDENT_OF_STAFF_MAIL_INBOX_API =
      BASE_URL + "staff/getStudentMailInbox.php";
  static final String PARENT_OF_STAFF_MAIL_INBOX_API =
      BASE_URL + "staff/getParentMailInbox.php";
  static final String FILE_UPLOAD_Mail_Inbox_Student_API =
      BASE_URL + "student/MailIboxUploadAttachment.php";
  static final String ADD_MAIL_INBOX_STUDENT_API =
      BASE_URL + "student/addMailInboxStudent.php";
  static final String ADD_MAIL_INBOX_STAFF_API =
      BASE_URL + "staff/addMailInbox.php";
  static final String REPLY_MAIL_INBOX_STUDENT_API =
      BASE_URL + "student/ReplyMailInboxStudent.php";
  static final String GET_MESSAGE_DETAILS_API =
      BASE_URL + "getMessageDataOne.php";
  static final String GET_STUDENT_ROUTE_API =
      BASE_URL + "parent/getStudentRoute.php";
  static final String GET_STUDENT_PERIOD_API =
      BASE_URL + "parent/getStudentPeriod.php";
  static final String GET_DRIVER_ID_API = BASE_URL + "parent/getBusDriver.php";
  static final String GET_SENT_MESSAGE_DETAILS_API =
      BASE_URL + "getSentMessageDetails.php";
  static final String FILE_UPLOAD_LESSONS_BY_CLASS_API =
      BASE_URL + "staff/uploadLessonsByClass.php";
  static final String ADD_LESSONS_BY_CLASS_API =
      BASE_URL + "staff/addLessonsByClass.php";
  static final String GET_VIDEO_LESSONS_API =
      BASE_URL + "student/viewLessons.php";
  static final String GET_LESSONS_DETAILS_API =
      BASE_URL + "student/lessonsDetails.php";
  static final String FILE_UPLOAD_ASSIGNMENTS_API =
      BASE_URL + "staff/uploadAssignments.php";
  static final String ADD_ASSIGNMENTS_API =
      BASE_URL + "staff/addAssignments.php";
  static final String ADD_ATTENDANCE_STUDENT_API =
      BASE_URL + "staff/takeAttendance.php";
  static final String GET_TIME_TABLE_STUDENT_DATE_API =
      BASE_URL + "student/timeTable.php";
  static final String GET_STUDENT_OF_ASSIGNMENTS_API =
      BASE_URL + "student/getSubjectAssignmentsData.php";
  static final String GET_STUDENT_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "student/getSubjectAssignmentsDataOne.php";
  static final String GET_STUDENT_UPLOADED_TIME_TABLE_API =
      BASE_URL + "student/uploadTimeTable.php";
  static final String GET_MANAGEMENT_UPLOADED_TIME_TABLE_API =
      BASE_URL + "management/uploadTimeTable.php";
  static final String GET_TIME_TABLE_STAFF_DATE_API =
      BASE_URL + "staff/timeTable.php";
  static final String GET_CHANGE_LOGIN_USER_NAME_API =
      BASE_URL + "getUserName.php";
  static final String CHANGE_LOGIN_USERNAME_AND_PASSWORD_API =
      BASE_URL + "changePassword.php";
  static final String STUDENT_OF_ATTANDEC_API =
      BASE_URL + "student/monthAttendance.php";
  static final String MEETING_STUDENT_API = BASE_URL + "student/Meeting.php";
  static final String MEETING_STAFF_ONE_API = BASE_URL + "staff/meetingOne.php";
  static final String MEETING_STAFF_TWO_API = BASE_URL + "staff/meetingTwo.php";
  static final String STUDENT_INSTALLMENT_API =
      BASE_URL + "student/installments.php";
  static final String STUDENT_FEES_DATA_API = BASE_URL + "student/fees.php";
  static final String GET_AUTOMATIC_TIME_TABLE_STUDENT_DATE_API =
      BASE_URL + "student/autoTimeTable.php";
  static final String GET_AUTOMATIC_TIME_TABLE_STAFF_DATE_API =
      BASE_URL + "staff/autoTimeTable.php";
  static final String GET_STUDENT_PROGRESS_REPORTS_DATE_API =
      BASE_URL + "student/getProgressReportDates.php";
  static final String GET_STUDENT_PROGRESS_REPORTS_NAME_API =
      BASE_URL + "student/getProgressReportNames.php";
  static final String GET_STUDENT__REPORTS_CARD_MONTH_API =
      BASE_URL + "student/getReportCardMonth.php";
  static final String GET_STUDENT__REPORTS_CARD4_MONTH_API =
      BASE_URL + "student/getReportCard4Month.php";
  static final String STUDENT_BUS_DETAILS_API =
      BASE_URL + "student/busDetails.php";
  static final String STUDENT_OF_STAFF_STUDENT_PROGRESS_REPORT_API =
      BASE_URL + "staff/getStudentProgessReport.php";
  static final String PREVIOUS_MAINTENANCE_PROBLEMS_API =
      BASE_URL + "staff/getProblemInDetails.php";
  static final String MAINTENANCE_BUILDING_AND_PROBLEMS_OPTIONS_API =
      BASE_URL + "staff/getMaintenanceBuildingAndProblem.php";
  static final String MAINTENANCE_PLACE_OPTIONS_API =
      BASE_URL + "staff/getMaintenancePlace.php";
  static final String MAINTENANCE_SUB_PLACE_OPTIONS_API =
      BASE_URL + "staff/getMaintenanceSubPlace.php";
  static final String MAINTENANCE_DEVICE_OPTIONS_API =
      BASE_URL + "staff/getMaintenanceDevice.php";
  static final String ADD_MAINTENANCE_PROBLEM_API =
      BASE_URL + "staff/addMaintenanceProblem.php";
  static final String VIEW_CAMBRIDGE_DEGREE_API =
      BASE_URL + "student/getCambridgeDegree.php";
  static final String GET_SESSION_CAMBRIDGE_API =
      BASE_URL + "student/getSessionCambridge.php";
  static final String VIEW_CAMBRIDGE_DROP_SUBJECTS_API =
      BASE_URL + "student/cambridgeDropSubjects.php";
  static final String GET_SUBJECT_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/getSubjectRegisterationCambridge.php";
  static final String GET_SUB_SUBJECT_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/getSubSubjectRegisterationCambridge.php";
  static final String GET_SUBJECT_STATUS_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/getStatusSubjectRegisterationCambridge.php";
  static final String ADD_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/addRegisterationCambridge.php";
  static final String ADD_CAMBRIDGE_DROP_SUBJECTS_API =
      BASE_URL + "student/addcambridgeDropSubjects.php";
  static final String GET_COLUMN_CAMBRIDGE_CONFIRMATION_API =
      BASE_URL + "student/getDataCambridgeConfirmation.php";
  static final String ADD_REGISTED_CAMBRIDGE_CONFIRMATION_API =
      BASE_URL + "student/addRegisterationCambridgeConfirm.php";
  static final String FILE_UPLOAD_MANAGEMENT_BY_SELECT_API =
      BASE_URL + "management/uploadFiles.php";
  static final String ADD_BY_SELECT_MANAGEMENT_API =
      BASE_URL + "management/addBySelect.php";
  static final String ADD_UPLOADED_TIME_TABLE_API =
      BASE_URL + "management/uploadTimeTableadd.php";
  static final String STAGE_MANAGEMENT_API =
      BASE_URL + "management/getStage.php";
  static final String GRADE_MANAGEMENT_API =
      BASE_URL + "management/getGrade.php";
  static final String CLASS_MANAGEMENT_API =
      BASE_URL + "management/getClass.php";
  static final String ADD_ADVANCED_MANAGEMENT_API =
      BASE_URL + "management/addAdvanced.php";
  static final String STUDENT_OF_ADVANCED_MANAGEMENT_API =
      BASE_URL + "management/getStudentWithAdvancedSearch.php";
  static final String DEP_ONE_API = BASE_URL + "management/getDepOne.php";
  static final String DEP_TWO_API = BASE_URL + "management/getDepTwo.php";
  static final String DEP_THREE_API = BASE_URL + "management/getDepThree.php";
  static final String DEP_FOUR_API = BASE_URL + "management/getDepFour.php";
  static final String STAFF_MAIL_UPLOAD_API =
      BASE_URL + "management/uploadStaffMail.php";
  static final String ADD_STAFF_MAIL_API =
      BASE_URL + "management/addStaffMail.php";
  static final String ADD_SMS_MANAGEMENT_API =
      BASE_URL + "management/addSMS.php";
  static final String CLASS_MANAGEMENT_LIST_API =
      BASE_URL + "management/getClassesList.php";
  static final String ADD_BY_CLASS_MANAGEMENT_API =
      BASE_URL + "management/addByClass.php";
  static final String ADD_MANAGEMENT_Attendance_API =
      BASE_URL + "management/takeManagementAttendance.php";
  static final String TYPE_PROGRESS_REPORT_API =
      BASE_URL + "student/stuViewProgressReport.php";
  static final String TYPE_PROGRESS_REPORT_API_API =
      BASE_URL + "student/stuViewProgressReportAlt.php";
  static final String LEAVE_TYPE_OPTIONS_API =
      BASE_URL + "staff/leaveTypeOptions.php";
  static final String LEAVE_NAME_OPTIONS_API =
      BASE_URL + "staff/leaveNameOptions.php";
  static final String ADD_LEAVE_REQUEST_API =
      BASE_URL + "staff/addLeaveRequest.php";
  static final String ADD_UN_PAID_LEAVE_REQUEST_API =
      BASE_URL + "staff/addUnPaidLeaveRequest.php";
  static final String VACATION_TYPE_OPTIONS_API =
      BASE_URL + "staff/vacationTypeOptions.php";
  static final String VACATION_NAME_OPTIONS_API =
      BASE_URL + "staff/vacationNameOptions.php";
  static final String ADD_VACATION_REQUEST_API =
      BASE_URL + "staff/addvacationRequest.php";
  static final String ADD_UN_PAID_VACATION_REQUEST_API =
      BASE_URL + "staff/addUnPaidvacationRequest.php";
  static final String PREVIOUS_LEAVE_REQUEST_API =
      BASE_URL + "staff/getPreviousLeaveRequest.php";
  static final String DELETE_LEAVE_REQUEST_API =
      BASE_URL + "staff/deleteLeaveRequest.php";
  static final String PREVIOUS_UN_PAID_LEAVE_REQUEST_API =
      BASE_URL + "staff/getPreviousUnPaidLeaveRequest.php";
  static final String DELETE_UN_PAID_LEAVE_REQUEST_API =
      BASE_URL + "staff/deleteUnPaidLeaveRequest.php";
  static final String PREVIOUS_VACATION_REQUEST_API =
      BASE_URL + "staff/getPreviousVacationRequest.php";
  static final String DELETE_VACATION_REQUEST_API =
      BASE_URL + "staff/deleteVacationRequest.php";
  static final String PREVIOUS_UN_PAID_VACATION_REQUEST_API =
      BASE_URL + "staff/getPreviousUnPaidVacationRequest.php";
  static final String DELETE_UN_PAID_VACATION_REQUEST_API =
      BASE_URL + "staff/deleteUnPaidVacationRequest.php";
  static final String GET_STUDENT_OF_LIVE_STREAM_API =
      BASE_URL + "student/liveStreamData.php";
  static final String GET_LIVE_STREAM_CHANNEL_API =
      BASE_URL + "staff/getLiveStreamChannel.php";
  static final String ADD_LIVE_STREAM_API =
      BASE_URL + "staff/addLiveStream.php";
  static final String REPLY_ASSIGNMENT_STUDENT_API =
      BASE_URL + "student/ReplyAssignment.php";
  static final String FILE_UPLOAD_REPLY_ASSIGNMENT_API =
      BASE_URL + "student/replyAssignmentUploadAttachment.php";
  static final String GET_TEACHER_REPLY_OF_ASSIGNMENTS_API =
      BASE_URL + "student/getTeacherReplyAssignments.php";
  static final String GET_TEACHER_REPLY_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "student/getTeacherReplyAssignmentsData.php";
  static final String GET_STUDENT_REPLY_OF_ASSIGNMENTS_API =
      BASE_URL + "student/getStudentReplyAssignments.php";
  static final String GET_STUDENT_REPLY_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "student/getStudentReplyAssignmentsData.php";
  static final String GET_STUDENT_REPLY_FROM_STAFF_OF_ASSIGNMENTS_API =
      BASE_URL + "staff/getStudentReplyAssignments.php";
  static final String GET_STUDENT_REPLY_FROM_STAFF_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "staff/getStudentReplyAssignmentsData.php";
  static final String REPLY_ASSIGNMENT_STAFF_API =
      BASE_URL + "staff/ReplyAssignmentStaff.php";
  static final String FILE_UPLOAD_REPLY_ASSIGNMENT_STAFF_API =
      BASE_URL + "staff/replyAssignmentUploadAttachment.php";
  static final String GET_STAFF_REPLY_OF_ASSIGNMENTS_API =
      BASE_URL + "staff/getStaffReplyAssignments.php";
  static final String GET_STAFF_REPLY_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "staff/getStafReplyAssignmentsData.php";
  static final String GET_STAFF_PREVIOUS_ASSIGNMENTS_API =
      BASE_URL + "staff/viewAssignments.php";
  static final String DELETE_ASSIGNMENTS_API =
      BASE_URL + "staff/deleteAssignments.php";
  static final String STUDENT_OF_MEMO_API =
      BASE_URL + "staff/GetStudentMemo.php";
  static final String GET_MEMO_OPTIONS_API = BASE_URL + "staff/MemoOptions.php";
  static final String ADD_MEMO_API = BASE_URL + "staff/AddMemo.php";
  static final String GET_MEMO_STUDENT_API =
      BASE_URL + "student/GetMemoStudentDetails.php";
  static final String GET_STUDENT_OF_CONFERENCE_API =
      BASE_URL + "student/GetConferenceData.php";
  static final String JOIN_CONFERENCE_API = BASE_URL + "JoinConference.php";
  static final String TERMINATED_CONFERENCE_API =
      BASE_URL + "TerminatedConference.php";
  static final String URL_CONFERENCE_API = BASE_URL + "urlConferenceApi.php";
  static final String TERMINATED_CONFERENCE_STAFF_API =
      BASE_URL + "TerminatedConferenceStaff.php";
  static final String JOIN_STAFF_CONFERENCE_API =
      BASE_URL + "staff/joinStaffConferenceApi.php";
  static final String GET_STAFF_JOIN_OF_CONFERENCE_API =
      BASE_URL + "staff/joinStaffConferenceStaff.php";
  static final String UPDATE_JOIN_STAFF_CONFERENCE_API =
      BASE_URL + "staff/joinStaffConferenceStaffUpdateCount.php";
  static final String TERMINATED_CONFERENCE_STAFF_STAFF_API =
      BASE_URL + "staff/trminateStaffConferenceStaffUpdateCount.php";
  static final String GET_SUPERVISIOR_STAFF_JOIN_OF_CONFERENCE_API =
      BASE_URL + "staff/getSupervisiorConference.php";
  static final String GET_STUDENT_OF_CONFERENCE_MANAGEMENT_API =
      BASE_URL + "management/getConferenceStudentData.php";
  static final String GET_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "staff/joinStaffAdvancedConferenceStaff.php";
  static final String REPLY_SENDTOCLASS_STUDENT_API =
      BASE_URL + "student/ReplySendtoclass.php";
  static final String Reply_Reply_Send_To_Class_Student =
      BASE_URL + "student/replyReplySendtoclassStudent.php";
  static final String Reply_Reply_Send_To_Class_READ_STAFF_STUDENT =
      BASE_URL + "staff/replyReplySendtoclassreadstaffstudent.php";
  static final String GET_STUDENT_REPLY_FROM_STAFF_OF_SENDTOCLASS_API =
      BASE_URL + "staff/getStudentRelySendtoclass.php";
  static final String GET_REPLY_FROM_SEND_TO_CLASS_FROM_STUDENTS =
      BASE_URL + "staff/getreplayfromsendtoclassfromstudents.php";
  static final String GET_STUDENT_REPLY_FROM_STAFF_OF_SENDTOCLASS_DATA_API =
      BASE_URL + "staff/getStudentReplySendtoclassData.php";
  static final String GET_SEESION_CAMBRIDGE_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getSession.php";
  static final String GET_CAMBRIDGE_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getCambridgeStaffAdvancedData.php";
  static final String JOIN_CAMBRIDGE_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/joinCambridgeConference.php";
  static final String TERMINATED_CAMBRIDGE_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/TerminatedCambridgeConference.php";
  static final String GET_CAMBRIDGE_URL_API =
      BASE_URL + "cambrigdeConference/urlCambridgeConferenceApi.php";
  static final String
      GET_CAMBRIDGE_STAFF_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getCambridgeStaffStaffAdvancedData.php";
  static final String
      GET_CAMBRIDGE_SUPERVISOUR_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getCambridgeSupervisourAdvancedData.php";
  static final String UPDATE_JOIN_CAMBRIDGE_STAFF_CONFERENCE_API = BASE_URL +
      "cambrigdeConference/joinCambridgeStaffConferenceUpdateCount.php";
  static final String TERMINATED_CAMBRIDGE_CONFERENCE_STAFF_STAFF_API =
      BASE_URL + "cambrigdeConference/TerminatedCambridgeConference.php";
  static final String GET_CAMBRIDGE_CONFERENCE_STUDENT_DATA_API =
      BASE_URL + "cambrigdeConference/getCambridgeConferenceStudentData.php";
  static final String ACADEMIC_YEARS_FOR_STUDENT_API =
      BASE_URL + "student/getYearStudent.php";
  static final String URL_CONFERENCE_BY_STAGE_API =
      BASE_URL + "urlConferenceApiByStage.php";
  static final String GET_STUDENT_OF_ASSIGNMENTS_DATA_SEEN_API =
      BASE_URL + "student/getSubjectAssignmentsSeen.php";
}

import 'MainConstant.dart';

class ApiConstants extends MainConstant {
  static const String ConferenceSchoolName =
      MainConstant.ConferenceSchoolNameBasic;
  static const String BASE_URL = MainConstant.BASE_URL_MAIN + "api/";
  static const String CALENDER_API =
      MainConstant.BASE_URL_MAIN + "calendar/calendar.php";
  static const String CambridgeRegisterationID_API =
      MainConstant.BASE_URL_MAIN + "student/printstudregid.php";
  static const String LOGIN_API = BASE_URL + "login.php";
  static const String LOGOUT_API = BASE_URL + "logOut.php";
  static const String LOGIN_OPTIONS_API = BASE_URL + "loginType.php";
  static const String ACADEMIC_YEARS_API = BASE_URL + "getYear.php";
  static const String SECTIONS_STAFF_API = BASE_URL + "getSectionsStaff.php";
  static const String STAGE_STAFF_API = BASE_URL + "getStage.php";
  static const String GRADE_STAFF_API = BASE_URL + "getGrade.php";
  static const String CLASS_STAFF_API = BASE_URL + "getClassStaff.php";
  static const String CLASS_STAFF_DATA_API = BASE_URL + "getClassStaffData.php";
  static const String SUBJECT_STAFF_API = BASE_URL + "getSubjectStaff.php";
  static const String SECTIONS_API = BASE_URL + "getSections.php";
  static const String SEMESTER_API = BASE_URL + "getSemisterStudent.php";
  static const String GET_STAFF_SUPERVISOR_API =
      BASE_URL + "getStaffSupervisors.php";
  static const String SEMESTER_STAFF_API = BASE_URL + "getSemister.php";
  static const String PAGES_STAFF_API = BASE_URL + "getPagesStaff.php";
  static const String PAGES_STUDENT_API = BASE_URL + "getStudentPages.php";
  static const String PAGES_PARENT_API = BASE_URL + "getParentPages.php";
  static const String GET_STUDENT_OF_Subject_API =
      BASE_URL + "student/getSubjectRecevieFromTeacher.php";
  static const String PAGES_MANAGEMENT_API =
      BASE_URL + "getPagesManagement.php";
  static const String GET_STUDENT_DATA_API = BASE_URL + "getStudentData.php";
  static const String GET_STUDENT_OF_PARENT_API =
      BASE_URL + "getStudentOfParent.php";
  static const String GET_TOPICS_COVERED_STAFF_DATE_API =
      BASE_URL + "staff/topic_covered_staff/sendTopicCoverDates.php";
  static const String GET_TOPICS_COVERED_STAFF_API =
      BASE_URL + "staff/topic_covered_staff/showTopicCover.php";
  static const String GET_TOPICS_COVERED_DIVISION_API =
      BASE_URL + "staff/topic_covered_staff/getDivision.php";
  static const String DELETE_TOPICS_COVERED_API =
      BASE_URL + "staff/topic_covered_staff/delete.php";
  static const String EDIT_TOPICS_COVERED_API =
      BASE_URL + "staff/topic_covered_staff/edit.php";
  static const String ADD_TOPICS_COVERED_API =
      BASE_URL + "staff/topic_covered_staff/addTopicCover.php";
  static const String GET_TOPICS_COVERED_STUDENT_API =
      BASE_URL + "student/showTopicCover.php";
  static const String GET_TOPICS_COVERED_Subject_API =
      BASE_URL + "student/getSubject.php";
  static const String GET_STUDENT_OF_MailBox_API =
      BASE_URL + "student/getMailStudent.php";
  static const String ADD_SEND_TO_CLASS_API =
      BASE_URL + "staff/addSendToClass.php";
  static const String FILE_UPLOAD_SEND_TO_CLASS_API =
      BASE_URL + "staff/uploadSendToClass.php";
  static const String SeenMessage_MailBox_API =
      BASE_URL + "student/seenMessage.php";
  static const String GET_STUDENT_OF_Teacher_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherTeacher.php";

  static const String MAIL_INBOX_STUDENT_MANAGER_DATA_API =
      BASE_URL + "student/MangerDataMailIndox.php";
  static const String MAIL_INBOX_STAFF_MANAGER_DATA_API =
      BASE_URL + "staff/getMangerMailInbox.php";
  static const String GET_SENT_OF_MAILBOX_API =
      BASE_URL + "student/getSentMails.php";
  static const String GET_STUDENT_OF_RECEIVE_FROM_TEACHER_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherData.php";
  static const String GET_STUDENT_OF_RECEIVE_FROM_TEACHER_DATA_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherDataOne.php";
  static const String STUDENT_CHAT_MESSAGES =
      BASE_URL + "student/getreplayfromsendtoclass.php";
  static const String READ_REPLY_SENT_TO_CLASS =
      BASE_URL + "staff/readReplaysenttoclass.php";
  static const String GET_STUDENT_OF_RECEIVE_FROM_TEACHER_DATA_SEEN_API =
      BASE_URL + "student/getSubjectRecevieFromTeacherDataOneSeen.php";
  static const String Teacher_Data_Mail_Inbox_API =
      BASE_URL + "student/TeacherDataMailIndox.php";
  static const String STUDENT_OF_STAFF_MAIL_INBOX_API =
      BASE_URL + "staff/getStudentMailInbox.php";
  static const String PARENT_OF_STAFF_MAIL_INBOX_API =
      BASE_URL + "staff/getParentMailInbox.php";
  static const String FILE_UPLOAD_Mail_Inbox_Student_API =
      BASE_URL + "student/MailIboxUploadAttachment.php";
  static const String ADD_MAIL_INBOX_STUDENT_API =
      BASE_URL + "student/addMailInboxStudent.php";
  static const String ADD_MAIL_INBOX_STAFF_API =
      BASE_URL + "staff/addMailInbox.php";
  static const String REPLY_MAIL_INBOX_STUDENT_API =
      BASE_URL + "student/ReplyMailInboxStudent.php";
  static const String GET_MESSAGE_DETAILS_API =
      BASE_URL + "getMessageDataOne.php";
  static const String GET_STUDENT_ROUTE_API =
      BASE_URL + "parent/getStudentRoute.php";
  static const String GET_STUDENT_PERIOD_API =
      BASE_URL + "parent/getStudentPeriod.php";
  static const String GET_DRIVER_ID_API = BASE_URL + "parent/getBusDriver.php";
  static const String GET_SENT_MESSAGE_DETAILS_API =
      BASE_URL + "getSentMessageDetails.php";
  static const String FILE_UPLOAD_LESSONS_BY_CLASS_API =
      BASE_URL + "staff/uploadLessonsByClass.php";
  static const String ADD_LESSONS_BY_CLASS_API =
      BASE_URL + "staff/addLessonsByClass.php";
  static const String GET_VIDEO_LESSONS_API =
      BASE_URL + "student/viewLessons.php";
  static const String GET_LESSONS_DETAILS_API =
      BASE_URL + "student/lessonsDetails.php";
  static const String FILE_UPLOAD_ASSIGNMENTS_API =
      BASE_URL + "staff/uploadAssignments.php";
  static const String ADD_ASSIGNMENTS_API =
      BASE_URL + "staff/addAssignments.php";
  static const String ADD_ATTENDANCE_STUDENT_API =
      BASE_URL + "staff/takeAttendance.php";
  static const String GET_TIME_TABLE_STUDENT_DATE_API =
      BASE_URL + "student/timeTable.php";
  static const String GET_STUDENT_OF_ASSIGNMENTS_API =
      BASE_URL + "student/getSubjectAssignmentsData.php";
  static const String GET_STUDENT_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "student/getSubjectAssignmentsDataOne.php";
  static const String GET_STUDENT_UPLOADED_TIME_TABLE_API =
      BASE_URL + "student/uploadTimeTable.php";
  static const String GET_MANAGEMENT_UPLOADED_TIME_TABLE_API =
      BASE_URL + "management/uploadTimeTable.php";
  static const String GET_TIME_TABLE_STAFF_DATE_API =
      BASE_URL + "staff/timeTable.php";
  static const String GET_CHANGE_LOGIN_USER_NAME_API =
      BASE_URL + "getUserName.php";
  static const String CHANGE_LOGIN_USERNAME_AND_PASSWORD_API =
      BASE_URL + "changePassword.php";
  static const String STUDENT_OF_ATTANDEC_API =
      BASE_URL + "student/monthAttendance.php";
  static const String MEETING_STUDENT_API = BASE_URL + "student/Meeting.php";
  static const String MEETING_STAFF_ONE_API = BASE_URL + "staff/meetingOne.php";
  static const String MEETING_STAFF_TWO_API = BASE_URL + "staff/meetingTwo.php";
  static const String STUDENT_INSTALLMENT_API =
      BASE_URL + "student/installments.php";
  static const String STUDENT_FEES_DATA_API = BASE_URL + "student/fees.php";
  static const String GET_AUTOMATIC_TIME_TABLE_STUDENT_DATE_API =
      BASE_URL + "student/autoTimeTable.php";
  static const String GET_AUTOMATIC_TIME_TABLE_STAFF_DATE_API =
      BASE_URL + "staff/autoTimeTable.php";
  static const String GET_STUDENT_PROGRESS_REPORTS_DATE_API =
      BASE_URL + "student/getProgressReportDates.php";
  static const String GET_STUDENT_PROGRESS_REPORTS_NAME_API =
      BASE_URL + "student/getProgressReportNames.php";
  static const String GET_STUDENT__REPORTS_CARD_MONTH_API =
      BASE_URL + "student/getReportCardMonth.php";
  static const String GET_STUDENT__REPORTS_CARD4_MONTH_API =
      BASE_URL + "student/getReportCard4Month.php";
  static const String STUDENT_BUS_DETAILS_API =
      BASE_URL + "student/busDetails.php";
  static const String STUDENT_OF_STAFF_STUDENT_PROGRESS_REPORT_API =
      BASE_URL + "staff/getStudentProgessReport.php";
  static const String PREVIOUS_MAINTENANCE_PROBLEMS_API =
      BASE_URL + "staff/getProblemInDetails.php";
  static const String MAINTENANCE_BUILDING_AND_PROBLEMS_OPTIONS_API =
      BASE_URL + "staff/getMaintenanceBuildingAndProblem.php";
  static const String MAINTENANCE_PLACE_OPTIONS_API =
      BASE_URL + "staff/getMaintenancePlace.php";
  static const String MAINTENANCE_SUB_PLACE_OPTIONS_API =
      BASE_URL + "staff/getMaintenanceSubPlace.php";
  static const String MAINTENANCE_DEVICE_OPTIONS_API =
      BASE_URL + "staff/getMaintenanceDevice.php";
  static const String ADD_MAINTENANCE_PROBLEM_API =
      BASE_URL + "staff/addMaintenanceProblem.php";
  static const String VIEW_CAMBRIDGE_DEGREE_API =
      BASE_URL + "student/getCambridgeDegree.php";
  static const String GET_SESSION_CAMBRIDGE_API =
      BASE_URL + "student/getSessionCambridge.php";
  static const String VIEW_CAMBRIDGE_DROP_SUBJECTS_API =
      BASE_URL + "student/cambridgeDropSubjects.php";
  static const String GET_SUBJECT_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/getSubjectRegisterationCambridge.php";
  static const String GET_SUB_SUBJECT_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/getSubSubjectRegisterationCambridge.php";
  static const String GET_SUBJECT_STATUS_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/getStatusSubjectRegisterationCambridge.php";
  static const String ADD_REGISTED_CAMBRIDGE_API =
      BASE_URL + "student/addRegisterationCambridge.php";
  static const String ADD_CAMBRIDGE_DROP_SUBJECTS_API =
      BASE_URL + "student/addcambridgeDropSubjects.php";
  static const String GET_COLUMN_CAMBRIDGE_CONFIRMATION_API =
      BASE_URL + "student/getDataCambridgeConfirmation.php";
  static const String ADD_REGISTED_CAMBRIDGE_CONFIRMATION_API =
      BASE_URL + "student/addRegisterationCambridgeConfirm.php";
  static const String FILE_UPLOAD_MANAGEMENT_BY_SELECT_API =
      BASE_URL + "management/uploadFiles.php";
  static const String ADD_BY_SELECT_MANAGEMENT_API =
      BASE_URL + "management/addBySelect.php";
  static const String ADD_UPLOADED_TIME_TABLE_API =
      BASE_URL + "management/uploadTimeTableadd.php";
  static const String STAGE_MANAGEMENT_API =
      BASE_URL + "management/getStage.php";
  static const String GRADE_MANAGEMENT_API =
      BASE_URL + "management/getGrade.php";
  static const String CLASS_MANAGEMENT_API =
      BASE_URL + "management/getClass.php";
  static const String ADD_ADVANCED_MANAGEMENT_API =
      BASE_URL + "management/addAdvanced.php";
  static const String STUDENT_OF_ADVANCED_MANAGEMENT_API =
      BASE_URL + "management/getStudentWithAdvancedSearch.php";
  static const String DEP_ONE_API = BASE_URL + "management/getDepOne.php";
  static const String DEP_TWO_API = BASE_URL + "management/getDepTwo.php";
  static const String DEP_THREE_API = BASE_URL + "management/getDepThree.php";
  static const String DEP_FOUR_API = BASE_URL + "management/getDepFour.php";
  static const String STAFF_MAIL_UPLOAD_API =
      BASE_URL + "management/uploadStaffMail.php";
  static const String ADD_STAFF_MAIL_API =
      BASE_URL + "management/addStaffMail.php";
  static const String ADD_SMS_MANAGEMENT_API =
      BASE_URL + "management/addSMS.php";
  static const String CLASS_MANAGEMENT_LIST_API =
      BASE_URL + "management/getClassesList.php";
  static const String ADD_BY_CLASS_MANAGEMENT_API =
      BASE_URL + "management/addByClass.php";
  static const String ADD_MANAGEMENT_Attendance_API =
      BASE_URL + "management/takeManagementAttendance.php";
  static const String TYPE_PROGRESS_REPORT_API =
      BASE_URL + "student/stuViewProgressReport.php";
  static const String TYPE_PROGRESS_REPORT_API_API =
      BASE_URL + "student/stuViewProgressReportAlt.php";
  static const String LEAVE_TYPE_OPTIONS_API =
      BASE_URL + "staff/leaveTypeOptions.php";
  static const String LEAVE_NAME_OPTIONS_API =
      BASE_URL + "staff/leaveNameOptions.php";
  static const String ADD_LEAVE_REQUEST_API =
      BASE_URL + "staff/addLeaveRequest.php";
  static const String ADD_UN_PAID_LEAVE_REQUEST_API =
      BASE_URL + "staff/addUnPaidLeaveRequest.php";
  static const String VACATION_TYPE_OPTIONS_API =
      BASE_URL + "staff/vacationTypeOptions.php";
  static const String VACATION_NAME_OPTIONS_API =
      BASE_URL + "staff/vacationNameOptions.php";
  static const String ADD_VACATION_REQUEST_API =
      BASE_URL + "staff/addvacationRequest.php";
  static const String ADD_UN_PAID_VACATION_REQUEST_API =
      BASE_URL + "staff/addUnPaidvacationRequest.php";
  static const String PREVIOUS_LEAVE_REQUEST_API =
      BASE_URL + "staff/getPreviousLeaveRequest.php";
  static const String DELETE_LEAVE_REQUEST_API =
      BASE_URL + "staff/deleteLeaveRequest.php";
  static const String PREVIOUS_UN_PAID_LEAVE_REQUEST_API =
      BASE_URL + "staff/getPreviousUnPaidLeaveRequest.php";
  static const String DELETE_UN_PAID_LEAVE_REQUEST_API =
      BASE_URL + "staff/deleteUnPaidLeaveRequest.php";
  static const String PREVIOUS_VACATION_REQUEST_API =
      BASE_URL + "staff/getPreviousVacationRequest.php";
  static const String DELETE_VACATION_REQUEST_API =
      BASE_URL + "staff/deleteVacationRequest.php";
  static const String PREVIOUS_UN_PAID_VACATION_REQUEST_API =
      BASE_URL + "staff/getPreviousUnPaidVacationRequest.php";
  static const String DELETE_UN_PAID_VACATION_REQUEST_API =
      BASE_URL + "staff/deleteUnPaidVacationRequest.php";
  static const String GET_STUDENT_OF_LIVE_STREAM_API =
      BASE_URL + "student/liveStreamData.php";
  static const String GET_LIVE_STREAM_CHANNEL_API =
      BASE_URL + "staff/getLiveStreamChannel.php";
  static const String ADD_LIVE_STREAM_API =
      BASE_URL + "staff/addLiveStream.php";
  static const String REPLY_ASSIGNMENT_STUDENT_API =
      BASE_URL + "student/ReplyAssignment.php";
  static const String FILE_UPLOAD_REPLY_ASSIGNMENT_API =
      BASE_URL + "student/replyAssignmentUploadAttachment.php";
  static const String GET_TEACHER_REPLY_OF_ASSIGNMENTS_API =
      BASE_URL + "student/getTeacherReplyAssignments.php";
  static const String GET_TEACHER_REPLY_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "student/getTeacherReplyAssignmentsData.php";
  static const String GET_STUDENT_REPLY_OF_ASSIGNMENTS_API =
      BASE_URL + "student/getStudentReplyAssignments.php";
  static const String GET_STUDENT_REPLY_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "student/getStudentReplyAssignmentsData.php";
  static const String GET_STUDENT_REPLY_FROM_STAFF_OF_ASSIGNMENTS_API =
      BASE_URL + "staff/getStudentReplyAssignments.php";
  static const String GET_STUDENT_REPLY_FROM_STAFF_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "staff/getStudentReplyAssignmentsData.php";
  static const String REPLY_ASSIGNMENT_STAFF_API =
      BASE_URL + "staff/ReplyAssignmentStaff.php";
  static const String FILE_UPLOAD_REPLY_ASSIGNMENT_STAFF_API =
      BASE_URL + "staff/replyAssignmentUploadAttachment.php";
  static const String GET_STAFF_REPLY_OF_ASSIGNMENTS_API =
      BASE_URL + "staff/getStaffReplyAssignments.php";
  static const String GET_STAFF_REPLY_OF_ASSIGNMENTS_DATA_API =
      BASE_URL + "staff/getStafReplyAssignmentsData.php";
  static const String GET_STAFF_PREVIOUS_ASSIGNMENTS_API =
      BASE_URL + "staff/viewAssignments.php";
  static const String DELETE_ASSIGNMENTS_API =
      BASE_URL + "staff/deleteAssignments.php";
  static const String STUDENT_OF_MEMO_API =
      BASE_URL + "staff/GetStudentMemo.php";
  static const String GET_MEMO_OPTIONS_API = BASE_URL + "staff/MemoOptions.php";
  static const String ADD_MEMO_API = BASE_URL + "staff/AddMemo.php";
  static const String GET_MEMO_STUDENT_API =
      BASE_URL + "student/GetMemoStudentDetails.php";
  static const String GET_STUDENT_OF_CONFERENCE_API =
      BASE_URL + "student/GetConferenceData.php";
  static const String JOIN_CONFERENCE_API = BASE_URL + "JoinConference.php";
  static const String TERMINATED_CONFERENCE_API =
      BASE_URL + "TerminatedConference.php";
  static const String URL_CONFERENCE_API = BASE_URL + "urlConferenceApi.php";
  static const String TERMINATED_CONFERENCE_STAFF_API =
      BASE_URL + "TerminatedConferenceStaff.php";
  static const String JOIN_STAFF_CONFERENCE_API =
      BASE_URL + "staff/joinStaffConferenceApi.php";
  static const String GET_STAFF_JOIN_OF_CONFERENCE_API =
      BASE_URL + "staff/joinStaffConferenceStaff.php";
  static const String UPDATE_JOIN_STAFF_CONFERENCE_API =
      BASE_URL + "staff/joinStaffConferenceStaffUpdateCount.php";
  static const String TERMINATED_CONFERENCE_STAFF_STAFF_API =
      BASE_URL + "staff/trminateStaffConferenceStaffUpdateCount.php";
  static const String GET_SUPERVISIOR_STAFF_JOIN_OF_CONFERENCE_API =
      BASE_URL + "staff/getSupervisiorConference.php";
  static const String GET_STUDENT_OF_CONFERENCE_MANAGEMENT_API =
      BASE_URL + "management/getConferenceStudentData.php";
  static const String GET_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "staff/joinStaffAdvancedConferenceStaff.php";
  static const String REPLY_SENDTOCLASS_STUDENT_API =
      BASE_URL + "student/ReplySendtoclass.php";
  static const String GET_STUDENT_REPLY_FROM_STAFF_OF_SENDTOCLASS_API =
      BASE_URL + "staff/getStudentRelySendtoclass.php";
  static const String GET_REPLY_FROM_SEND_TO_CLASS_FROM_STUDENTS =
      BASE_URL + "staff/getreplayfromsendtoclassfromstudents.php";
  static const String GET_STUDENT_REPLY_FROM_STAFF_OF_SENDTOCLASS_DATA_API =
      BASE_URL + "staff/getStudentReplySendtoclassData.php";
  static const String GET_SEESION_CAMBRIDGE_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getSession.php";
  static const String GET_CAMBRIDGE_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getCambridgeStaffAdvancedData.php";
  static const String JOIN_CAMBRIDGE_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/joinCambridgeConference.php";
  static const String TERMINATED_CAMBRIDGE_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/TerminatedCambridgeConference.php";
  static const String GET_CAMBRIDGE_URL_API =
      BASE_URL + "cambrigdeConference/urlCambridgeConferenceApi.php";
  static const String
      GET_CAMBRIDGE_STAFF_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getCambridgeStaffStaffAdvancedData.php";
  static const String
      GET_CAMBRIDGE_SUPERVISOUR_JOIN_OF_ADVANCED_CONFERENCE_API =
      BASE_URL + "cambrigdeConference/getCambridgeSupervisourAdvancedData.php";
  static const String UPDATE_JOIN_CAMBRIDGE_STAFF_CONFERENCE_API = BASE_URL +
      "cambrigdeConference/joinCambridgeStaffConferenceUpdateCount.php";
  static const String TERMINATED_CAMBRIDGE_CONFERENCE_STAFF_STAFF_API =
      BASE_URL + "cambrigdeConference/TerminatedCambridgeConference.php";
  static const String GET_CAMBRIDGE_CONFERENCE_STUDENT_DATA_API =
      BASE_URL + "cambrigdeConference/getCambridgeConferenceStudentData.php";
  static const String ACADEMIC_YEARS_FOR_STUDENT_API =
      BASE_URL + "student/getYearStudent.php";
  static const String URL_CONFERENCE_BY_STAGE_API =
      BASE_URL + "urlConferenceApiByStage.php";
  static const String GET_STUDENT_OF_ASSIGNMENTS_DATA_SEEN_API =
      BASE_URL + "student/getSubjectAssignmentsSeen.php";
}

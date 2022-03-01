import '../config/flavor_config.dart';

import 'MainConstant.dart';

class ProgressReport extends MainConstant {
  static final String BASE_URL_PROGRESS_REPORT =
      FlavorConfig.instance.values.baseUrl!;
  static final String SCHOOL_STUDENT_PROGRESS_REPORT_ONE_LINK =
      BASE_URL_PROGRESS_REPORT + "student/printevaluate.php";
  static final String SCHOOL_STUDENT_PROGRESS_REPORT_TWO_LINK =
      BASE_URL_PROGRESS_REPORT + "student/printevaluatetwo.php";
  static final String SCHOOL_STUDENT_PROGRESS_REPORT_CORE_LINK =
      BASE_URL_PROGRESS_REPORT + "student/printevaluatecore.php";
  static final String SCHOOL_STUDENT_PROGRESS_REPORT_PRINT_LINK =
      BASE_URL_PROGRESS_REPORT + "student/viewprogressreportprint.php";
  static final String SCHOOL_STUDENT_PROGRESS_REPORT_NEW_LINK =
      BASE_URL_PROGRESS_REPORT + "student/printevaluatenew.php";

  static final String SCHOOL_PROGRESS_REPORT_TWO_LINK =
      BASE_URL_PROGRESS_REPORT + "management/prints/printevaluate2.php";
  static final String SCHOOL_PROGRESS_REPORT_ALT_ONE_LINK =
      BASE_URL_PROGRESS_REPORT + "management/prints/printProgressReportAlt.php";
  static final String SCHOOL_PROGRESS_REPORT_ALT_TWO_LINK =
      BASE_URL_PROGRESS_REPORT +
          "management/prints/printProgressReportAltTwo.php";
  static final String SCHOOL_PROGRESS_REPORT_STAFF_PORTRAIT_LINK =
      BASE_URL_PROGRESS_REPORT + "staff/printevaluatetwo.php";
  static final String SCHOOL_PROGRESS_REPORT_STAFF_LAND_SCAPE_LINK =
      BASE_URL_PROGRESS_REPORT + "staff/printevaluate.php";
  static final String SCHOOL_PROGRESS_REPORT_STAFF_CORE_LINK =
      BASE_URL_PROGRESS_REPORT + "staff/printevaluatecore.php";
  static final String SCHOOL_PROGRESS_REPORT_STAFF_NEW_LINK =
      BASE_URL_PROGRESS_REPORT + "staff/printevaluatenew.php";
  static final String SCHOOL_PROGRESS_REPORT_STAFF_PRINT2_LINK =
      BASE_URL_PROGRESS_REPORT + "staff/printProgressRetoptByDivision.php";
}

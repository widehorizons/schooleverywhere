import '../config/flavor_config.dart';
import 'MainConstant.dart';

class TimeTableURL extends MainConstant {
  static final String BASE_URL_TIME_TABLE =
      FlavorConfig.instance.values.baseUrl! +
          "management/prints/printtimetablebyclass.php";
  static final String BASE_URL_TIME_TABLE_STAFF =
      FlavorConfig.instance.values.baseUrl! + "staff/timetableForMobile.php";
}

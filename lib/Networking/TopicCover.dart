import '../config/flavor_config.dart';
import 'MainConstant.dart';

class TopicCover extends MainConstant {
  static final String BASE_URL_TOPIC_COVER =
      FlavorConfig.instance.values.baseUrl! + "student/";
  static final String SCHOOL_TOPIC_COVER_LINK =
      BASE_URL_TOPIC_COVER + "prtcourseoutline.php";
}

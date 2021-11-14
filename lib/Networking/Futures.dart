import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:random_string/random_string.dart';
import '../Modules/Staff.dart';
import '../Constants/StringConstants.dart';
import '../Modules/EventObject.dart';
import '../Modules/Parent.dart';
import '../Modules/Student.dart';
import '../Modules/User.dart';
import '../Networking/ApiConstants.dart';
import '../SharedPreferences/Prefs.dart';

Future<EventObject> login(
    String userName, String password, String type, String token) async {
  String myUrl = ApiConstants.LOGIN_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    Map<String, String> body = {
      "username": userName,
      "password": password,
      "type": type,
      "tokendevice": token,
    };
    print("Request: " + body.toString());
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: body);
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['Success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        dynamic logedUser;
        if (type == STUDENT_TYPE) {
          logedUser = new Student(type: type);
          logedUser.section = mapValue['section'];
        } else if (type == PARENT_TYPE) {
          logedUser = new Parent(type: type);
          logedUser.childrenId = mapValue['childrenId'];
          logedUser.childrenName = mapValue['childrenName'];
          logedUser.childrenSection = mapValue['childrenSection'];
          logedUser.childrenImge = mapValue['childrenImge'];
        } else if (type == STAFF_TYPE) {
          logedUser = new Staff(type: type);
          logedUser.supervisorId = mapValue['Id'];
          logedUser.supervisorStaff = false;
        } else {
          logedUser =
              new User(name: userName, type: type, token: token, id: 'Id');
        }
        if (mapValue['Id'] != null) {
          logedUser.type = mapValue['type'];
          logedUser.name = mapValue['name'];
          logedUser.id = mapValue['Id'];
          logedUser.token = mapValue['authentication'];
          await setUserData(logedUser);
          await setUserType(logedUser.type);
        }
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future logOut(String type, String id) async {
  String myUrl = ApiConstants.LOGOUT_API;
  var response = await http.post(Uri.parse(myUrl),
      headers: {'Accept': 'application/json'}, body: {"type": type, "id": id});
  if (response != null) {
    print('Response status : ${response.statusCode}');
    print('Response body : ${response.body}');
  }
  return 0;
}

Future<EventObject> loginTypeOptions() async {
  String myUrl = ApiConstants.LOGIN_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(
      Uri.parse(myUrl),
      headers: {'Accept': 'application/json'},
    );
    if (response != null) {
      mapValue = json.decode(response.body);
      print("map:" + mapValue.toString());
      if (mapValue['Success']) {
        eventObject.success = true;
        eventObject.object = mapValue["loginType"];
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> academicYearOptions(String studentSection) async {
  String myUrl = ApiConstants.ACADEMIC_YEARS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": studentSection.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue['acadmicYear'];
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> sectionStaffOptions(String id) async {
  String myUrl = ApiConstants.SECTIONS_STAFF_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "id": id.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> sectionOptions(String id) async {
  String myUrl = ApiConstants.SECTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "id": id.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> stageStaffOptions(
    String section, String year, String id) async {
  String myUrl = ApiConstants.STAGE_STAFF_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "year": year.toString(),
      "id": id.toString()
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> gradeStaffOptions(
    String section, String stage, String year, String id) async {
  String myUrl = ApiConstants.GRADE_STAFF_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year.toString(),
      "section": section.toString(),
      "stage": stage.toString(),
      "id": id.toString()
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> semesterOptions(
    String section, String year, String id) async {
  String myUrl = ApiConstants.SEMESTER_API;
  print("Senester selection ===> $myUrl [$section] [$year] [$id]");
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "year": year.toString(),
      "id": id.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> staffSupervisorOptions(String staffId) async {
  String myUrl = ApiConstants.GET_STAFF_SUPERVISOR_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": staffId,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> semesterStaffOptions(
    String section, String stage, String grade, String year) async {
  String myUrl = ApiConstants.SEMESTER_STAFF_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  print(
      "Senester selection ===> $myUrl [$section] [$stage]  [$grade] [$year] ");

  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "year": year.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> classStaffOptions(
    String section, String stage, String grade, String year, String id) async {
  String myUrl = ApiConstants.CLASS_STAFF_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "year": year.toString(),
      "id": id.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> subjectStaffOptions(
    String section,
    String stage,
    String grade,
    String year,
    String id,
    String semester,
    String staffclass) async {
  String myUrl = ApiConstants.SUBJECT_STAFF_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "year": year.toString(),
      "id": id.toString(),
      "semester": semester.toString(),
      "class": staffclass.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> goStudentHome(String id, String academicYear) async {
  String myUrl = ApiConstants.GET_STUDENT_DATA_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "id": id,
      "year": academicYear,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['Success']) {
        Student loggedStudent;
        loggedStudent = await getUserData() as Student;
        if (mapValue['studentClass'] != null) {
          eventObject.success = true;
          eventObject.object = mapValue;
          loggedStudent.stage = mapValue['stage'];
          loggedStudent.grade = mapValue['grade'];
          loggedStudent.studentClass = mapValue['studentClass'];
          await setUserData(loggedStudent);
          return eventObject;
        } else {
          eventObject.success = false;
          eventObject.object = mapValue['message'];
          return eventObject;
        }
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> goParentHome(String id, String academicYear) async {
  String myUrl = ApiConstants.GET_STUDENT_DATA_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "id": id,
      "year": academicYear,
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['Success']) {
        Parent loggedParent;
        loggedParent = await getUserData() as Parent;

        if (mapValue['studentClass'] != null) {
          eventObject.success = true;
          eventObject.object = mapValue;
          loggedParent.stage = mapValue['stage'];
          loggedParent.grade = mapValue['grade'];
          loggedParent.classChild = mapValue['studentClass'];
          await setUserData(loggedParent);
          return eventObject;
        } else {
          eventObject.success = false;
          eventObject.object = mapValue['message'];
          return eventObject;
        }
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> homePageOptions(String type, String Sectionid, String ID,
    String Year, bool checkSupervisor, String? supervisorStaff) async {
  String myUrl;
  var response;
  Map mapValue;
  print(type);
  print(ID.toString());
  print(type);
  print("el section" + Sectionid.toString());
  EventObject eventObject = new EventObject();
  try {
    if (type == STAFF_TYPE) {
      myUrl = ApiConstants.PAGES_STAFF_API;
      response = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json'
      }, body: {
        "section": Sectionid.toString(),
        "staffId": ID.toString(),
        "supervisorStaff": supervisorStaff,
        "checkSupervisor": checkSupervisor.toString(),
        "year": Year.toString(),
      });
    } else if (type == STUDENT_TYPE) {
      myUrl = ApiConstants.PAGES_STUDENT_API;
      response = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json'
      }, body: {
        "id": ID.toString(),
        "year": Year.toString(),
        "section": Sectionid.toString()
      });
    } else if (type == PARENT_TYPE) {
      myUrl = ApiConstants.PAGES_PARENT_API;
      response = await http.post(Uri.parse(myUrl), headers: {
        'Accept': 'application/json'
      }, body: {
        "id": ID.toString(),
        "year": Year.toString(),
        "section": Sectionid.toString()
      });
    } else if (type == MANAGEMENT_TYPE) {
      myUrl = ApiConstants.PAGES_MANAGEMENT_API;

      response = await http.post(Uri.parse(myUrl),
          headers: {'Accept': 'application/json'},
          body: {"staffId": ID.toString()});
    }

    if (response != null) {
      print('Response status : ${response.statusCode}');
      var mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getDivisionTopicsCovered(String section, String year,
    String stage, String grade, String subject) async {
  String myUrl = ApiConstants.GET_TOPICS_COVERED_DIVISION_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "subject": subject
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getSubjectReceiveFromTeacher(String section, String year,
    String stage, String grade, String semester) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_Subject_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getReceiveFromTeacherTeacher(
    String section,
    String year,
    String stage,
    String grade,
    String semester,
    String subject,
    String ClassStudent) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_Teacher_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "subject": subject,
      "class": ClassStudent
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getReceiveFromTeacherShow(
    String section,
    String year,
    String stage,
    String grade,
    String semester,
    String subject,
    String Staffid,
    String ClassStudent) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_RECEIVE_FROM_TEACHER_API;
  print(
      "[getReceiveFromTeacherShow] ==> Body{$section, $year , $stage , $grade , $semester , $subject , $Staffid , $ClassStudent} URL: $myUrl");
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "subject": subject,
      "satffid": Staffid,
      "class": ClassStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getTopicsCoveredDates(String section, String year,
    String stage, String grade, String type) async {
  String myUrl = ApiConstants.GET_TOPICS_COVERED_STAFF_DATE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "type": type
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> previousStaffTopics(
    String section,
    String year,
    String stage,
    String grade,
    String staffClass,
    String subject,
    String id,
    String dateId) async {
  String myUrl = ApiConstants.GET_TOPICS_COVERED_STAFF_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "class": staffClass,
      "subject": subject,
      "staffid": id,
      "selectdate": dateId
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getMailStudent(String userID, String year) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_MailBox_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": userID.toString(),
      "year": year.toString(),
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> seenMessageMailBox(String id) async {
  String myUrl = ApiConstants.SeenMessage_MailBox_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "id": id.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> previousStudentTopics(String section, String year,
    String stage, String grade, String studentClass, String dateId) async {
  String myUrl = ApiConstants.GET_TOPICS_COVERED_STUDENT_API;
  Map mapValue;
  print(section);
  print(year);
  print(stage);
  print(grade);
  print(studentClass);
  print(dateId);
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "selectdate": dateId,
      "studentClass": studentClass
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> deleteTopicsCovered(String topicId) async {
  String myUrl = ApiConstants.DELETE_TOPICS_COVERED_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": topicId});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> editTopicsCovered(String topicId, String comment) async {
  String myUrl = ApiConstants.EDIT_TOPICS_COVERED_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"id": topicId, "comment": comment});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> addTopicsCovered(
    String staffId,
    String section,
    String year,
    String stage,
    String grade,
    List staffClassArr,
    String subject,
    String dateId,
    List divisionArr,
    List commentArr) async {
  String myUrl = ApiConstants.ADD_TOPICS_COVERED_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    dynamic division = jsonEncode(divisionArr);
    dynamic comment = jsonEncode(commentArr);
    dynamic selectedClass = jsonEncode(staffClassArr);
    Map<String, String> body = {
      "staffid": staffId,
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "class": selectedClass,
      "subject": subject,
      "selectdate": dateId,
      "division": division,
      "comment": comment
    };
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: body);
    if (response != null) {
      print('Response status : ${response.statusCode}');
      mapValue = json.decode(response.body);
      print('Response body : ' + mapValue.toString());
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> uploadFile(List selectedFile, url) async {
  // open a bytestream
  var response, i, uri;
  List namesrandom = [];
  for (i = 0; i < selectedFile.length; i++) {
    String Newname =
        randomNumeric(12).toString() + path.basename(selectedFile[i].path);
    print(Newname);
    namesrandom.add(Newname);
    var stream =
        new http.ByteStream(DelegatingStream.typed(selectedFile[i].openRead()));
    // get file length
    var length = await selectedFile[i].length();
    // string to uri
    uri = Uri.parse(url);

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile =
        new http.MultipartFile('file', stream, length, filename: Newname);

    // add file to multipart
    request.files.add(multipartFile);

    // send
    response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      //  print(value);
    });
  }
  if (response != null) {
    return namesrandom;
  } else {
    print("NewListName: noResponse");
    return false;
  }
}

addSendToClass(
    List fileslist,
    String comment,
    String staffId,
    String staffName,
    String year,
    String section,
    String stage,
    String grade,
    List staffClass,
    String semester,
    String subject) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_SEND_TO_CLASS_API;
  Map mapValue;
  try {
    dynamic files = jsonEncode(fileslist);
    dynamic classes = jsonEncode(staffClass);
    print(files.toString());
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "FileName": files,
      "Comment": comment,
      "StaffId": staffId,
      "StaffName": staffName,
      "SectionId": section,
      "StageId": stage,
      "GradeId": grade,
      "SemesterId": semester,
      "ClassId": classes,
      "SubjectId": subject,
      "Year": year,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

//////////////////////////////////////////////////////////////////////////
Future<EventObject> getUserDataRec(String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.GET_STUDENT_OF_RECEIVE_FROM_TEACHER_DATA_API;
  print("Fetching Audio API ==== > [$myUrl] [$id]");
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

//####################Chat Reply test ##########
Future<EventObject> getStudentMessages(String messageId, String regno) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.STUDENT_CHAT_MESSAGES;
  print("Fetching Studnt Replies API ==== > [$myUrl] [$messageId]  [$regno]");
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"id": messageId, "regno": regno});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> readReplySentToClass(
    String messageId, String regno, String staffid) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.READ_REPLY_SENT_TO_CLASS;
  print(
      "Fetching Studnt Replies API for Staff ==== > [$myUrl] [$messageId]  [$regno] [$staffid]");
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"mainid": messageId, "regno": regno, "staffid": staffid});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

SeenMessage_ReceiveFromTeacher(
    String id,
    String regno,
    String year,
    String section,
    String stage,
    String grade,
    String classStudent,
    String semester) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_RECEIVE_FROM_TEACHER_DATA_SEEN_API;
  print("id" + id);
  print("regno" + regno);
  print("semester" + semester);
  print("section" + section);
  print("stage" + stage);
  print("grade" + grade);
  print("class" + classStudent);
  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "id": id,
    "regno": regno,
    "semester": semester,
    "section": section,
    "stage": stage,
    "grade": grade,
    "class": classStudent,
    "year": year
  });
  print("respSeen " + response.toString());
  if (response != null) {
    return true;
  } else {
    return false;
  }
}

Future<EventObject> getManagersId(String section, String stage) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  var myUrl = ApiConstants.MAIL_INBOX_STUDENT_MANAGER_DATA_API;
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> getStaffManagersId() async {
  var myUrl = ApiConstants.MAIL_INBOX_STAFF_MANAGER_DATA_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";

  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getTeacherId(String section, String stage, String garde,
    String classid, String year) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  var myUrl = ApiConstants.Teacher_Data_Mail_Inbox_API;
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": garde,
      "class": classid,
      "year": year
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> addMailIboxStudent(
    List fileslist,
    List manger,
    List teacher,
    String regno,
    String username,
    String title,
    String message,
    String year,
    String section,
    String stage,
    String grade,
    String studentClass,
    String id,
    String type) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_MAIL_INBOX_STUDENT_API;
  dynamic files = jsonEncode(fileslist);
  dynamic staff = jsonEncode(teacher);
  dynamic mang = jsonEncode(manger);
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "FileName": files,
      "managers": mang,
      "teachers": staff,
      "regnum": regno,
      "username": username,
      "title": title,
      "message": message,
      "Section": section,
      "Stage": stage,
      "Grade": grade,
      "Class": studentClass,
      "yearmk": year,
      "id": id,
      "httype": type
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> ReplyMailIboxStudent(
    List fileslist,
    String idmesg,
    String title,
    String message,
    String year,
    String section,
    String stage,
    String grade,
    String studentClass,
    String id,
    String type) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  print("idmessage" + idmesg);
  print("title" + title);
  print("message" + message);
  print("year" + year);
  print("section" + section);
  print("stage" + stage);
  print("grade" + grade);
  print("id" + id);
  print("type" + type);

  String myUrl = ApiConstants.REPLY_MAIL_INBOX_STUDENT_API;
  try {
    dynamic files = jsonEncode(fileslist);
    Map body = {
      "FileName": files,
      "title": title,
      "message": message,
      "Section": section,
      "Stage": stage,
      "Grade": grade,
      "Class": studentClass,
      "yearmk": year,
      "id": id,
      "httype": type,
      "idmesg": idmesg
    };
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: body);
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
  return eventObject;
}

Future<EventObject> getMessageDetails(
    String msgId, String section, String flag) async {
  String myUrl = ApiConstants.GET_MESSAGE_DETAILS_API;
  print("urlm" + myUrl);
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"id": msgId, "section": section, "flag": flag});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> studentRouteOptions(String studentId, String year,
    String semester, String section, String stage) async {
  print(studentId.toString());
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.GET_STUDENT_ROUTE_API;
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": studentId.toString(),
      "year": year.toString(),
      "semister": semester.toString(),
      "section": section.toString(),
      "stage": stage.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> studentPeriodOptions(String id, String year) async {
  print(id.toString());
  String myUrl = ApiConstants.GET_STUDENT_PERIOD_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "id": id.toString(),
      "year": year.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> GetDriver(
    String routeid, String periodid, String year, String section) async {
  String myUrl = ApiConstants.GET_DRIVER_ID_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "bus": routeid.toString(),
      "periodid": periodid.toString(),
      "year": year.toString(),
      "section": section.toString(),
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> getStudentOfStaffMailInboxId(String section, String stage,
    String garde, String classid, String year) async {
  var myUrl = ApiConstants.STUDENT_OF_STAFF_MAIL_INBOX_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": garde,
      "class": classid,
      "year": year
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> getParentOfStaffMailInboxId(String section, String stage,
    String garde, String classid, String year) async {
  var myUrl = ApiConstants.PARENT_OF_STAFF_MAIL_INBOX_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": garde,
      "class": classid,
      "year": year
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

addMailInboxStaff(
    List filesList,
    String year,
    String id,
    List studentList,
    List manger,
    List parentList,
    String title,
    String message,
    String regno) async {
  String myUrl = ApiConstants.ADD_MAIL_INBOX_STAFF_API;
  dynamic files = jsonEncode(filesList);
  dynamic studentListEncode = jsonEncode(studentList);
  dynamic parentListEncode = jsonEncode(parentList);
  dynamic mangerEncode = jsonEncode(manger);
  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "FileName": files,
    "year": year,
    "staffid": id,
    "regnum": studentListEncode,
    "title": title,
    "message": message,
    "managers": mangerEncode,
    "regno": regno,
    "parentid": parentListEncode
  });
  if (response != null) {
    print('Response status : ${response.statusCode}');
    print('Response bodyssss : ${response.body}');
    return true;
  } else {
    print("addSendToClass: noResponse");
    return false;
  }
}

Future<EventObject> getSentMails(String userID, String year) async {
  String myUrl = ApiConstants.GET_SENT_OF_MAILBOX_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": userID.toString(),
      "year": year.toString(),
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getSentMessageDetails(String msgId) async {
  String myUrl = ApiConstants.GET_SENT_MESSAGE_DETAILS_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": msgId});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> viewLessons(
    String section,
    String year,
    String stage,
    String grade,
    String semester,
    String subject,
    String staffId,
    String classStudent) async {
  String myUrl = ApiConstants.GET_VIDEO_LESSONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "subject": subject,
      "staffid": staffId,
      "class": classStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getLessonDetails(
    String msgId, String tableName, String academicyear, String regno) async {
  String myUrl = ApiConstants.GET_LESSONS_DETAILS_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  print("TABLE NAME ==== > [$myUrl]");
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "id": msgId,
      "tableName": tableName,
      "academicyear": academicyear,
      "regno": regno
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

addAssignments(
    List fileslist,
    String datefrom,
    String dateto,
    String comment,
    String staffId,
    String staffName,
    String year,
    String section,
    String stage,
    String grade,
    List staffClass,
    String semester,
    String subject) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_ASSIGNMENTS_API;
  Map mapValue;
  try {
    dynamic files = jsonEncode(fileslist);
    dynamic classes = jsonEncode(staffClass);
    print(files.toString());
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "FileName": files,
      "dateFrom": datefrom,
      "dateTo": dateto,
      "Comment": comment,
      "StaffId": staffId,
      "StaffName": staffName,
      "SectionId": section,
      "StageId": stage,
      "GradeId": grade,
      "SemesterId": semester,
      "ClassId": classes,
      "SubjectId": subject,
      "Year": year,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getStudentId(String section, String stage, String grade,
    String classid, String year) async {
  String myUrl = ApiConstants.STUDENT_OF_STAFF_MAIL_INBOX_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classid,
      "year": year
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> addAttendance(
    String id,
    String section,
    String year,
    String stage,
    String grade,
    String classid,
    String subject,
    List StudentSelectedPresent,
    List StudentSelectedExcuse,
    List StudentSelectedLate,
    List StudentSelectedMedical,
    List StudentSelectedAbsent,
    List StudentSelectedOD,
    String Date,
    String Semester) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_ATTENDANCE_STUDENT_API;
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "Present": jsonEncode(StudentSelectedPresent),
      "Excuse": jsonEncode(StudentSelectedExcuse),
      "Late": jsonEncode(StudentSelectedLate),
      "OD": jsonEncode(StudentSelectedOD),
      "Medical": jsonEncode(StudentSelectedMedical),
      "Absent": jsonEncode(StudentSelectedAbsent),
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classid,
      "year": year,
      "staffID": id,
      "date": Date,
      "semister": Semester,
      "subject": subject
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getTimeTable(String section, String year, String stage,
    String grade, String studentClass, String semester) async {
  String myUrl = ApiConstants.GET_TIME_TABLE_STUDENT_DATE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "studentClass": studentClass,
      "semester": semester
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getAssignmentsShow(
    String section,
    String year,
    String stage,
    String grade,
    String semester,
    String subject,
    String Staffid,
    String ClassStudent) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_ASSIGNMENTS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "subject": subject,
      "satffid": Staffid,
      "class": ClassStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getUserDataAssignments(String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.GET_STUDENT_OF_ASSIGNMENTS_DATA_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getStaffTimeTable(String section, String year, String stage,
    String grade, String staffClass, String semester, String staffId) async {
  String myUrl = ApiConstants.GET_TIME_TABLE_STAFF_DATE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "staffClass": staffClass,
      "semester": semester,
      "staffId": staffId
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getChangeLoginUserName(String type, String userId) async {
  String myUrl = ApiConstants.GET_CHANGE_LOGIN_USER_NAME_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"type": type, "userId": userId});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> changeUserNameAndPassword(
    String type, String userId, String userName, String password) async {
  String myUrl = ApiConstants.CHANGE_LOGIN_USERNAME_AND_PASSWORD_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "type": type,
      "userId": userId,
      "userName": userName,
      "password": password
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getStudentAttendance(
    String id, String year, String month) async {
  var myUrl = ApiConstants.STUDENT_OF_ATTANDEC_API;
  print(id);
  print(year);
  print(month);
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"regno": id, "year": year, "month": month});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStudentMeetingtMeeting(String id, String year) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.MEETING_STUDENT_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"year": year, "regno": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getStaffMeetingPartOne(String id, String year) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.MEETING_STAFF_ONE_API;
  print(year);
  print(id);
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"year": year, "staff": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;

        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getStaffMeetingPartTwo(String id, String year) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.MEETING_STAFF_TWO_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"year": year, "staff": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      print("sss" + mapValue.toString());
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;

        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> getInstallment() async {
  var myUrl = ApiConstants.STUDENT_INSTALLMENT_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http
        .post(Uri.parse(myUrl), headers: {'Accept': 'application/json'});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getFeesData(
    String section, String year, String id, String installmentId) async {
  var myUrl = ApiConstants.STUDENT_FEES_DATA_API;
  print("get Fees link == > ${myUrl}");
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "regno": id,
      "installmentid": installmentId
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getAutomaticTimeTable(String section, String year,
    String stage, String grade, String studentClass, String semester) async {
  String myUrl = ApiConstants.GET_AUTOMATIC_TIME_TABLE_STUDENT_DATE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "studentClass": studentClass,
      "semester": semester
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStaffAutomaticTimeTable(
    String section,
    String year,
    String stage,
    String grade,
    String staffClass,
    String semester,
    String staffId) async {
  String myUrl = ApiConstants.GET_AUTOMATIC_TIME_TABLE_STAFF_DATE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "stage": stage,
      "grade": grade,
      "staffClass": staffClass,
      "semester": semester,
      "staffId": staffId
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getDateOptions(String section, String year, String stage,
    String grade, String PageType) async {
  String myUrl = ApiConstants.GET_STUDENT_PROGRESS_REPORTS_DATE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "year": year.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "PageType": PageType,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getReportOptions(String section, String year, String stage,
    String grade, String PageType) async {
  String myUrl = ApiConstants.GET_STUDENT_PROGRESS_REPORTS_NAME_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "year": year.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "PageType": PageType,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getMonthOptions(
    String section,
    String year,
    String semester,
    String stage,
    String grade,
    String stuclass,
    String regno) async {
  String myUrl = ApiConstants.GET_STUDENT__REPORTS_CARD_MONTH_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "year": year.toString(),
      "stage": stage.toString(),
      "semister": semester.toString(),
      "grade": grade.toString(),
      "class": stuclass.toString(),
      "regno": regno.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getCard4MonthOptions(
    String section,
    String year,
    String semester,
    String stage,
    String grade,
    String stuclass,
    String regno) async {
  String myUrl = ApiConstants.GET_STUDENT__REPORTS_CARD4_MONTH_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "year": year.toString(),
      "stage": stage.toString(),
      "semister": semester.toString(),
      "grade": grade.toString(),
      "class": stuclass.toString(),
      "regno": regno.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getBusDetails(String section, String year, String id) async {
  var myUrl = ApiConstants.STUDENT_BUS_DETAILS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"section": section, "year": year, "regno": id});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStudentProgressPreport(String section, String stage,
    String garde, String classid, String year) async {
  var myUrl = ApiConstants.STUDENT_OF_STAFF_STUDENT_PROGRESS_REPORT_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": garde,
      "class": classid,
      "year": year
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> previousMaintenanceProblems(String id, String year) async {
  var myUrl = ApiConstants.PREVIOUS_MAINTENANCE_PROBLEMS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"year": year, "staffID": id});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getBuildingAndProblemOptions() async {
  var myUrl = ApiConstants.MAINTENANCE_BUILDING_AND_PROBLEMS_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http
        .post(Uri.parse(myUrl), headers: {'Accept': 'application/json'});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getMaintenancePlaceOptions(String buildingId) async {
  var myUrl = ApiConstants.MAINTENANCE_PLACE_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"buildingId": buildingId});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getMaintenanceSubPlaceOptions(
    String buildingId, String placeId) async {
  var myUrl = ApiConstants.MAINTENANCE_SUB_PLACE_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"buildingId": buildingId, "placeId": placeId});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getMaintenanceDeviceOptions(
    String buildingId, String placeId, String subPlaceId) async {
  var myUrl = ApiConstants.MAINTENANCE_DEVICE_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "buildingId": buildingId,
      "placeId": placeId,
      "subPlaceId": subPlaceId
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> addMaintenanceProblem(
    String buildingId,
    String placeId,
    String subPlaceId,
    String deviceId,
    String description,
    String problem,
    String year,
    String staffId,
    String section) async {
  var myUrl = ApiConstants.ADD_MAINTENANCE_PROBLEM_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "buildingId": buildingId,
      "placeId": placeId,
      "subPlaceId": subPlaceId,
      "deviceId": deviceId,
      "description": description,
      "problem": problem,
      "year": year,
      "staffId": staffId,
      "section": section
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> viewCambridgeDegree(
    String section, String year, String userId, String sessionId) async {
  String myUrl = ApiConstants.VIEW_CAMBRIDGE_DEGREE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "userId": userId,
      "sessionId": sessionId
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getSessionCamb(String section, String year, String stage,
    String grade, String regno) async {
  var myUrl = ApiConstants.GET_SESSION_CAMBRIDGE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
      "regno": regno
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> viewDropSubjects(
    String section, String year, String userId, String sessionId) async {
  String myUrl = ApiConstants.VIEW_CAMBRIDGE_DROP_SUBJECTS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "userId": userId,
      "sessionId": sessionId
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getSubjectForSession(String section, String year, String stage,
    String grade, String regno, String sessionid) async {
  var myUrl = ApiConstants.GET_SUBJECT_REGISTED_CAMBRIDGE_API;
  print(
      "[Cambridge Registrstion] ==> Url { $myUrl } with Data : {$section , $year , $stage , $grade , $regno , $sessionid }");
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
      "regno": regno,
      "sessionid": sessionid
    });
    if (response != null) {
      mapValue = json.decode(response.body);

      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getGetSubSubjectForSession(
    String section,
    String year,
    String stage,
    String grade,
    String regno,
    String sessionid,
    String subjectid) async {
  var myUrl = ApiConstants.GET_SUB_SUBJECT_REGISTED_CAMBRIDGE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
      "regno": regno,
      "sessionid": sessionid,
      "subjectid": subjectid
    });
    if (response != null) {
      mapValue = json.decode(response.body);

      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getStatusSubjectForSession(
    String section,
    String year,
    String stage,
    String grade,
    String regno,
    String sessionid,
    String subjectid) async {
  var myUrl = ApiConstants.GET_SUBJECT_STATUS_REGISTED_CAMBRIDGE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
      "regno": regno,
      "sessionid": sessionid,
      "subjectid": subjectid
    });
    if (response != null) {
      mapValue = json.decode(response.body);

      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> AddCambrigeRegistration(
    String section,
    String year,
    String stage,
    String grade,
    String regno,
    String sessionid,
    String subjectid,
    String subsubjectid,
    String status) async {
  var myUrl = ApiConstants.ADD_REGISTED_CAMBRIDGE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  print(year);
  print(section);
  print(stage);
  print(grade);
  print(regno);
  print(sessionid);
  print(subjectid);
  print(subsubjectid);
  print(status);
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
      "regno": regno,
      "sessionid": sessionid,
      "subjectid": subjectid,
      "subsubjectid": subsubjectid,
      "status": status
    });
    if (response != null) {
      mapValue = json.decode(response.body);

      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

addDropSubjects(String section, String year, String userId, String sessionId,
    List subjects) async {
  String myUrl = ApiConstants.ADD_CAMBRIDGE_DROP_SUBJECTS_API;
  dynamic subjectsEncode = jsonEncode(subjects);
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "year": year,
      "userId": userId,
      "sessionId": sessionId,
      "subjectId": subjectsEncode
    });
    if (response != null) {
      mapValue = json.decode(response.body);

      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getColumnForSessionConf(String section, String year,
    String stage, String grade, String regno, String sessionid) async {
  var myUrl = ApiConstants.GET_COLUMN_CAMBRIDGE_CONFIRMATION_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
      "regno": regno,
      "sessionid": sessionid
    });
    if (response != null) {
      mapValue = json.decode(response.body);

      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> addCambrigeRegistrationConf(
    String section, String year, String regno, String sessionid) async {
  var myUrl = ApiConstants.ADD_REGISTED_CAMBRIDGE_CONFIRMATION_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  print(year);
  print(section);
  print(regno);
  print(sessionid);
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "regno": regno,
      "sessionid": sessionid,
    });
    if (response != null) {
      mapValue = json.decode(response.body);

      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> addBySelect(
  List filesList,
  String year,
  String id,
  String section,
  String stage,
  String grade,
  String classselected,
  String title,
  String message,
) async {
  String myUrl = ApiConstants.ADD_BY_SELECT_MANAGEMENT_API;
  dynamic files = jsonEncode(filesList);

  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "FileName": files,
    "yearmk": year,
    "staffid": id,
    "title": title,
    "message": message,
    "section": section,
    "stage": stage,
    "grade": grade,
    "class": classselected
  });
  if (response != null) {
    print('Response status : ${response.statusCode}');
    print('Response bodyssss : ${response.body}');
    return true;
  } else {
    print("addSendToClass: noResponse");
    return false;
  }
}

Future<dynamic> uploadTimeTable(
  List filesList,
  String year,
  String section,
  String stage,
  String grade,
  String classselected,
  String semester,
) async {
  String myUrl = ApiConstants.ADD_UPLOADED_TIME_TABLE_API;
  dynamic files = jsonEncode(filesList);

  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "file": files,
    "year": year,
    "semester": semester,
    "section": section,
    "stage": stage,
    "grade": grade,
    "class": classselected
  });
  if (response != null) {
    print('Response status : ${response.statusCode}');
    print('Response bodyssss : ${response.body}');
    return true;
  } else {
    print("addSendToClass: noResponse");
    return false;
  }
}

Future<EventObject> stageManagmentOptions(
    String section, String year, String id) async {
  String myUrl = ApiConstants.STAGE_MANAGEMENT_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "year": year.toString(),
      "id": id.toString()
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> gradeManagementOptions(
    String section, String stage, String year, String id) async {
  String myUrl = ApiConstants.GRADE_MANAGEMENT_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year.toString(),
      "section": section.toString(),
      "stage": stage.toString(),
      "id": id.toString()
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> classManagenemtOptions(
    String section, String stage, String grade, String year, String id) async {
  String myUrl = ApiConstants.CLASS_MANAGEMENT_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "year": year.toString(),
      "id": id.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getStudentOfAdvancedManagement(
    String section,
    String stage,
    String garde,
    String classid,
    String year,
    String date,
    String name,
    String mobile,
    String email,
    String reg) async {
  var myUrl = ApiConstants.STUDENT_OF_ADVANCED_MANAGEMENT_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    if (stage == null) stage;
    if (garde == null) garde;
    if (classid == null) classid;
    if (date == null) date;
    if (name == null) name;
    if (mobile == null) mobile;
    if (email == null) email;
    if (reg == null) reg;
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": garde,
      "class": classid,
      "year": year,
      "date": date,
      "name": name,
      "mobile": mobile,
      "email": email,
      "regno": reg
    });

    if (response != null) {
      Map mapValue = json.decode(response.body);
      print("result " + mapValue.toString());
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> addAdvanced(List filesList, String year, String id,
    String section, String title, String message, List studentList) async {
  String myUrl = ApiConstants.ADD_ADVANCED_MANAGEMENT_API;
  dynamic files = jsonEncode(filesList);
  dynamic studentListEncode = jsonEncode(studentList);
  print(year);
  print(id);
  print(title);
  print(message);
  print(section);
  print(studentListEncode);
  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "FileName": files,
    "yearmk": year,
    "staffid": id,
    "title": title,
    "message": message,
    "section": section,
    "regno": studentListEncode,
  });
  if (response != null) {
    print('Response status : ${response.statusCode}');
    print('Response bodyssss : ${response.body}');
    return true;
  } else {
    print("addSendToClass: noResponse");
    return false;
  }
}

Future<EventObject> depOneOptions() async {
  String myUrl = ApiConstants.DEP_ONE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> depTwoOptions(String deponeid) async {
  String myUrl = ApiConstants.DEP_TWO_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"deponeid": deponeid.toString()});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> depThreeOptions(String deponeid, String deptwoid) async {
  String myUrl = ApiConstants.DEP_THREE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "deponeid": deponeid.toString(),
      "deptwoid": deptwoid.toString()
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> depFourOptions(
    String deponeid, String deptwoid, String depthree) async {
  String myUrl = ApiConstants.DEP_FOUR_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "deponeid": deponeid.toString(),
      "deptwoid": deptwoid.toString(),
      "depthree": depthree.toString()
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

addStaffMail(
    List filesList,
    String year,
    String id,
    String title,
    String message,
    String recid,
    String deponeid,
    String deptwoid,
    String depthreeid,
    String depfourid) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_STAFF_MAIL_API;
  Map mapValue;
  try {
    dynamic files = jsonEncode(filesList);
    if (deponeid == null) deponeid;
    if (deptwoid == null) deptwoid;
    if (depthreeid == null) depthreeid;
    if (depfourid == null) depfourid;
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "FileName": files,
      "year": year,
      "staffid": id,
      "title": title,
      "message": message,
      "recid": recid,
      "deponeid": deponeid,
      "deptwoid": deptwoid,
      "depthreeid": depthreeid,
      "depfourid": depfourid
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> addSMS(String year, String id, String section, String message,
    List studentList) async {
  String myUrl = ApiConstants.ADD_SMS_MANAGEMENT_API;
  dynamic studentListEncode = jsonEncode(studentList);

  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "yearmk": year,
    "staffid": id,
    "message": message,
    "section": section,
    "regno": studentListEncode,
  });
  if (response != null) {
    print('Response status : ${response.statusCode}');
    print('Response bodyssss : ${response.body}');
    return true;
  } else {
    print("addSendToClass: noResponse");
    return false;
  }
}

Future<EventObject> classManagenemtOptionsList(
    String section, String stage, String grade, String year, String id) async {
  String myUrl = ApiConstants.CLASS_MANAGEMENT_LIST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "year": year.toString(),
      "id": id.toString(),
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> addByClass(
  List filesList,
  String year,
  String id,
  String section,
  String stage,
  String grade,
  List classselected,
  String title,
  String message,
) async {
  String myUrl = ApiConstants.ADD_BY_CLASS_MANAGEMENT_API;
  dynamic files = jsonEncode(filesList);
  dynamic classes = jsonEncode(classselected);
  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "FileName": files,
    "yearmk": year,
    "staffid": id,
    "title": title,
    "message": message,
    "section": section,
    "stage": stage,
    "grade": grade,
    "class": classes
  });
  if (response != null) {
    print('Response status : ${response.statusCode}');
    print('Response bodyssss : ${response.body}');
    return true;
  } else {
    print("addSendToClass: noResponse");
    return false;
  }
}

Future<EventObject> addManagementAttendance(
    String id,
    String section,
    String year,
    String stage,
    String grade,
    String classid,
    List StudentSelectedPresent,
    List StudentSelectedExcuse,
    List StudentSelectedLate,
    List StudentSelectedMedical,
    List StudentSelectedAbsent,
    List StudentSelectedOD,
    String Date) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_MANAGEMENT_Attendance_API;
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "Present": jsonEncode(StudentSelectedPresent),
      "Excuse": jsonEncode(StudentSelectedExcuse),
      "Late": jsonEncode(StudentSelectedLate),
      "OD": jsonEncode(StudentSelectedOD),
      "Medical": jsonEncode(StudentSelectedMedical),
      "Absent": jsonEncode(StudentSelectedAbsent),
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classid,
      "year": year,
      "staffID": id,
      "date": Date
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> typeProgressReport(
    String studentSection, String studentYear, String PageType) async {
  String myUrl;
  myUrl = ApiConstants.TYPE_PROGRESS_REPORT_API;

  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": studentSection.toString(),
      "year": studentYear.toString(),
      "pagetype": PageType,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue['typename'];
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

addLessonsByClass(
    List fileslist,
    String title,
    String description,
    String part,
    String link,
    String staffId,
    String staffName,
    String year,
    String section,
    String stage,
    String grade,
    List staffClass,
    String semester,
    String subject) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_LESSONS_BY_CLASS_API;
  Map mapValue;
  try {
    dynamic files = jsonEncode(fileslist);
    dynamic classes = jsonEncode(staffClass);
    print(files.toString());
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "FileName": files,
      "title": title,
      "description": description,
      "part": part,
      "link": link,
      "StaffId": staffId,
      "StaffName": staffName,
      "SectionId": section,
      "StageId": stage,
      "GradeId": grade,
      "SemesterId": semester,
      "ClassId": classes,
      "SubjectId": subject,
      "Year": year,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> typeProgressReportAlt(
    String studentSection, String studentYear) async {
  String myUrl = ApiConstants.TYPE_PROGRESS_REPORT_API_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": studentSection.toString(),
      "year": studentYear.toString()
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue['typename'];
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getLeaveTypeOptions() async {
  String myUrl = ApiConstants.LEAVE_TYPE_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http
        .post(Uri.parse(myUrl), headers: {'Accept': 'application/json'});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getLeaveNameOptions(String typeId) async {
  String myUrl = ApiConstants.LEAVE_NAME_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "typeId": typeId,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> addLeaveRequest(
    String staffId,
    String myYear,
    String typeId,
    String nameId,
    String reason,
    String date,
    String from,
    String to) async {
  String myUrl = ApiConstants.ADD_LEAVE_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": staffId,
      "myyear": myYear,
      "typeId": typeId,
      "nameId": nameId,
      "reason": reason,
      "date": date,
      "from": from,
      "to": to,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> addUnPaidLeaveRequest(
    String staffId,
    String myYear,
    String typeId,
    String nameId,
    String reason,
    String date,
    String from,
    String to) async {
  String myUrl = ApiConstants.ADD_UN_PAID_LEAVE_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": staffId,
      "myyear": myYear,
      "typeId": typeId,
      "nameId": nameId,
      "reason": reason,
      "date": date,
      "from": from,
      "to": to,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getVacationTypeOptions() async {
  String myUrl = ApiConstants.VACATION_TYPE_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http
        .post(Uri.parse(myUrl), headers: {'Accept': 'application/json'});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getVacationNameOptions(String typeId) async {
  String myUrl = ApiConstants.VACATION_NAME_OPTIONS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "typeId": typeId,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> addVacationRequest(String staffId, String myYear,
    String typeId, String nameId, String reason, String from, String to) async {
  String myUrl = ApiConstants.ADD_VACATION_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": staffId,
      "myyear": myYear,
      "typeId": typeId,
      "nameId": nameId,
      "reason": reason,
      "from": from,
      "to": to,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> addUnPaidVacationRequest(String staffId, String myYear,
    String typeId, String nameId, String reason, String from, String to) async {
  String myUrl = ApiConstants.ADD_UN_PAID_VACATION_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": staffId,
      "myyear": myYear,
      "typeId": typeId,
      "nameId": nameId,
      "reason": reason,
      "from": from,
      "to": to,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> previousLeaveRequest(
    String id, String dateFrom, String dateTo) async {
  var myUrl = ApiConstants.PREVIOUS_LEAVE_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": id,
      "datefrom": dateFrom,
      "dateTo": dateTo,
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> deleteLeaveRequest(List leaveRequests) async {
  String myUrl = ApiConstants.DELETE_LEAVE_REQUEST_API;
  dynamic leaveRequestsEncode = jsonEncode(leaveRequests);
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"leaveRequests": leaveRequestsEncode});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> unPaidPreviousLeaveRequest(
    String id, String dateFrom, String dateTo) async {
  var myUrl = ApiConstants.PREVIOUS_UN_PAID_LEAVE_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": id,
      "datefrom": dateFrom,
      "dateTo": dateTo,
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> unPaidDeleteLeaveRequest(List leaveRequests) async {
  String myUrl = ApiConstants.DELETE_UN_PAID_LEAVE_REQUEST_API;
  dynamic leaveRequestsEncode = jsonEncode(leaveRequests);
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"leaveRequests": leaveRequestsEncode});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> previousVacationRequest(
    String id, String dateFrom, String dateTo) async {
  var myUrl = ApiConstants.PREVIOUS_VACATION_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": id,
      "datefrom": dateFrom,
      "dateTo": dateTo,
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> deleteVacationRequest(List vacationRequests) async {
  String myUrl = ApiConstants.DELETE_VACATION_REQUEST_API;
  dynamic vacationRequestsEncode = jsonEncode(vacationRequests);
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"vacationRequests": vacationRequestsEncode});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> unPaidPreviousVacationRequest(
    String id, String dateFrom, String dateTo) async {
  var myUrl = ApiConstants.PREVIOUS_UN_PAID_VACATION_REQUEST_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "staffId": id,
      "datefrom": dateFrom,
      "dateTo": dateTo,
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> unPaidDeleteVacationRequest(List unPaidVacationRequests) async {
  String myUrl = ApiConstants.DELETE_UN_PAID_VACATION_REQUEST_API;
  dynamic unPaidVacationRequestsEncode = jsonEncode(unPaidVacationRequests);
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"unpaidvacationRequests": unPaidVacationRequestsEncode});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getClassStaffData(
    String section, String stage, String grade, String year, String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  var myUrl = ApiConstants.CLASS_STAFF_DATA_API;
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section.toString(),
      "stage": stage.toString(),
      "grade": grade.toString(),
      "year": year.toString(),
      "id": id.toString()
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getLiveStream(String userID, String year, String section,
    String stage, String grade, String classst, String usersemester) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_LIVE_STREAM_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": userID.toString(),
      "year": year.toString(),
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classst,
      "usersemester": usersemester
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStudentMeeting(String id, String year) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.MEETING_STUDENT_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"year": year, "regno": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> getChannelLink(String section, String stage, String grade,
    String year, String staffId, String subject) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.GET_LIVE_STREAM_CHANNEL_API;
  Map mapValue;
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "StaffId": staffId,
      "SectionId": section,
      "StageId": stage,
      "GradeId": grade,
      "SubjectId": subject,
      "Year": year,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> addLiveStream(
    String title,
    String staffId,
    String year,
    String section,
    String stage,
    String grade,
    List staffClass,
    String subject) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_LIVE_STREAM_API;
  Map mapValue;
  try {
    dynamic classes = jsonEncode(staffClass);
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "title": title,
      "StaffId": staffId,
      "SectionId": section,
      "StageId": stage,
      "GradeId": grade,
      "ClassId": classes,
      "SubjectId": subject,
      "Year": year,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> ReplyAssignmentStudent(
    List fileslist, String message, String idAssignment, String regno) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";

  String myUrl = ApiConstants.REPLY_ASSIGNMENT_STUDENT_API;
  try {
    dynamic files = jsonEncode(fileslist);
    Map body = {
      "FileName": files,
      "message": message,
      "idAssignment": idAssignment,
      "regno": regno,
    };
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: body);
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
  return eventObject;
}

Future<EventObject> getTeacherReplyAssignments(
    String section,
    String year,
    String stage,
    String grade,
    String ClassStudent,
    String semester,
    String studentId) async {
  String myUrl = ApiConstants.GET_TEACHER_REPLY_OF_ASSIGNMENTS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "regno": studentId,
      "class": ClassStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getTeacherReplyAssignmentsContent(String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.GET_TEACHER_REPLY_OF_ASSIGNMENTS_DATA_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getStudentReplyAssignments(
    String section,
    String year,
    String stage,
    String grade,
    String ClassStudent,
    String semester,
    String studentId) async {
  String myUrl = ApiConstants.GET_STUDENT_REPLY_OF_ASSIGNMENTS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "regno": studentId,
      "class": ClassStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStudentReplyAssignmentsContent(String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.GET_STUDENT_REPLY_OF_ASSIGNMENTS_DATA_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getStudentReplyAssignmentsFromStaff(
    String section,
    String year,
    String stage,
    String grade,
    String ClassStudent,
    String semester,
    String staffId) async {
  String myUrl = ApiConstants.GET_STUDENT_REPLY_FROM_STAFF_OF_ASSIGNMENTS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "staffid": staffId,
      "class": ClassStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStudentReplyAssignmentsContentFromStaff(
    String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl =
      ApiConstants.GET_STUDENT_REPLY_FROM_STAFF_OF_ASSIGNMENTS_DATA_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> ReplyAssignmentStaff(
    List fileslist, String message, String idAssignment, String staffId) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";

  String myUrl = ApiConstants.REPLY_ASSIGNMENT_STAFF_API;
  try {
    dynamic files = jsonEncode(fileslist);
    Map body = {
      "FileName": files,
      "message": message,
      "idAssignment": idAssignment,
      "staffid": staffId,
    };
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: body);
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
  return eventObject;
}

Future<EventObject> getStaffReplyAssignments(
    String section,
    String year,
    String stage,
    String grade,
    String ClassStudent,
    String semester,
    String staffId) async {
  String myUrl = ApiConstants.GET_STAFF_REPLY_OF_ASSIGNMENTS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "staffid": staffId,
      "class": ClassStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStaffReplyAssignmentsContent(String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.GET_STAFF_REPLY_OF_ASSIGNMENTS_DATA_API;
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getPreviousAssignments(
    String section,
    String year,
    String stage,
    String grade,
    String ClassStudent,
    String semester,
    String staffId) async {
  String myUrl = ApiConstants.GET_STAFF_PREVIOUS_ASSIGNMENTS_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": grade,
      "semester": semester,
      "year": year,
      "staffid": staffId,
      "class": ClassStudent
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> deleteAssignments(List assignments) async {
  String myUrl = ApiConstants.DELETE_ASSIGNMENTS_API;
  dynamic assignmentsEncode = jsonEncode(assignments);
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"assignments": assignmentsEncode});
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<dynamic> getStudentMemo(String section, String stage, String garde,
    String classid, String year) async {
  var myUrl = ApiConstants.STUDENT_OF_MEMO_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    if (stage == null) stage;
    if (garde == null) garde;
    if (classid == null) classid;

    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": garde,
      "class": classid,
      "year": year
    });

    if (response != null) {
      Map mapValue = json.decode(response.body);
      print("result " + mapValue.toString());
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<dynamic> getStudentMemoOptions(String section, String stage,
    String garde, String classid, String year) async {
  var myUrl = ApiConstants.GET_MEMO_OPTIONS_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    if (stage == null) stage;
    if (garde == null) garde;
    if (classid == null) classid;

    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": section,
      "stage": stage,
      "grade": garde,
      "class": classid,
      "year": year
    });

    if (response != null) {
      Map mapValue = json.decode(response.body);
      print("result " + mapValue.toString());
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> addMemo(
    String section,
    String stage,
    String grade,
    String year,
    String regno,
    String datefrom,
    String timefrom,
    String comment,
    List IwasArr,
    List IneedArr,
    List studentIpottyId,
    List pottyArr,
    String breakValue,
    String lunchValue,
    String snackValue,
    String nap,
    String naptimefrom,
    String naptimeto) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl = ApiConstants.ADD_MEMO_API;
  Map mapValue;
  try {
    dynamic Iwas = jsonEncode(IwasArr);
    dynamic Ineed = jsonEncode(IneedArr);
    dynamic Ipotty = jsonEncode(studentIpottyId);
    dynamic pottyValue = jsonEncode(pottyArr);
    if (breakValue == null) breakValue = " ";
    if (lunchValue == null) lunchValue = " ";
    if (snackValue == null) snackValue = " ";
    if (nap == null) nap = " ";
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "SectionId": section,
      "StageId": stage,
      "GradeId": grade,
      "Year": year,
      "regno": regno,
      "dateFrom": datefrom,
      "timefrom": timefrom,
      "Comment": comment,
      "iwas": Iwas,
      "ineed": Ineed,
      "ipotty": Ipotty,
      "pottyvalue": pottyValue,
      "breakValue": breakValue,
      "lunchValue": lunchValue,
      "snackValue": snackValue,
      "nap": nap,
      "naptimefrom": naptimefrom,
      "naptimeto": naptimeto
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getMemoForStudent(String regno, String year, String date,
    String section, String stage, String grade, String stuclass) async {
  String myUrl = ApiConstants.GET_MEMO_STUDENT_API;
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "regno": regno,
      "date": date,
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": stuclass
    });
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> getConferenceData(
    String userID,
    String year,
    String section,
    String stage,
    String grade,
    String classst,
    String usersemester) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": userID.toString(),
      "year": year.toString(),
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classst,
      "usersemester": usersemester
    });
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> JoinConference(
    String room,
    String userID,
    String year,
    String SubjectId,
    String section,
    String stage,
    String grade,
    String classst,
    String usersemester,
    String type) async {
  String myUrl = ApiConstants.JOIN_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": userID.toString(),
      "year": year.toString(),
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classst,
      "usersemester": usersemester,
      "type": type,
      "SubjectId": SubjectId,
      "room": room
    });
    if (response != null) {
      // print('Response body Conference : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> ConferenceTerminated(int joinId) async {
  String myUrl = ApiConstants.TERMINATED_CONFERENCE_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"joinId": joinId.toString()});
    // print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getUrlConferenceData(String sectionid) async {
  String myUrl = ApiConstants.URL_CONFERENCE_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"sectionid": sectionid});
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> JoinConferenceStaffMain(String staffid) async {
  String myUrl = ApiConstants.JOIN_STAFF_CONFERENCE_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"staffid": staffid});
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> ConferenceTerminatedStaff(int joinId) async {
  String myUrl = ApiConstants.TERMINATED_CONFERENCE_STAFF_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"joinId": joinId.toString()});
    // print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getConferenceStaffData() async {
  String myUrl = ApiConstants.GET_STAFF_JOIN_OF_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {});
    if (response != null) {
      print('Response body Conference Data : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> JoinConferenceSatff(String joinId, String Staffid) async {
  String myUrl = ApiConstants.UPDATE_JOIN_STAFF_CONFERENCE_API;
  Map mapValue;
  print(joinId.toString());
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"joinId": joinId.toString(), "staffid": Staffid});
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> ConferenceTerminatedStaffJoin(
    String joinId, String staffid) async {
  String myUrl = ApiConstants.TERMINATED_CONFERENCE_STAFF_STAFF_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"joinId": joinId, "staffid": staffid});
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> JoinConferenceSupervisior(
    String room,
    String userID,
    String year,
    String SubjectId,
    String section,
    String stage,
    String grade,
    String classst,
    String usersemester,
    String type) async {
  String myUrl = ApiConstants.JOIN_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": userID.toString(),
      "year": year.toString(),
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classst,
      "usersemester": usersemester,
      "type": type,
      "SubjectId": SubjectId,
      "room": room
    });
    if (response != null) {
      // print('Response body Conference : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getConferenceSupervisiorStaffData(
    String userID, String myyear) async {
  String myUrl = ApiConstants.GET_SUPERVISIOR_STAFF_JOIN_OF_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"userID": userID, "myyear": myyear});
    if (response != null) {
      print('Response body Conference Data : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getConferenceDataStudentManagement(
    String year, String section, String stage, String grade) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_CONFERENCE_MANAGEMENT_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "section": section,
      "stage": stage,
      "grade": grade,
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getAdvancedConferenceStaffData() async {
  String myUrl = ApiConstants.GET_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {});
    if (response != null) {
      print('Response body Conference Data : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['successss']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> ReplySendToClassStudent(
    List fileslist, String message, String idSendToClass, String regno) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";

  String myUrl = ApiConstants.REPLY_SENDTOCLASS_STUDENT_API;
  print("Reply : $myUrl");
  try {
    dynamic files = jsonEncode(fileslist);
    Map body = {
      "FileName": files,
      "message": message,
      "idSendtoclass": idSendToClass,
      "regno": regno,
    };
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: body);
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
  return eventObject;
}

Future<EventObject> replyReplySendtoclassStudent(
    List fileslist,
    String message,
    String regno,
    String id,
    String staffid,
    String staffName,
    String subjectId,
    String year) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";

  String myUrl = ApiConstants.Reply_Reply_Send_To_Class_Student;
  print(
      "Reply from student : $myUrl  [$id] [$message] [$regno] [$staffName] [$staffid] [$subjectId] [$year]  ");
  try {
    Map<String, String> body = {
      "message": message,
      "regno": regno,
      "id": id,
      "staffid": staffid,
      "staffname": staffName,
      "subjectid": subjectId,
      "year": year
    };
    var request = http.MultipartRequest('POST', Uri.parse(myUrl));
    request.fields.addAll(body);
    fileslist.forEach((element) async {
      request.files.add(await http.MultipartFile.fromPath(
          'FileName[]', File(element.path).absolute.path));
    });

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print(await response);
    } else {
      print(response.reasonPhrase);
    }

    if (response != null) {
      print("Reply from student Response : ====> ${response.body}");
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        print("Reply from student Response : ====> ${response.body}");
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
  return eventObject;
}

Future<EventObject> replyReplySendtoclassReadStaffStudent(
    List fileslist,
    String message,
    String regno,
    String id,
    String staffid,
    String staffName,
    String subjectId,
    String year) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";

  String myUrl = ApiConstants.Reply_Reply_Send_To_Class_READ_STAFF_STUDENT;
  print(
      "Reply from student : $myUrl [$id] [$message] [$regno] [$staffName] [$staffid] [$subjectId] [$year]");
  try {
    Map<String, String> body = {
      "message": message,
      "regno": regno,
      "mainid": id,
      "staffid": staffid,
      "staffname": staffName,
      "subjectid": subjectId,
      "year": year
    };
    var request = http.MultipartRequest('POST', Uri.parse(myUrl));
    request.fields.addAll(body);
    fileslist.forEach((element) async {
      request.files.add(await http.MultipartFile.fromPath(
          'FileName[]', File(element.path).absolute.path));
    });

    final http.StreamedResponse streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    if (response.statusCode == 200) {
      print(await response);
    } else {
      print(response.reasonPhrase);
    }

    if (response != null) {
      print("Reply from student Response : ====> ${response.body}");
      Map mapValue = json.decode(response.body);
      if (mapValue["success"]) {
        eventObject.success = true;
        eventObject.object = mapValue;
      } else {
        print("Reply from student Response : ====> ${response.body}");
        eventObject.object = mapValue["message"];
      }
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
  return eventObject;
}

Future<EventObject> getStudentReplySendtoclassFromStaff(
    String year,
    String staffId,
    String sectionId,
    String stageId,
    String gradeId,
    String subjectId,
    String classId) async {
  String myUrl = ApiConstants.GET_STUDENT_REPLY_FROM_STAFF_OF_SENDTOCLASS_API;
  print(
      "send to class Reply from student ==> {$myUrl} Data :  $year, $staffId , $sectionId , $stageId , $gradeId , $subjectId , $classId");
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "staffid": staffId,
      "sectonid": sectionId,
      "stageid": stageId,
      "gradeid": gradeId,
      "subjectid": subjectId,
      "classid": classId,
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getreplayfromsendtoclassfromstudents(
    String year,
    String staffId,
    String sectionId,
    String stageId,
    String gradeId,
    String subjectId,
    String classId,
    String semesterId) async {
  String myUrl = ApiConstants.GET_REPLY_FROM_SEND_TO_CLASS_FROM_STUDENTS;
  print(
      "send to class Replies from student  ==> {$myUrl} Data :  $year, $staffId , $sectionId , $stageId , $gradeId , $subjectId , $classId , $semesterId");
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "year": year,
      "staffid": staffId,
      "section": sectionId,
      "stage": stageId,
      "grade": gradeId,
      "subject": subjectId,
      "class": classId,
      "semester": semesterId
    });
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getStudentReplySendtoclassContentFromStaff(
    String id) async {
  EventObject eventObject = new EventObject();
  eventObject.success = false;
  eventObject.object = "Some error happened.. try again later";
  String myUrl =
      ApiConstants.GET_STUDENT_REPLY_FROM_STAFF_OF_SENDTOCLASS_DATA_API;

  print("Not found file Bug: from URL ==> ${myUrl} ${id}");
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'}, body: {"id": id});
    if (response != null) {
      Map mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    } else {
      return eventObject;
    }
  } catch (e) {
    return eventObject;
  }
}

Future<EventObject> sessionCambridgeOptions(String section, String year) async {
  String myUrl = ApiConstants.GET_SEESION_CAMBRIDGE_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"section": section.toString(), "year": year.toString()});
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getCambridgeAdvancedConferenceStaffData(
    String session, String section, String year) async {
  String myUrl =
      ApiConstants.GET_CAMBRIDGE_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"sessionid": session, "year": year, "sectionid": section});
    if (response != null) {
      print('Response body Conference Data : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> JoinCambridgeConference(
    String room,
    String userID,
    String year,
    String SubjectId,
    String section,
    String stage,
    String grade,
    String classst,
    String usersemester,
    String type) async {
  String myUrl = ApiConstants.JOIN_CAMBRIDGE_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "userID": userID.toString(),
      "year": year.toString(),
      "section": section,
      "stage": stage,
      "grade": grade,
      "class": classst,
      "usersemester": usersemester,
      "type": type,
      "SubjectId": SubjectId,
      "room": room
    });
    if (response != null) {
      // print('Response body Conference : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> CambridgeConferenceTerminated(int joinId) async {
  String myUrl = ApiConstants.TERMINATED_CAMBRIDGE_CONFERENCE_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"joinId": joinId.toString()});
    // print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getCambridgeUrlConferenceData(String sectionid) async {
  String myUrl = ApiConstants.GET_CAMBRIDGE_URL_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"sectionid": sectionid});
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getCambridgeAdvancedConferenceStaffStaffData(
    String session, String section, String year, String staffid) async {
  String myUrl =
      ApiConstants.GET_CAMBRIDGE_STAFF_STAFF_JOIN_OF_ADVANCED_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "sessionid": session,
      "year": year,
      "sectionid": section,
      "staffid": staffid
    });
    if (response != null) {
      print('Response body Conference Data : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getCambridgeAdvancedConferenceSupervisourData(
    String session, String section, String year, String staffid) async {
  String myUrl =
      ApiConstants.GET_CAMBRIDGE_SUPERVISOUR_JOIN_OF_ADVANCED_CONFERENCE_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "sessionid": session,
      "year": year,
      "sectionid": section,
      "staffid": staffid
    });
    if (response != null) {
      print('Response body Conference Data : ${response.body}');
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> JoinCambridgeConferenceSatff(
    String joinId, String Staffid) async {
  String myUrl = ApiConstants.UPDATE_JOIN_CAMBRIDGE_STAFF_CONFERENCE_API;
  Map mapValue;
  print(joinId.toString());
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"joinId": joinId.toString(), "staffid": Staffid});
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> ConferenceCambridgeTerminatedStaffJoin(
    String joinId, String staffid) async {
  String myUrl = ApiConstants.TERMINATED_CAMBRIDGE_CONFERENCE_STAFF_STAFF_API;
  Map mapValue;
  //print("ssss"+joinId);
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"joinId": joinId, "staffid": staffid});
    // print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getCambridgeStudentConferenceData(
    String userID, String year, String section, String session) async {
  String myUrl = ApiConstants.GET_CAMBRIDGE_CONFERENCE_STUDENT_DATA_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "sessionid": session,
      "year": year,
      "sectionid": section,
      "studentid": userID
    });
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> academicYearOptionsStudent(
    String studentSection, String regno) async {
  String myUrl = ApiConstants.ACADEMIC_YEARS_FOR_STUDENT_API;
  Map mapValue;
  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl), headers: {
      'Accept': 'application/json'
    }, body: {
      "section": studentSection.toString(),
      "regno": regno,
    });
    if (response != null) {
      print('Response status : ${response.statusCode}');
      print('Response body : ${response.body}');

      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue['acadmicYear'];
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

Future<EventObject> getUrlConferenceDataByStage(
    String sectionid, String stageid) async {
  String myUrl = ApiConstants.URL_CONFERENCE_BY_STAGE_API;
  Map mapValue;

  EventObject eventObject = new EventObject();
  try {
    var response = await http.post(Uri.parse(myUrl),
        headers: {'Accept': 'application/json'},
        body: {"sectionid": sectionid, "stageid": stageid});
    print('Response body Conference : ${response.body}');
    if (response != null) {
      mapValue = json.decode(response.body);
      if (mapValue['success']) {
        eventObject.success = true;
        eventObject.object = mapValue;
        return eventObject;
      } else {
        eventObject.success = false;
        eventObject.object = mapValue['message'];
        return eventObject;
      }
    }
    return eventObject;
  } catch (e) {
    eventObject.success = false;
    eventObject.object = "Some error happened.. try again later";
    return eventObject;
  }
}

SeenMessage_Assignments(String id, String regno, String year, String section,
    String stage, String grade, String classStudent, String semester) async {
  String myUrl = ApiConstants.GET_STUDENT_OF_ASSIGNMENTS_DATA_SEEN_API;
  print("id" + id);
  print("regno" + regno);
  print("semester" + semester);
  print("section" + section);
  print("stage" + stage);
  print("grade" + grade);
  print("class" + classStudent);
  var response = await http.post(Uri.parse(myUrl), headers: {
    'Accept': 'application/json'
  }, body: {
    "id": id,
    "regno": regno,
    "semester": semester,
    "section": section,
    "stage": stage,
    "grade": grade,
    "class": classStudent,
    "year": year
  });
  print("respSeen " + response.toString());
  if (response != null) {
    return true;
  } else {
    return false;
  }
}

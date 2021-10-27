import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../Modules/Management.dart';
import '../Modules/Parent.dart';
import '../Modules/Staff.dart';
import '../Modules/Student.dart';
import '../Modules/User.dart';

import '../Constants/StringConstants.dart';

const String PREFS_USER = "user";
const String PREFS_USER_TYPE = "type";

setUserData(User userdata) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String data = json
      .encode(userdata.toJson()); //convert to map first then convert to json
  await prefs.setString(PREFS_USER, data);
}

setUserType(String userType) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(PREFS_USER_TYPE, userType);
}

Future<User?> getUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String type = prefs.get(PREFS_USER_TYPE).toString();
  var userPrefs = prefs.get(PREFS_USER);
  if (userPrefs == null) {
    return null;
  }
  if (type == STUDENT_TYPE) {
    var data = prefs.get(PREFS_USER);
    if (data == null) {
      return null;
    }
    Map<String, dynamic> userMap =
        jsonDecode(data.toString()); //convert to json or map
    return Student.fromJson(userMap); //convert map to object not build in dart
  } else if (type == PARENT_TYPE) {
    var data = prefs.get(PREFS_USER);
    if (data == null) {
      return null;
    }
    Map<String, dynamic> userMap = jsonDecode(data.toString());
    return Parent.fromJson(userMap);
  } else if (type == STAFF_TYPE) {
    var data = prefs.get(PREFS_USER);
    if (data == null) {
      return null;
    }
    Map<String, dynamic> userMap = jsonDecode(data.toString());
    return Staff.fromJson(userMap);
  } else if (type == MANAGEMENT_TYPE) {
    var data = prefs.get(PREFS_USER);
    if (data == null) {
      return null;
    }
    Map<String, dynamic> userMap = jsonDecode(data.toString());
    return Management.fromJson(userMap);
  }
  // else if(type == PARENT_TYPE){
  //   var data = prefs.get(PREFS_USER);
  //   if(data == null){
  //     return null;
  //   }
  //
  //   Map<String,dynamic> userMap = jsonDecode(data);
  //
  //   return Parent.fromJson(userMap);
  // }
  else if (type == BUS_TYPE) {
    var data = prefs.get(PREFS_USER);
    if (data == null) {
      return null;
    }
    Map<String, dynamic> userMap = jsonDecode(data.toString());
    return User.fromJson(userMap);
  }
  Map<String, dynamic> userMap = jsonDecode(userPrefs.toString());
  print("FoundDataInPrefs: " + userMap.toString());
  return User.fromJson(userMap);
}

Future<dynamic> getUserType() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String type = prefs.get(PREFS_USER_TYPE).toString();
  if (type == null) {
    return null;
  } else {
    return type;
  }
}

Future<void> removeUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

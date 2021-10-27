import '../Modules/User.dart';

class Staff extends User {
   String? section;
   String? sectionName;
   String? academicYear;
   String? stage;
   String? stageName;
   String? grade;
   String? gradeName;
   String? semester;
   String? semesterName;
   String? staffClass;
    String? staffClassName;
   String? subject;
   String? subjectName;
   bool?   supervisorStaff;
   String? supervisorId;

  Staff({id, token, name, type});

  Staff.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    token = json['token'];
    section = json['section'];
    sectionName = json['sectionName'];
    academicYear = json['academicYear'];
    stage = json['stage'];
    stageName = json['stageName'];
    grade = json['grade'];
    gradeName = json['gradeName'];
    semester = json['semester'];
    semesterName = json['semesterName'];
    staffClass = json['staffClass'];
    staffClassName = json['staffClassName'];
    subject = json['subject'];
    subjectName = json['subjectName'];
    supervisorStaff = json['supervisorStaff'];
    supervisorId = json['supervisorId'];
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = super.toJson();
    map['section'] = section;
    map['sectionName'] = sectionName;
    map['academicYear'] = academicYear;
    map['stage'] = stage;
    map['stageName'] = stageName;
    map['grade'] = grade;
    map['gradeName'] = gradeName;
    map['semester'] = semester;
    map['semesterName'] = semesterName;
    map['staffClass'] = staffClass;
    map['staffClassName'] = staffClassName;
    map['subject'] = subject;
    map['subjectName'] = subjectName;
    map['supervisorStaff'] = supervisorStaff;
    map['supervisorId'] = supervisorId;
    return map;
  }

}
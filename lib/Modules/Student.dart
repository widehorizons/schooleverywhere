import '../Modules/User.dart';

class Student extends User {
   String? section;
   String? stage;
   String? studentClass;
   String? grade;
   String? academicYear;
   String? semester;

  Student({id, token, name, type});

  Student.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    token = json['token'];
    section = json['section'];
    academicYear = json['academicYear'];
    stage = json['stage'];
    grade = json['grade'];
    semester = json['semester'];
    studentClass = json['studentClass'];
  }

 @override
  Map<String, dynamic> toJson(){
   Map<String, dynamic> map = super.toJson();
   map['section'] = section;
   map['academicYear'] = academicYear;
   map['stage'] = stage;
   map['grade'] = grade;
   map['semester'] = semester;
   map['studentClass'] = studentClass;
   return map;
 }

}
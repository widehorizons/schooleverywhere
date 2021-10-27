import '../Modules/User.dart';

class Bus extends User {
  String? section;
  String? stage;
  String? studentClass;
  String? grade;
  String ?academicYear;


  Bus.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    token = json['token'];
    section = json['section'];
    stage = json['stage'];
    studentClass = json['studentClass'];
    grade = json['grade'];
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = super.toJson();
    map['section'] = section;
    return map;
  }

}
import '../Modules/User.dart';

class Management extends User {
   String? section;
   String? sectionName;
   String? academicYear;
  Management({id, token, name, type}) ;

  Management.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    token = json['token'];
    section = json['section'];
    sectionName = json['sectionName'];
    academicYear = json['academicYear'];
  }

  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = super.toJson();
    map['section'] = section;
    map['sectionName'] = sectionName;
    map['academicYear'] = academicYear;
    return map;
  }

}
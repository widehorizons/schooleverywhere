import '../Modules/User.dart';
import 'dart:convert';
import 'Student.dart';

class Parent extends User {

  List childrenName= [];
  List childrenSection= [];
  List childrenId= [];
  List childrenImge= [];
  dynamic regno;
  dynamic childeSectionSelected;
  dynamic academicYear;
  dynamic semester;
  dynamic stage;
  dynamic grade;
  dynamic classChild;
 Parent({id, token, name, type});
  Parent.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    type = json['type'];
    token = json['token'];
    childrenName=json['childrenName'];
    childrenSection=json['childrenSection'];
    childrenId=json['childrenId'];
    childrenImge=json['childrenImge'];
    regno=json['regno'];
    childeSectionSelected=json['childeSectionSelected'];
    academicYear=json['academicYear'];
    semester=json['semester'];
    stage=json['stage'];
    grade=json['grade'];
    classChild=json['classChild'];

//print("regnoStudent"+regno.toString());
  }


  @override
  Map<String, dynamic> toJson(){
    Map<String, dynamic> map = super.toJson();
    map['childrenName'] = childrenName;
    map['childrenSection'] = childrenSection;
    map['childrenId'] = childrenId;
    map['childrenImge'] = childrenImge;
    map['regno'] = regno;
    map['childeSectionSelected'] = childeSectionSelected;
    map['academicYear'] = academicYear;
    map['semester'] = semester;
    map['stage']=stage;
    map['grade']=grade;
    map['classChild']=classChild;

    return map;
  }

}
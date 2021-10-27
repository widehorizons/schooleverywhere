
class User {
  String? id;
  String? token;
  String? name;
  String? type;


  User({id, token,name, type});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        type = json['type'],
        token = json['token'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'id': id, 'token': token, 'type': type};
}

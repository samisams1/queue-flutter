import 'dart:convert';

LoginResponseModel loginResponseJson(String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.id,
    required this.username,
    required this.email,
    required this.roles,
    required this.status,
    required this.accessToken,
    required this.windowNumber,
    required this.firstName,
    required this.lastName,
  });
  late final int id;
  late final String username;
  late final String email;
  late final List<String> roles;
  late final String status;
  late final String accessToken;
  late final String windowNumber;
  late final String firstName;
  late final String lastName;

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    roles = List.castFrom<dynamic, String>(json['roles']);
    status = json['status'];
    accessToken = json['accessToken'];
    windowNumber = json['windowNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }
  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['username'] = username;
    _data['email'] = email;
    _data['roles'] = roles;
    _data['status'] = status;
    _data['accessToken'] = accessToken;
    _data['windowNumber'] = windowNumber;
    _data['firstName'] = firstName;
    _data['lastName'] = lastName;
    return _data;
  }
}

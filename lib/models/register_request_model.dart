class RegisterRequestModel {
  RegisterRequestModel(
      {this.username,
      this.password,
      this.email,
      this.firstName,
      this.lastName});
  late final String? username;
  late final String? password;
  late final String? email;
  late final String? firstName;
  late final String? lastName;

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['firstName'] = firstName;
    data['lastName'] = lastName;

    return data;
  }
}

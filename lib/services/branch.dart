import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:queue/config.dart';
import 'package:queue/models/branch_response_model.dart';

final String url = Config.apiURL + Config.allBranch;

List<BranchResponseModel> parseUser(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var users = list.map((e) => BranchResponseModel.fromJson(e)).toList();
  return users;
}

Future<List<BranchResponseModel>> fetchUsers() async {
  final http.Response response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return compute(parseUser, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}

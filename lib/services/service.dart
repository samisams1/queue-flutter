import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:queue/config.dart';
import 'package:queue/models/service_response_model.dart';

final String url = Config.apiURL + Config.serviceQueue;

List<ServiceResponseModel> parseUser(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var services = list.map((e) => ServiceResponseModel.fromJson(e)).toList();
  return services;
}

var client = http.Client();
Future<List<ServiceResponseModel>> fetchService(branchId) async {
  final http.Response response = await http.get(Uri.parse(url));
  //  final http.Response response = await http.get(Uri.parse((url),body: {'branchId': 1}));
  // var response = await http.get(Uri.https(url, '1'));

  if (response.statusCode == 200) {
    return compute(parseUser, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}

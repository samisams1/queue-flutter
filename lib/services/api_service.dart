import 'dart:convert';

import 'package:queue/models/login_request_model.dart';
import 'package:queue/models/login_response_model.dart';
import 'package:queue/models/register_request_model.dart';
import 'package:queue/models/register_response_model.dart';
import 'package:http/http.dart' as http;

import '../../config.dart';
import 'shared_service.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> login(
    LoginRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    /*  var url = Uri.http(
      Config.apiURL,
      Config.loginAPI,
    ); */
    var url = Uri.parse(Config.apiURL + Config.loginAPI);

    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      await SharedService.setLoginDetails(loginResponseJson(response.body));

      return true;
    } else {
      return false;
    }
  }

  static Future<RegisterResponseModel> register(
    RegisterRequestModel model,
  ) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.parse(Config.apiURL + Config.registerAPI);
    print(url);
    var response = await http.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson()),
    );

    return registerResponseJson(
      response.body,
    );
  }

  static Future<String> getUserProfile() async {
    var loginDetails = await SharedService.loginDetails();

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      //'Authorization': 'x-access-token' '${loginDetails!.accessToken}',
      'x-access-token': loginDetails!.accessToken
    };

    //var url = Uri.http(Config.apiURL, Config.userProfileAPI);
    var url = Uri.parse(Config.apiURL + Config.userProfileAPI);

    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "";
    }
  }
}

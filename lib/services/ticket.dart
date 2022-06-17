import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:queue/config.dart';
import 'package:queue/models/ticketResponse.dart';

final String url = Config.apiURL + Config.myTicket;

List<ticketRespose> parseMyTicket(String responseBody) {
  var list = json.decode(responseBody) as List<dynamic>;
  var myTickets = list.map((e) => ticketRespose.fromJson(e)).toList();
  return myTickets;
}

Future<List<ticketRespose>> fetchMytickets() async {
  final http.Response response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    return compute(parseMyTicket, response.body);
  } else {
    throw Exception(response.statusCode);
  }
}

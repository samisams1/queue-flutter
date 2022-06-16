import 'dart:convert';

import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/cupertino.dart';

class Logout {
  static Future<void> logout(BuildContext context) async {
    await APICacheManager().deleteCache("login_details");
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    );
  }
}

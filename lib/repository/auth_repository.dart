import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:order_payments/model/product.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:order_payments/ui/main_menu/home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  
  Future login(String? email, String? password) async {
    var url = "${dotenv.env['BASE_URL_API']}auth/login";
    var uri = Uri.parse(url);
    Map data = {'email': email, 'password': password};
    var body = json.encode(data);

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Something wrong  ${response.statusCode}");
      throw "Something wrong  ${response.statusCode}";
    }
  }
}

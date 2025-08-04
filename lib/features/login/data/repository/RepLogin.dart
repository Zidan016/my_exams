import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_exams/core/service/ApiService.dart';
import 'package:my_exams/core/service/LocalService.dart';

class RepLogin {
  final LocalService pref;
  final ApiService api;

  RepLogin({required this.api, required this.pref});

  Future<bool?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('${ApiService.url}login'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "username": username,
        "password": password
      }),
    );
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final getId = data['data'];
        print(getId);
        await pref.setUsername(getId['username']);
        await pref.setId(getId['id']);
        await pref.setRole(List<String>.from(getId['role_id'].map((id) => id.toString())));
        await pref.setAuth(data['token']);
        return true;
      } else {
        print("Server Said : ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  late int _userId;
  String fullName = '';
  String countryName = '';

  bool get isAuthenticated => _isAuthenticated;

  Future<void> login(String username, String password) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:5000/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      _userId = data['user_id'];
      _isAuthenticated = true;
      notifyListeners();
    } else {
      _isAuthenticated = false;
      notifyListeners();
      throw Exception("Failed to fetch user data");
    }
  }

  Future<void> fetchUserData() async {
    try {
      var response =
          await http.get(Uri.parse('http://10.0.2.2:5000/userdata/$_userId'));
      var userData = jsonDecode(response.body);
      fullName = userData['full_name'];
      countryName = userData['country_name'];
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

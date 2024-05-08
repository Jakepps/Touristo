import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider with ChangeNotifier {
  bool _isAuthenticated = false;

  late int _userId;
  String fullName = '';
  String countryName = '';
  String imageUrl = '';

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
      imageUrl = userData['image_path'];
    } catch (e) {
      throw Exception("Failed to update user data: $e");
    }
  }

  Future<void> updateUserDetails(String fullName, String countryName) async {
    var response = await http.post(
      Uri.parse('http://10.0.2.2:5000/update_user/$_userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'full_name': fullName,
        'country_name': countryName,
      }),
    );

    if (response.statusCode == 200) {
      this.fullName = fullName;
      this.countryName = countryName;
      notifyListeners();
    } else {
      throw Exception("Failed to update user data");
    }
  }

  Future<void> uploadImage(File image) async {
    var uri = Uri.parse('http://10.0.2.2:5000/upload_image/$_userId');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploaded');
    } else {
      throw Exception("Failed to image uploaded");
    }
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isAuthenticated = false;

  int _userId = 0;
  String fullName = '';
  String countryName = '';
  String? imageUrl;

  bool get isAuthenticated => _isAuthenticated;
  int get userId => _userId;

  String httpURL = 'http://127.0.0.1:5000/';

  Future<void> tryAutoLogin() async {
    final token = await _storage.read(key: 'token');
    if (token != null) {
      try {
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        _userId = payload['user_id'];
        _isAuthenticated = true;
        notifyListeners();
      } catch (e) {
        throw Exception('Error decoding token: $e');
      }
    }
  }

  Future<void> login(String username, String password) async {
    var response = await http.post(
      Uri.parse('${httpURL}login'),
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
      await _storage.write(key: 'token', value: data['token']);
      notifyListeners();
    } else {
      _isAuthenticated = false;
      notifyListeners();
      throw Exception("Failed to fetch user data");
    }
  }

  Future<void> fetchUserData() async {
    try {
      var response = await http.get(Uri.parse('${httpURL}userdata/$_userId'));
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
      Uri.parse('${httpURL}update_user/$_userId'),
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
    var uri = Uri.parse('${httpURL}upload_image/$_userId');
    var request = http.MultipartRequest('POST', uri)
      ..files.add(await http.MultipartFile.fromPath(
        'file',
        image.path,
      ));

    var response = await request.send();

    if (response.statusCode == 200) {
      print('Image Uploaded');
      notifyListeners();
    } else {
      throw Exception("Failed to image uploaded");
    }
  }

  Future<void> addToFavorites(String countryCode) async {
    final response = await http.post(
      Uri.parse('${httpURL}add_favorites/$_userId/$countryCode'),
    );
    if (response.statusCode == 201) {
      notifyListeners();
    } else {
      throw Exception('Failed to add to favorites');
    }
  }

  Future<void> removeFavorite(String countryCode) async {
    final userId = this.userId;
    final response = await http
        .delete(Uri.parse('${httpURL}remove_favorites/$userId/$countryCode'));

    if (response.statusCode != 200) {
      throw Exception('Failed to remove from favorites');
    }
  }

  void logout() {
    _storage.delete(key: 'token');
    _isAuthenticated = false;
    notifyListeners();
  }
}

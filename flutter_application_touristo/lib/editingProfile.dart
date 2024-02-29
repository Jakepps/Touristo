import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditingProfileScreen extends StatefulWidget {
  const EditingProfileScreen(
      {super.key,
      required Null Function(dynamic name, dynamic location) OnSaveChanges});

  @override
  _EditingProfileScreenState createState() => _EditingProfileScreenState();
}

class _EditingProfileScreenState extends State<EditingProfileScreen> {
  String _nameProfile = ''; // Переменная для хранения имени
  String _locationProfile = ''; // Переменная для хранения местоположения

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Редактировать профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage:
                  const AssetImage('assets/images/user_photo.jpeg'),
              backgroundColor: Colors.transparent,
              child: IconButton(
                onPressed: () {
                  // логика для выбора фото
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Имя и фамилия',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _nameProfile = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Страна и город',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _locationProfile = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                OnSaveChanges(_nameProfile, _locationProfile);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                fixedSize: const Size(300, 40),
              ),
              child: const Text(
                'Сохранить изменения',
                style: TextStyle(fontSize: 15, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void OnSaveChanges(String nameProfile, String locationProfile) async {
    setState(() {
      _nameProfile = nameProfile;
      _locationProfile = locationProfile;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('nameProfileProfile', nameProfile);
    prefs.setString('locationProfileProfile', locationProfile);

    print("Измнения сохранены ");
    print(prefs.get('nameProfileProfile'));
    print(prefs.get('locationProfileProfile'));
  }
}

import 'package:flutter/material.dart';

class EditingProfileScreen extends StatelessWidget {
  const EditingProfileScreen({super.key});

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
                    borderRadius: BorderRadius.circular(10.0)),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                labelText: 'Страна и город',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 10.0),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // логика для сохранения изменений
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
}

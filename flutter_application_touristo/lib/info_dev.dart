import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('О приложении'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Разработчики:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/my_avatar.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Артем Нагалевский',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Front, back, design',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
            Text(
              'GitHub: https://github.com/Jakepps',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль'),
      ),

      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage('assets/images/user_photo.jpeg'),
          ),
          SizedBox(height: 20),

          Text(
            'Элизабер Блек',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          Text(
            'Москва, Россия',
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {

            },
            child: Text('Редактировать профиль', style: TextStyle(fontSize: 15, color: Colors.white),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black,),
          ),
          SizedBox(height: 10),
          
          ElevatedButton(
            onPressed: () {

            },
            child: Text('О приложении', style: TextStyle(fontSize: 17, color: Colors.white),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black,fixedSize: Size(235, 40),),
          ),
        ],
      ),
      ),
    );
  }
}

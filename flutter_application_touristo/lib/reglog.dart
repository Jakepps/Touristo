import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'auth_provider.dart';
import 'main_screen.dart';

class RegistrationLoginScreen extends StatelessWidget {
  const RegistrationLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Регистрация и вход Тест"),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/main_reg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      fixedSize: const Size(200, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Регистрация',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(200, 40),
                      side: const BorderSide(color: Colors.black, width: 2.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Вход',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatelessWidget {
  RegistrationScreen({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController countryNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: fullNameController,
                decoration: const InputDecoration(labelText: 'Полное имя')),
            TextField(
                controller: countryNameController,
                decoration:
                    const InputDecoration(labelText: 'Страна проживания')),
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Логин')),
            TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email')),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true),
            ElevatedButton(
              onPressed: () => register(context),
              child: const Text('Зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }

  void register(BuildContext context) async {
    final url = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/register',
    );
    //var url = Uri.parse('http://10.0.2.2:5000/register');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'full_name': fullNameController.text,
        'country_name': countryNameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 201) {
      Provider.of<AuthProvider>(context, listen: false).login();
      Navigator.of(context).popUntil((route) => route.isFirst);
      MyHomePage.homePageKey.currentState?.changeTab(2);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Ошибка регистрации: ${json.decode(response.body)['error']}')));
    }
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Логин')),
            TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Пароль'),
                obscureText: true),
            ElevatedButton(
              onPressed: () => login(context),
              child: const Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }

  void login(BuildContext context) async {
    final url = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/login',
    );
    //var url = Uri.parse('http://your-server-ip:5000/login');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': usernameController.text,
        'password': passwordController.text,
      }),
    );

    if (response.statusCode == 200) {
      Provider.of<AuthProvider>(context, listen: false).login();
      Navigator.of(context).popUntil((route) => route.isFirst);
      MyHomePage.homePageKey.currentState?.changeTab(2);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Ошибка входа: ${json.decode(response.body)['error']}')),
      );
    }
  }
}

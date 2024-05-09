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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/air.jpg'), fit: BoxFit.cover),
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
                      fixedSize: const Size(200, 50),
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
                      fixedSize: const Size(200, 50),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(labelText: 'Полное имя'),
                  ),
                ),
                const Tooltip(
                  message:
                      'Введите ваше полное имя, используя только буквы и дефисы.',
                  child: Icon(Icons.help_outline, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: countryNameController,
                    decoration:
                        const InputDecoration(labelText: 'Страна проживания'),
                  ),
                ),
                const Tooltip(
                  message:
                      'Введите название страны, используя буквы, пробелы и дефисы.',
                  child: Icon(Icons.help_outline, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(labelText: 'Логин'),
                  ),
                ),
                const Tooltip(
                  message:
                      'Логин должен быть от 3 до 20 символов, допустимы буквы, цифры, дефисы и подчеркивания.',
                  child: Icon(Icons.help_outline, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                ),
                const Tooltip(
                  message: 'Введите корректный email адрес.',
                  child: Icon(Icons.help_outline, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: 'Пароль'),
                    obscureText: true,
                  ),
                ),
                const Tooltip(
                  message:
                      'Пароль должен содержать минимум 8 символов и хотя бы одну цифру.',
                  child: Icon(Icons.help_outline, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => register(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Зарегистрироваться',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 4),
    ));
  }

  void register(BuildContext context) async {
    //Имя пользователя
    if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ\s\-]+$').hasMatch(fullNameController.text)) {
      showSnackBar(context, 'Некоректное имя пользователя');
      return;
    }

    //Страна проживания
    if (!RegExp(r'^[a-zA-Zа-яА-ЯёЁ\s\-]+$')
        .hasMatch(countryNameController.text)) {
      showSnackBar(context, 'Некоректная страна проживания');
      return;
    }

    //логин
    if (!RegExp(r'^[a-zA-Z0-9_-]{3,20}$').hasMatch(usernameController.text)) {
      showSnackBar(context, 'Некоректный логин');
      return;
    }

    //email
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(emailController.text)) {
      showSnackBar(context, 'Некоректная почта');
      return;
    }

    //пароль
    if (!RegExp(r'^(?=.*\d)[a-zA-Z\d]{8,}$')
        .hasMatch(passwordController.text)) {
      showSnackBar(context, 'Некоректный пароль');
      return;
    }

    final url = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/register',
    );
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
      Provider.of<AuthProvider>(context, listen: false)
          .login(usernameController.text, passwordController.text);
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
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  side: const BorderSide(color: Colors.black, width: 2.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Войти',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            )
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
      Provider.of<AuthProvider>(context, listen: false)
          .login(usernameController.text, passwordController.text);
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

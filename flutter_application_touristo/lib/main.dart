import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'main_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touristo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/mainPage': (context) => const MyHomePage(title: 'Home Page'),
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const splashScreenDuration = Duration(seconds: 2);

    Future.delayed(splashScreenDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) =>
                MyHomePage(key: MyHomePage.homePageKey, title: 'Home Page')),
      );
    });

    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo_beggin.png')),
    );
  }
}

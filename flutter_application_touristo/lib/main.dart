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
      home: const SplashScreen(),
    );
  }
}

// Начальный экран приложения
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Здесь можно добавить любую логику, необходимую на начальном экране
    // Например, анимацию загрузки или проверку авторизации
    const splashScreenDuration = Duration(seconds: 2);

    // После завершения задержки переходим на основной экран приложения
    Future.delayed(splashScreenDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => const MyHomePage(title: 'Home Page')),
      );
    });

    // Возвращаем заглушку (например, контейнер с логотипом)
    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo_beggin.png')),
    );
  }
}

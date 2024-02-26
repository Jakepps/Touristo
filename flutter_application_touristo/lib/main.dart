import 'package:flutter/material.dart';
import 'profile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Touristo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// Начальный экран приложения
class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Здесь можно добавить любую логику, необходимую на начальном экране
    // Например, анимацию загрузки или проверку авторизации
    const splashScreenDuration = Duration(seconds: 2);

    // После завершения задержки переходим на основной экран приложения
    Future.delayed(splashScreenDuration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home Page')),
      );
    });

    // Возвращаем заглушку (например, контейнер с логотипом)
    return Scaffold(
      body: Center(
        child: Image.asset('assets/images/logo_beggin.png')
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/back_main.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: null,
                left: null,
                bottom: MediaQuery.of(context).size.height / 2 - 22.5,
                right: MediaQuery.of(context).size.width / 2 - 24.5,
                child: Container(
                  width: 49,
                  height: 45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/elipse.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: null,
                left: null,
                bottom: MediaQuery.of(context).size.height / 2 - 22.5,
                right: MediaQuery.of(context).size.width / 2 - 24.5,
                child: Container(
                  width: 49,
                  height: 45,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Country.png'),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: null,
                left: null,
                bottom: MediaQuery.of(context).size.height / 2 - 150.0,
                right: MediaQuery.of(context).size.width / 2 - 142.5,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 285,
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Куда поедем?',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fixedSize: Size(285, 40),
                      ),
                      child: Text(
                        'Найти',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (int index) {
          if (index == 2) { //profile
            Navigator.push( 
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
          }
        },
        iconSize: 30.0,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Главная',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Избранное',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

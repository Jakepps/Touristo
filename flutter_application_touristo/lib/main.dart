import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
                top: 200,
                left: 190,
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
                top: 200,
                left: 190,
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
                top: 270,
                left: 70,
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        fixedSize: Size(285, 40),
                      ),
                      child: Text(
                        'Найти',
                        style: TextStyle(color: Colors.white),
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
          //логика перемещения по страницам
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/home.png'),
            label: 'Главное меню',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/heart.png'),
            label: 'Избранные страны',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/person.png'),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}

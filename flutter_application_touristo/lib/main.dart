import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'profile.dart';
import 'love.dart';
import 'search.dart';

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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0; // Индекс выбранного элемента BottomNavigationBar

  List<FavoriteCountry> favoriteCountries = [
    FavoriteCountry(name: 'Россия', imagePath: 'assets/images/Россия.jpg'),
    FavoriteCountry(name: 'Турция', imagePath: 'assets/images/Турция.jpg'),
    FavoriteCountry(name: 'Италия', imagePath: 'assets/images/Италия.jpg'),
  ];

  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(
          _selectedIndex), // Отображаем соответствующий контент в зависимости от выбранного элемента
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index; // Обновляем индекс выбранного элемента
          });
        },
        iconSize: 30.0,
        items: const [
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
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _testConnection,
              tooltip: 'Тест соединения',
              child: const Icon(Icons.network_check),
            )
          : null,
    );
  }

  void _testConnection() async {
    var httpUri = Uri(
      scheme: 'http',
      host: '10.0.2.2', //это локальный адрес сервера для эмулятора андроид
      port: 5000,
      path: '/api/country/ru',
    );
    final response =
        await http.get(httpUri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print('Соединение успешно!');
    } else {
      print('Ошибка при тестировании соединения: ${response.statusCode}');
    }
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Container(
          decoration: const BoxDecoration(
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
                  child: const CircleAvatar(
                    backgroundColor: Color.fromARGB(255, 127, 148, 166),
                    radius: 25,
                    child: Icon(
                      Icons.place,
                      size: 30,
                      color: Colors.white,
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
                      SizedBox(
                        width: 285,
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Куда поедем?',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      //кнопка поиска
                      ElevatedButton(
                        onPressed: () {
                          final searchText = _searchController.text.trim();
                          if (searchText.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Пожалуйста, введите название страны')));
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultsScreen(
                                    countryName: _searchController.text),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          fixedSize: const Size(285, 40),
                        ),
                        child: const Text(
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
        );
      case 1:
        return LoveScreen(favoriteCountries: favoriteCountries);
      case 2:
        return const ProfileScreen();
      default:
        return Container();
    }
  }
}

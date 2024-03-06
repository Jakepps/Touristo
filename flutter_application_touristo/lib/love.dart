import 'package:flutter/material.dart';

class FavoriteCountry {
  final String name;
  final String imagePath;

  FavoriteCountry({required this.name, required this.imagePath});
}

class LoveScreen extends StatelessWidget {
  final List<FavoriteCountry> favoriteCountries;

  const LoveScreen({super.key, required this.favoriteCountries});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные страны'),
      ),
      body: ListView.separated(
        itemCount: favoriteCountries.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 16.0);
        },
        itemBuilder: (context, index) {
          final country = favoriteCountries[index];
          return ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(country.imagePath),
            ),
            title: Text(country.name, style: const TextStyle(fontSize: 25)),
            onTap: () {
              //логика
            },
          );
        },
      ),
    );
  }
}

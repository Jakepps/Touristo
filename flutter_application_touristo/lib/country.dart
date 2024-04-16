import 'package:flutter/material.dart';

class CountryDetailsScreen extends StatelessWidget {
  final String countryName;

  const CountryDetailsScreen({super.key, required this.countryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали страны: $countryName'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/$countryName.jpg'),
                  radius: 30,
                ),
                const SizedBox(width: 20),
                Text(
                  countryName,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.favorite_border),
                  onPressed: () {
                    // Добавить в избранное
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Краткая информация о стране:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Информация...',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Интересные факты:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Факт 1\nФакт 2\nФакт 3',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Советы для путешественников:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Совет 1\nСовет 2\nСовет 3',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

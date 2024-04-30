import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryDetailsScreen extends StatefulWidget {
  final String countryName;
  final Map<String, String> countryCodes;

  const CountryDetailsScreen(
      {super.key, required this.countryName, required this.countryCodes});

  @override
  _CountryDetailsScreenState createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  var region = '';
  var subregion = '';
  var officialName = '';
  var flagURL = '';

  @override
  void initState() {
    super.initState();
    _fetchCountryData();
  }

  void _fetchCountryData() async {
    final countryCode = widget.countryCodes[widget.countryName];
    final httpUri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/api/country/$countryCode',
    );

    try {
      final response = await http
          .get(httpUri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          region = data[countryCode]['region'];
          subregion = data[countryCode]['subregion'];
          officialName = data[countryCode]['official_name'];
          flagURL = data[countryCode]['flag']['large'];
        });
      } else {
        throw Exception('Failed to load country data');
      }
    } catch (e) {
      print('Error fetching country data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали страны: ${widget.countryName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(flagURL),
                  //AssetImage('assets/images/${widget.countryName}.jpg'),
                  radius: 30,
                ),
                const SizedBox(width: 20),
                Text(
                  widget.countryName,
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
              'Текстовая информация о стране:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              region.isNotEmpty ? region : 'Информация о стране загружается...',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Интересные факты:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              subregion.isNotEmpty ? subregion : 'Факты загружаются...',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Советы для путешественников:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              officialName.isNotEmpty ? officialName : 'Советы загружаются...',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

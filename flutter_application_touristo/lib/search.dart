import 'package:flutter/material.dart';
import 'country.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:fuzzy/fuzzy.dart';

class SearchResultsScreen extends StatelessWidget {
  final String countryName;

  const SearchResultsScreen({super.key, required this.countryName});

  Future<Map<String, String>> loadCountryCodes() async {
    Map<String, String> countryCodes = {};
    try {
      String data =
          await rootBundle.loadString('assets/files/country_codes.txt');

      // Удалите символы кавычек и фигурные скобки
      data = data
          .replaceAll("'", '')
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll(',', '');

      // Разделите строку данных по запятым и новым строка
      List<String> rows = data.split('\n');

      for (String row in rows) {
        // Разделите строку на части по двоеточиям
        List<String> parts = row.split(':');
        if (parts.length == 2) {
          String country = parts[0].trim();
          String code = parts[1].trim();
          countryCodes[country] = code;
        }
      }
    } catch (e) {
      print('Error load data: $e');
    }
    return countryCodes;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: loadCountryCodes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Ошибка загрузки данных: ${snapshot.error}'),
          );
        } else {
          Map<String, String> countryCodes = snapshot.data!;
          List<String> closestMatches =
              _findClosestMatch(countryName, countryCodes.keys);

          if (closestMatches.isNotEmpty) {
            return _buildScaffoldWithMatch(context, closestMatches);
          } else {
            return _buildNotFoundScaffold(context);
          }
        }
      },
    );
  }

  Scaffold _buildScaffoldWithMatch(
      BuildContext context, List<String> closestMatches) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Результаты поиска'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.builder(
            itemCount: closestMatches.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: const Icon(
                  Icons.map,
                  size: 30,
                ),
                title: Text(
                  closestMatches[index],
                  style: const TextStyle(fontSize: 30),
                ),
                onTap: () {
                  _fetchCountryDetails(context, closestMatches[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Scaffold _buildNotFoundScaffold(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Результаты поиска: $countryName'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error,
                size: 40,
                color: Colors.red,
              ),
              const SizedBox(height: 20),
              Text(
                'Не смогли найти $countryName.',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Повторить попытку',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> _findClosestMatch(String input, Iterable<String> options) {
    if (input.isEmpty) return [];

    final String normalizedInput = input.toLowerCase();
    final Fuzzy<String> fuse = Fuzzy(options.toList());
    final results = fuse.search(normalizedInput);

    List<String> closestMatches = [];

    for (final result in results) {
      if (result.score < 0.2) {
        closestMatches.add(result.item);
      }
    }
    return closestMatches;
  }

  void _fetchCountryDetails(BuildContext context, String selectCountry) async {
    final Map<String, String> countryCodes = await loadCountryCodes();
    final String countryCode = countryCodes[selectCountry] ?? '';

    if (countryCode.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CountryDetailsScreen(
            countryName: selectCountry,
            countryCode: countryCode,
          ),
        ),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'country.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SearchResultsScreen extends StatelessWidget {
  final String countryName;

  const SearchResultsScreen({super.key, required this.countryName});

  Future<Map<String, String>> loadCountryCodes() async {
    Map<String, String> countryCodes = {};
    try {
      String data =
          await rootBundle.loadString('assets/files/country_codes.txt');

      List<String> lines = const LineSplitter().convert(data);

      for (String line in lines) {
        List<String> parts = line.split(':');
        if (parts.length == 2) {
          String country = parts[0].trim().replaceAll("'", "");
          String code = parts[1].trim().replaceAll("'", "");
          code = code.trim().replaceAll(",", "");
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

          if (!countryCodes.containsKey(countryName.trim())) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                title: Text('Результаты поиска: ${countryName.trim()}'),
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
                        'Не смогли найти ${countryName.trim()}.',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Повторить попытку',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Результаты поиска: ${countryName.trim()}'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: GestureDetector(
                    onTap: () {
                      _fetchCountryDetails(countryCodes, context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.map,
                          size: 40,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Text(
                            countryName.trim(),
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _fetchCountryDetails(
      Map<String, String> countryCodes, BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CountryDetailsScreen(
              countryName: countryName.trim(), countryCodes: countryCodes)),
    );
  }
}

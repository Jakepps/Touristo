import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:translator/translator.dart';

class CityListScreen extends StatefulWidget {
  final List<dynamic> cities;

  const CityListScreen({super.key, required this.cities});

  @override
  _CityListScreenState createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  List<dynamic> filteredCities = [];
  bool isSearching = false;
  late List<Map<String, dynamic>> citiesWithTranslations;

  @override
  void initState() {
    super.initState();
    filteredCities = widget.cities;
    translateCityNames();
  }

  Future<void> translateCityNames() async {
    List<String> cityNames =
        widget.cities.map<String>((city) => city['name']).toList();
    List<String> translatedNames = await _translateTexts(cityNames);
    setState(() {
      citiesWithTranslations = List.generate(widget.cities.length, (index) {
        return {
          ...widget.cities[index],
          'translatedName': translatedNames[index]
        };
      });
      filteredCities = citiesWithTranslations;
    });
  }

  Future<List<String>> _translateTexts(List<String> texts) async {
    List<String> translatedTexts = [];
    final translator = GoogleTranslator();
    for (String text in texts) {
      final translatedText = await translator.translate(text, to: 'ru');
      translatedTexts.add(translatedText.toString());
    }
    return translatedTexts;
  }

  void _filterCities(String searchTerm) {
    setState(() {
      filteredCities = citiesWithTranslations
          .where((city) => city['translatedName']
              .toLowerCase()
              .contains(searchTerm.toLowerCase()))
          .toList();
    });
  }

  void openBrowserTab(double lat, double lng) async {
    var url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    await FlutterWebBrowser.openWebPage(url: url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? const Text('Список городов')
            : TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Поиск города...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.black, fontSize: 16.0),
                onChanged: _filterCities,
              ),
        actions: <Widget>[
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
          if (isSearching)
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  isSearching = false;
                  filteredCities = citiesWithTranslations;
                });
              },
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredCities.length,
        itemBuilder: (context, index) {
          var city = filteredCities[index];
          return ListTile(
            title: Text(city['translatedName']),
            subtitle:
                Text('Координаты: ${city['latitude']}, ${city['longitude']}'),
            onTap: () => openBrowserTab(city['latitude'], city['longitude']),
          );
        },
      ),
    );
  }
}

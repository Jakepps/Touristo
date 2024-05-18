import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

class CityListScreen extends StatefulWidget {
  final List<dynamic> cities;

  const CityListScreen({super.key, required this.cities});

  @override
  _CityListScreenState createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  List<dynamic> filteredCities = [];
  bool isSearching = false;
  int currentPage = 0;
  static const int citiesPerPage = 50;

  @override
  void initState() {
    super.initState();
    filteredCities = widget.cities;
  }

  void _filterCities(String searchTerm) {
    setState(() {
      filteredCities = widget.cities
          .where((city) =>
              city['name'].toLowerCase().contains(searchTerm.toLowerCase()))
          .toList();
      currentPage = 0;
    });
  }

  void openBrowserTab(double lat, double lng) async {
    var url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    await FlutterWebBrowser.openWebPage(url: url);
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (filteredCities.length / citiesPerPage).ceil();
    List<dynamic> citiesToShow = filteredCities
        .skip(currentPage * citiesPerPage)
        .take(citiesPerPage)
        .toList();

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
                  filteredCities = widget.cities;
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: citiesToShow.length,
              itemBuilder: (context, index) {
                var city = citiesToShow[index];
                return ListTile(
                  title: Text(city['name']),
                  subtitle: Text(
                      'Координаты: ${city['latitude']}, ${city['longitude']}'),
                  onTap: () =>
                      openBrowserTab(city['latitude'], city['longitude']),
                );
              },
            ),
          ),
          if (totalPages > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: currentPage > 0
                      ? () {
                          setState(() {
                            currentPage--;
                          });
                        }
                      : null,
                ),
                Text('Страница ${currentPage + 1} из $totalPages'),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: currentPage < totalPages - 1
                      ? () {
                          setState(() {
                            currentPage++;
                          });
                        }
                      : null,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

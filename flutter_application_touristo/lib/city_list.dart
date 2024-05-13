import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CityListScreen extends StatefulWidget {
  final List<dynamic> cities;

  const CityListScreen({super.key, required this.cities});

  @override
  _CityListScreenState createState() => _CityListScreenState();
}

class _CityListScreenState extends State<CityListScreen> {
  List<dynamic> filteredCities = [];
  bool isSearching = false;

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
    });
  }

  void _openMap(double lat, double lng) async {
    var uri =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
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
                  filteredCities = widget.cities;
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
            title: Text(city['name']),
            subtitle:
                Text('Координаты: ${city['latitude']}, ${city['longitude']}'),
            onTap: () => _openMap(city['latitude'], city['longitude']),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CityListScreen extends StatelessWidget {
  final List<dynamic> cities;

  CityListScreen({Key? key, required this.cities}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Список городов'),
      ),
      body: ListView.builder(
        itemCount: cities.length,
        itemBuilder: (context, index) {
          var city = cities[index];
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

  void _openMap(double lat, double lng) async {
    var url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

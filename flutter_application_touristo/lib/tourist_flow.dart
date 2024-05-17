import 'package:flutter/material.dart';

class TouristFlowScreen extends StatelessWidget {
  final String countryName;
  final String countryCode;
  final String url = 'http://10.0.2.2:5000';

  const TouristFlowScreen(
      {super.key, required this.countryName, required this.countryCode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о туристических потоках в $countryName'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('Общая информация о количестве\nтуристов в стране',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network('$url/api/flows/arrivals/$countryCode'),
            const SizedBox(height: 20),
            const Text('Информация о занятости в\nтуристической индустрии.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network('$url/api/flows/employment/$countryCode'),
            const SizedBox(height: 20),
            const Text('Туристические услуги в стране.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network('$url/api/flows/tourism_ind/$countryCode'),
            const SizedBox(height: 20),
            const Text('Каким путём путешествуют по стране.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Image.network('$url/api/flows/transport/$countryCode'),
          ],
        ),
      ),
    );
  }
}

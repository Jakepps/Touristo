import 'package:flutter/material.dart';

class TouristFlowScreen extends StatelessWidget {
  final String countryName;

  const TouristFlowScreen({super.key, required this.countryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о туристах в $countryName'),
      ),
      body: Center(
        child: Text(
            'Здесь будет информация о туристических поездках в $countryName.'),
      ),
    );
  }
}

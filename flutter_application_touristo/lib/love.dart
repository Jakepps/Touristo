import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'country.dart';

class FavoriteCountry {
  final String name;
  final String imagePath;
  final String countryCode;

  FavoriteCountry(
      {required this.name, required this.imagePath, required this.countryCode});
}

class LoveScreen extends StatefulWidget {
  const LoveScreen({super.key});

  @override
  _LoveScreenState createState() => _LoveScreenState();
}

class _LoveScreenState extends State<LoveScreen> {
  Future<List<FavoriteCountry>> fetchFavoriteCountries(int userId) async {
    var response =
        await http.get(Uri.parse('http://10.0.2.2:5000/favorites/$userId'));
    var jsonData = json.decode(response.body) as List;

    List<FavoriteCountry> countries = jsonData.map((data) {
      return FavoriteCountry(
        name: data['country_name'],
        imagePath: data['flag_path'],
        countryCode: data['country_code'],
      );
    }).toList();

    return countries;
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранные страны'),
      ),
      body: FutureBuilder<List<FavoriteCountry>>(
        future: fetchFavoriteCountries(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("Избранные страны не добавлены."));
          }

          return ListView.separated(
            itemCount: snapshot.data!.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            itemBuilder: (context, index) {
              final country = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(country.imagePath),
                ),
                title: Text(country.name, style: const TextStyle(fontSize: 25)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountryDetailsScreen(
                        countryName: country.name,
                        countryCode: country.countryCode,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

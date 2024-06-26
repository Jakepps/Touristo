import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:photo_view/photo_view.dart';

class TouristFlowScreen extends StatelessWidget {
  final String countryCode;
  final String countryName;
  final String url = 'http://10.0.2.2:5000';

  const TouristFlowScreen(
      {super.key, required this.countryCode, required this.countryName});

  Future<bool> checkImageExists(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    return response.statusCode != 404;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о тур. потоках'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text('• Общая информация о количестве\nтуристов в стране',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<bool>(
              future: checkImageExists(
                  '$url/api/flows/arrivals/$countryCode/$countryName'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!) {
                  return const Text(
                      'К сожалению, мы не\nнашли информацию о туризме.',
                      style: TextStyle(fontSize: 18));
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrl:
                                '$url/api/flows/arrivals/$countryCode/$countryName',
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                        '$url/api/flows/arrivals/$countryCode/$countryName'),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('• Информация о занятости в\nтуристической индустрии.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<bool>(
              future: checkImageExists(
                  '$url/api/flows/employment/$countryCode/$countryName'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!) {
                  return const Text(
                      'К сожалению, мы не\nнашли информацию о туризме.',
                      style: TextStyle(fontSize: 18));
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrl:
                                '$url/api/flows/employment/$countryCode/$countryName',
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                        '$url/api/flows/employment/$countryCode/$countryName'),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('• Туристические услуги в стране.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<bool>(
              future: checkImageExists(
                  '$url/api/flows/tourism_ind/$countryCode/$countryName'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!) {
                  return const Text(
                      'К сожалению, мы не\nнашли информацию о туризме.',
                      style: TextStyle(fontSize: 18));
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrl:
                                '$url/api/flows/tourism_ind/$countryCode/$countryName',
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                        '$url/api/flows/tourism_ind/$countryCode/$countryName'),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('• Уровень заполняемости в стране.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<bool>(
              future: checkImageExists(
                  '$url/api/flows/tourism_ind2/$countryCode/$countryName'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!) {
                  return const Text(
                      'К сожалению, мы не\nнашли информацию о туризме.',
                      style: TextStyle(fontSize: 18));
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrl:
                                '$url/api/flows/tourism_ind2/$countryCode/$countryName',
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                        '$url/api/flows/tourism_ind2/$countryCode/$countryName'),
                  );
                }
              },
            ),
            const SizedBox(height: 20),
            const Text('• Каким путём путешествуют по стране.',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            FutureBuilder<bool>(
              future: checkImageExists(
                  '$url/api/flows/transport/$countryCode/$countryName'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError ||
                    !snapshot.hasData ||
                    !snapshot.data!) {
                  return const Text(
                      'К сожалению, мы не\nнашли информацию о туризме.',
                      style: TextStyle(fontSize: 18));
                } else {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenImageViewer(
                            imageUrl:
                                '$url/api/flows/transport/$countryCode/$countryName',
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                        '$url/api/flows/transport/$countryCode/$countryName'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageViewer extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageViewer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(imageUrl),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class CountryDetailsScreen extends StatefulWidget {
  final String countryName;
  final Map<String, String> countryCodes;

  const CountryDetailsScreen(
      {super.key, required this.countryName, required this.countryCodes});

  @override
  _CountryDetailsScreenState createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  var inf = '';
  var facts = '';
  var tips = '';
  var flagURL = '';
  var languageNames = {};

  @override
  void initState() {
    super.initState();
    _fetchCountryData();
    _loadLanguageNames();
  }

  void _fetchCountryData() async {
    final countryCode = widget.countryCodes[widget.countryName];
    final httpUri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/api/country/$countryCode',
    );

    try {
      final response = await http
          .get(httpUri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          //общая информация о стране
          inf =
              'Альфа-коды ${widget.countryName}: ${data[countryCode]['alpha2Code']}, ${data[countryCode]['alpha3Code']}.\n';
          inf +=
              'Столицей страны является город ${data[countryCode]['capital']}.\n';

          final currencies = data[countryCode]['currencies'];
          final currencyCode = currencies.keys.first;
          inf +=
              'Валютой является ${currencies[currencyCode]['name']} - ${currencyCode.toString()} (${currencies[currencyCode]['symbol']})';

          final languages = data[countryCode]['languages'];
          final languageNames = languages.values.toList();
          if (languageNames.length > 1) {
            final languageString = languageNames.join(', ');
            inf += ', а государственными языками являются $languageString.\n';
          } else if (languageNames.length == 1) {
            inf += ', а государственным языком является ${languageNames[0]}.\n';
          }

          final timezones = data[countryCode]['timezones'];
          inf +=
              '${widget.countryName} находится в ${timezones.length} часовых поясах, а именно: ${timezones.join(', ')}.';

          //интересные факты
          facts +=
              '${widget.countryName} граничит с ${data[countryCode]['borders'].length} странами, а именно: ${data[countryCode]['borders'].join(', ')}.\n';

          facts +=
              'На данный момент в стране проживает ${data[countryCode]['population']} человек!\n';

          final gini = data[countryCode]['gini'];
          final giniValue = gini[gini.keys.first];

          String giniInfo = '';

          if (giniValue < 30) {
            giniInfo =
                'Этот низкий уровень неравенства указывает на высокий уровень равенства в распределении доходов страны.';
          } else if (giniValue >= 30 && giniValue < 40) {
            giniInfo =
                'Этот уровень неравенства указывает на умеренное неравенство в распределении доходов страны.';
          } else if (giniValue >= 40 && giniValue < 50) {
            giniInfo =
                'Этот уровень неравенства указывает на значительное неравенство в распределении доходов страны.';
          } else {
            giniInfo =
                'Этот высокий уровень неравенства указывает на значительные социальные и экономические неравенства в стране.';
          }
          facts +=
              'А вы знали, что на момент ${gini.keys.first} г. ${widget.countryName} имеет коэффициент Джини равный $giniValue. $giniInfo';

          //Советы
          tips =
              'Не знаете какой домен в сети Интернет? ${widget.countryName} имеет домен: ${data[countryCode]['topLevelDomain'].join(', ')}\n';
          tips +=
              'Телефонный код? Запросто! ${widget.countryName} имеет телефоный код: ${data[countryCode]['callingCode']}.\n';

          final translations =
              data[widget.countryCodes[widget.countryName]]['translations'];

          translations.forEach((language, translation) {
            tips += 'На ${_getLanguageName(language)}: $translation \n';
          });

          //флаг
          flagURL = data[countryCode]['flag']['large'];
        });
      } else {
        throw Exception('Failed to load country data');
      }
    } catch (e) {
      print('Error fetching country data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали страны: ${widget.countryName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(flagURL),
                    //AssetImage('assets/images/${widget.countryName}.jpg'),
                    radius: 30,
                  ),
                  const SizedBox(width: 20),
                  Text(
                    widget.countryName,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Добавить в избранное
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Информация о стране:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                inf.isNotEmpty ? inf : 'Информация о стране загружается...',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Интересные факты:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                facts.isNotEmpty ? facts : 'Факты загружаются...',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Советы для путешественников:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                tips.isNotEmpty ? tips : 'Советы загружаются...',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadLanguageNames() async {
    try {
      final String data =
          await rootBundle.loadString('assets/files/language_codes.txt');
      final List<String> lines = data.split('\n');
      for (String line in lines) {
        final List<String> parts = line.split(':');
        final String key = parts[0].trim().replaceAll('\'', '');
        final String value = parts[1].trim().replaceAll('\'', '');
        languageNames[key] = value;
      }
    } catch (e) {
      print('Error loading language names: $e');
    }
  }

  String _getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
}

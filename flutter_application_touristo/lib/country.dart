import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:translator/translator.dart';

class CountryDetailsScreen extends StatefulWidget {
  final String countryName;
  final String countryCode;

  const CountryDetailsScreen(
      {super.key, required this.countryName, required this.countryCode});

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

  Future<List<String>> _translateTexts(List<String> texts) async {
    List<String> translatedTexts = [];
    final translator = GoogleTranslator();
    for (String text in texts) {
      if (containsCyrillic(text)) {
        translatedTexts.add(text);
      } else {
        final translatedText = await translator.translate(text, to: 'ru');
        translatedTexts.add(translatedText.toString());
      }
    }
    return translatedTexts;
  }

  bool containsCyrillic(String text) {
    return text.runes.any((int rune) {
      var char = String.fromCharCode(rune);
      return char.contains(RegExp(r'[а-яА-ЯёЁ]'));
    });
  }

  void _fetchCountryData() async {
    final httpUri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/api/country/${widget.countryCode}',
    );
    List<String> textsToTranslate = [];

    try {
      final response = await http
          .get(httpUri, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        String capital = data[widget.countryCode]['capital'];
        if (capital != 'N/A') {
          textsToTranslate.add(capital);
        }

        final currencies = data[widget.countryCode]['currencies'];
        textsToTranslate.add(data[widget.countryCode]['currencies']
            [currencies.keys.first]['name']);

        final languages = data[widget.countryCode]['languages'];
        List<String> langCodes = [];
        languages.forEach((key, value) {
          if (value is List) {
            langCodes.addAll(value.cast<String>());
          } else if (value is String) {
            langCodes.add(value);
          }
        });

        textsToTranslate.addAll(langCodes);
        List<String> translatedTexts = await _translateTexts(textsToTranslate);

        setState(() {
          _buildCountryInfo(data, widget.countryCode, translatedTexts);
          _buildInterestingFacts(data, widget.countryCode);
          _buildTravelTips(data, widget.countryCode);
          _buildFlagURL(data, widget.countryCode);
        });
      } else {
        throw Exception('Failed to load country data');
      }
    } catch (e) {
      print('Error fetching country data: $e');
    }
  }

  void _buildCountryInfo(Map<String, dynamic> data, String countryCode,
      List<String> textsTranslate) {
    // Общая информация о стране
    inf =
        '• Альфа-коды ${widget.countryName}: ${data[countryCode]['alpha2Code']}, ${data[countryCode]['alpha3Code']}.\n\n';

    if (data[countryCode]['capital'] != 'N/A') {
      inf += '• Столицей страны является город ${textsTranslate[0]}.\n\n';
    } else {
      inf += '• Нет информации о сталице страны.\n\n';
    }

    final currencies = data[countryCode]['currencies'];
    final currencyCode = currencies.keys.first;
    inf +=
        '• Валютой является ${textsTranslate[1]} - ${currencyCode.toString()} (${currencies[currencyCode]['symbol']})';

    final languageNamesToAdd = textsTranslate.sublist(2);
    var languageNamesLocal = [];
    languageNamesLocal.addAll(languageNamesToAdd);
    if (languageNamesLocal.length > 1) {
      final languageString = languageNamesLocal.join(', ');
      inf += ', а государственными языками являются $languageString.\n\n';
    } else if (languageNamesLocal.length == 1) {
      inf +=
          ', а государственным языком является ${languageNamesLocal[0]}.\n\n';
    }

    final timezones = data[countryCode]['timezones'];
    var timezoneCount = timezones.length;
    var suffix = timezoneCount == 1 ? 'часовом поясе' : 'часовых поясах';
    inf +=
        '• ${widget.countryName} находится в $timezoneCount $suffix, а именно: ${timezones.join(', ')}.';
  }

  void _buildInterestingFacts(Map<String, dynamic> data, String countryCode) {
    // Интересные факты
    String bordersInfo;
    if (data[countryCode]['borders'] == 'N/A') {
      bordersInfo =
          '• ${widget.countryName} не граничит ни с одной страной.\n\n';
    } else {
      bordersInfo =
          '• ${widget.countryName} граничит с ${data[countryCode]['borders'].length} странами, а именно: ${data[countryCode]['borders'].join(', ')}.\n\n';
    }
    facts += bordersInfo;
    facts +=
        '• На данный момент в стране проживает ${data[countryCode]['population']} человек!\n\n';

    final gini = data[countryCode]['gini'];
    if (gini == 'Not Available') {
      facts +=
          '• На данный момент ${widget.countryName} не имеет коэффициента Джини.\n';
    } else {
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
          '• А вы знали, что на момент ${gini.keys.first} г. ${widget.countryName} имеет коэффициент Джини равный $giniValue. $giniInfo';
    }
  }

  void _buildTravelTips(Map<String, dynamic> data, String countryCode) {
    // Советы
    tips =
        '• Не знаете какой домен в сети Интернет? ${widget.countryName} имеет домен: ${data[countryCode]['topLevelDomain'].join(', ')}\n\n';
    tips +=
        '• Телефонный код? Запросто! ${widget.countryName} имеет телефоный код: ${data[countryCode]['callingCode']}.\n\n';
    tips += '• Название страны на различных языках: \n';
    final translations = data[widget.countryCode]['translations'];

    translations.forEach((language, translation) {
      tips += 'На ${_getLanguageName(language)}: $translation \n';
    });
  }

  void _buildFlagURL(Map<String, dynamic> data, String countryCode) {
    // Флаг
    flagURL = data[countryCode]['flag']['large'];
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
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        widget.countryName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
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
        languageNames[key] = value.replaceAll(',', '');
      }
    } catch (e) {
      print('Error loading language names: $e');
    }
  }

  String _getLanguageName(String languageCode) {
    return languageNames[languageCode] ?? languageCode;
  }
}

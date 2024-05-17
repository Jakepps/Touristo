import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:translator/translator.dart';
import 'auth_provider.dart';
import 'package:flutter/gestures.dart';
import 'city_list.dart';
import 'tourist_flow.dart';

class CountryDetailsScreen extends StatefulWidget {
  final String countryName;
  final String countryCode;
  final bool cameFromLove;

  const CountryDetailsScreen(
      {super.key,
      required this.countryName,
      required this.countryCode,
      this.cameFromLove = false});

  @override
  _CountryDetailsScreenState createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  var inf = '';
  var facts = '';
  var tips = '';
  var flagURL = '';
  var languageNames = {};
  Map<String, String> countryCodeToName = {};
  bool isFavorite = false;
  Widget factsWidget = const SizedBox();
  List<dynamic> cities = [];

  @override
  void initState() {
    super.initState();
    _fetchCountryData();
    _loadLanguageNames();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;
    final response = await http.get(Uri.parse(
        'http://10.0.2.2:5000/is_favorite/$userId/${widget.countryCode}'));
    if (response.statusCode == 200) {
      setState(() {
        isFavorite = json.decode(response.body)['is_favorite'];
      });
    }
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

  void _fetchAllCities(int currentPage, List<dynamic> accumulatedCities) async {
    final httpUriCities = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/api/country/${widget.countryCode}/cities',
      queryParameters: {
        'page': currentPage.toString(),
        'per_page': '50',
      },
    );

    try {
      final responseCity = await http
          .get(httpUriCities, headers: {'Content-Type': 'application/json'});
      if (responseCity.statusCode == 200) {
        final dataCity = json.decode(responseCity.body);
        final List<dynamic> cities = dataCity['cities'];
        accumulatedCities.addAll(cities);

        if (currentPage * 50 < dataCity['total_cities']) {
          _fetchAllCities(currentPage + 1, accumulatedCities);
        } else {
          setState(() {
            this.cities = accumulatedCities;
          });
        }
      } else if (responseCity.statusCode == 404) {
        setState(() {
          cities = ["Нет информации о городах в этой стране"];
        });
        print('Нет информации о городах в этой стране');
      } else {
        throw Exception('Failed to load city data');
      }
    } catch (e) {
      throw Exception('Error fetching city data: $e');
    }
  }

  void _fetchCountryData() async {
    final httpUri = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/api/country/${widget.countryCode}',
    );

    final httpUriCitiesCount = Uri(
      scheme: 'http',
      host: '10.0.2.2',
      port: 5000,
      path: '/api/country/${widget.countryCode}/count_cities',
    );

    List<String> textsToTranslate = [];

    try {
      countryCodeToName = await _loadBorderCodes();
      final response = await http
          .get(httpUri, headers: {'Content-Type': 'application/json'});

      final responseCity = await http.get(httpUriCitiesCount,
          headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        Map<String, dynamic> dataCity = {};
        if (responseCity.statusCode == 200) {
          dataCity = json.decode(responseCity.body);
        } else {
          dataCity = {};
        }
        final data = json.decode(response.body);
        //final dataCity = json.decode(responseCity.body);

        _fetchAllCities(1, []);

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
          _buildInterestingFacts(data, widget.countryCode, dataCity);
          _buildTravelTips(data, widget.countryCode);
          _buildFlagURL(data, widget.countryCode);
        });
      } else {
        throw Exception('Failed to load country data');
      }
    } catch (e) {
      throw Exception('Error fetching country data: $e');
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

  void _buildInterestingFacts(Map<String, dynamic> data, String countryCode,
      Map<String, dynamic> dataCity) {
    // Интересные факты

    String bordersInfo = '';
    final borders = data[countryCode]['borders'];
    if (borders == 'N/A') {
      bordersInfo =
          '• ${widget.countryName} не граничит ни с одной страной.\n\n';
    } else {
      List<String> borderCountries = [];
      for (var borderCode in borders) {
        if (countryCodeToName.containsKey(borderCode)) {
          borderCountries.add(countryCodeToName[borderCode]!);
        }
      }

      if (borderCountries.isNotEmpty) {
        if (borderCountries.length == 1) {
          bordersInfo =
              '• ${widget.countryName} граничит с ${borderCountries.length} страной, а именно: ${borderCountries.join(', ')}.\n\n';
        } else {
          bordersInfo =
              '• ${widget.countryName} граничит с ${borderCountries.length} странами, а именно: ${borderCountries.join(', ')}.\n\n';
        }
      } else {
        bordersInfo =
            '• ${widget.countryName} не граничит ни с одной из стран, которые присутсвуют в нынешней базе данных.\n\n';
      }
    }
    facts += bordersInfo;

    facts +=
        '• На данный момент в стране проживает ${data[countryCode]['population']} человек!\n\n';

    String citiesInfo = '';
    if (dataCity.isEmpty) {
      citiesInfo += '• Нет информации о городах в этой стране.\n';
    } else {
      citiesInfo +=
          '• В стране находится целых ${dataCity['cities_count']} городов!\n';
    }
    factsWidget = RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black, fontSize: 16),
        children: <TextSpan>[
          TextSpan(
            text: citiesInfo,
            style: dataCity.isNotEmpty
                ? const TextStyle(
                    color: Colors.blue, decoration: TextDecoration.underline)
                : const TextStyle(
                    color: Colors.black, decoration: TextDecoration.none),
            recognizer: dataCity.isNotEmpty
                ? (TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CityListScreen(cities: cities),
                      ),
                    );
                  })
                : null,
          ),
        ],
      ),
    );
    setState(() {});

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
    final bool isAuthenticated =
        Provider.of<AuthProvider>(context).isAuthenticated;
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
                  if (isAuthenticated)
                    IconButton(
                      icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border),
                      color: isFavorite ? Colors.red : null,
                      onPressed: () {
                        final provider =
                            Provider.of<AuthProvider>(context, listen: false);
                        if (isFavorite) {
                          provider.removeFavorite(widget.countryCode).then((_) {
                            setState(() {
                              isFavorite = false;
                            });
                            if (widget.cameFromLove) {
                              Navigator.pop(context, true);
                            }
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Ошибка удаления страны из избранного: $error')));
                          });
                        } else {
                          provider.addToFavorites(widget.countryCode).then((_) {
                            setState(() {
                              isFavorite = true;
                            });
                          }).catchError((error) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    'Ошибка добавления страны в избранное: $error')));
                          });
                        }
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
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Информация о туристических поездках.',
                      style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TouristFlowScreen(
                                countryCode: widget.countryCode,
                              ),
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Интересные факты:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              factsWidget,
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

  Future<Map<String, String>> _loadBorderCodes() async {
    Map<String, String> countryCodes = {};
    try {
      String data =
          await rootBundle.loadString('assets/files/border_codes.txt');

      data = data
          .replaceAll("'", '')
          .replaceAll('{', '')
          .replaceAll('}', '')
          .replaceAll(',', '')
          .replaceAll('"', '');

      List<String> rows = data.split('\n');

      for (String row in rows) {
        List<String> parts = row.split(':');
        if (parts.length == 2) {
          String country = parts[0].trim();
          String code = parts[1].trim();
          countryCodes[country] = code;
        }
      }
    } catch (e) {
      print('Error load data: $e');
    }
    return countryCodes;
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

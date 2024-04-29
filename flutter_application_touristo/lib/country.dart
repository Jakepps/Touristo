import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryDetailsScreen extends StatefulWidget {
  final String countryName;

  const CountryDetailsScreen({super.key, required this.countryName});

  @override
  _CountryDetailsScreenState createState() => _CountryDetailsScreenState();
}

class _CountryDetailsScreenState extends State<CountryDetailsScreen> {
  var region = '';
  var subregion = '';
  var officialName = '';
  var flagURL = '';

  @override
  void initState() {
    super.initState();
    _fetchCountryData();
  }

  void _fetchCountryData() async {
    final countryCode = _getCountryCode(widget.countryName);
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
          region = data[countryCode]['region'];
          subregion = data[countryCode]['subregion'];
          officialName = data[countryCode]['official_name'];
          flagURL = data[countryCode]['flag']['large'];
        });
      } else {
        throw Exception('Failed to load country data');
      }
    } catch (e) {
      print('Error fetching country data: $e');
    }
  }

  String _getCountryCode(String countryName) {
    final countryCodes = {
      'Афганистан': 'af',
      'Судан': 'sd',
      'Бурунди': 'bi',
      'Мексика': 'mx',
      'Куба': 'cu',
      'Сербия': 'rs',
      'Монако': 'mc',
      'Бутан': 'bt',
      'Гайана': 'gy',
      'Южная Георгия': 'gs',
      'Босния и Герцеговина': 'ba',
      'Бруней': 'bn',
      'Пакистан': 'pk',
      'Кения': 'ke',
      'Пуэрто-Рико': 'pr',
      'Сомали': 'so',
      'Шпицберген и Ян-Майен': 'sj',
      'Сьерра-Леоне': 'sl',
      'Французская Полинезия': 'pf',
      'Азербайджан': 'az',
      'Острова Кука': 'ck',
      'Перу': 'pe',
      'Остров Буве': 'bv',
      'Северные Марианские острова': 'mp',
      'Ангола': 'ao',
      'Республика Конго': 'cg',
      'Южный Судан': 'ss',
      'Сен-Мартен': 'mf',
      'Турция': 'tr',
      'Ангилья': 'ai',
      'Сент-Китс и Невис': 'kn',
      'Аруба': 'aw',
      'Теркс и Кайкос': 'tc',
      'Тайвань': 'tw',
      'Швеция': 'se',
      'Либерия': 'lr',
      'Венесуэла': 've',
      'Виргинские острова (США)': 'vi',
      'Бермуды': 'bm',
      'Албания': 'al',
      'Гонконг': 'hk',
      'Люксембург': 'lu',
      'Эритрея': 'er',
      'Колумбия': 'co',
      'Карибские Нидерланды': 'bq',
      'Монголия': 'mn',
      'Йемен': 'ye',
      'Ливан': 'lb',
      'Антигуа и Барбуда': 'ag',
      'Вьетнам': 'vn',
      'Палау': 'pw',
      'Джерси': 'je',
      'Тринидад и Тобаго': 'tt',
      'Израиль': 'il',
      'Болгария': 'bg',
      'Португалия': 'pt',
      'Гибралтар': 'gi',
      'Сан-Марино': 'sm',
      'Сингапур': 'sg',
      'Синт-Мартен': 'sx',
      'Саудовская Аравия': 'sa',
      'Гана': 'gh',
      'Молдова': 'md',
      'Чад': 'td',
      'Антарктика': 'aq',
      'Великобритания': 'gb',
      'Папуа – Новая Гвинея': 'pg',
      'Французские Южные и Антарктические территории': 'tf',
      'Внешние малые острова США': 'um',
      'Белиз': 'bz',
      'Коморские острова': 'km',
      'Буркина-Фасо': 'bf',
      'Фарерские острова': 'fo',
      'Гвинея': 'gn',
      'Индия': 'in',
      'Кюрасао': 'cw',
      'Того': 'tg',
      'Тунис': 'tn',
      'Сен-Бартелеми': 'bl',
      'Индонезия': 'id',
      'Микронезия': 'fm',
      'Австрия': 'at',
      'Таджикистан': 'tj',
      'Демократическая Республика Конго': 'cd',
      'Майотта': 'yt',
      'Реюньон': 're',
      'Румыния': 'ro',
      'Катар': 'qa',
      'Литва': 'lt',
      'Китай': 'cn',
      'Новая Зеландия': 'nz',
      'Норфолк': 'nf',
      'Мавритания': 'mr',
      'Узбекистан': 'uz',
      'Финляндия': 'fi',
      'Камерун': 'cm',
      'Острова Херд и Макдональд': 'hm',
      'Доминика': 'dm',
      'Исландия': 'is',
      'Оман': 'om',
      'Северная Македония': 'mk',
      'Лихтенштейн': 'li',
      'Испания': 'es',
      'Греция': 'gr',
      'Парагвай': 'py',
      'Бахрейн': 'bh',
      'Ниуэ': 'nu',
      'Сенегал': 'sn',
      'Монтсеррат': 'ms',
      'Латвия': 'lv',
      'Токелау': 'tk',
      'Япония': 'jp',
      'Центральноафриканская Республика': 'cf',
      'Габон': 'ga',
      'Ирак': 'iq',
      'Остров Мэн': 'im',
      'Мьянма': 'mm',
      'Черногория': 'me',
      'Науру': 'nr',
      'Вануату': 'vu',
      'Франция': 'fr',
      'Зимбабве': 'zw',
      'Филиппины': 'ph',
      'Словакия': 'sk',
      'Австралия': 'au',
      'Кот-д’Ивуар': 'ci',
      'Британская территория в Индийском океане': 'io',
      'Эсватини': 'sz',
      'Руанда': 'rw',
      'Бенин': 'bj',
      'Британские Виргинские острова': 'vg',
      'Уганда': 'ug',
      'Ирландия': 'ie',
      'Иран': 'ir',
      'Словения': 'si',
      'Мали': 'ml',
      'Швейцария': 'ch',
      'Американское Самоа': 'as',
      'Уругвай': 'uy',
      'Гуам': 'gu',
      'Суринам': 'sr',
      'Украина': 'ua',
      'Чехия': 'cz',
      'Гондурас': 'hn',
      'Самоа': 'ws',
      'Лаос': 'la',
      'Кабо-Верде': 'cv',
      'Эфиопия': 'et',
      'Бангладеш': 'bd',
      'Остров Святой Елены, Вознесения и Тристан-да-Кунья': 'sh',
      'Беларусь': 'by',
      'Хорватия': 'hr',
      'Кувейт': 'kw',
      'Французская Гвиана': 'gf',
      'Марокко': 'ma',
      'Россия': 'ru',
      'Эстония': 'ee',
      'Шри-Ланка': 'lk',
      'Новая Каледония': 'nc',
      'Польша': 'pl',
      'Мадагаскар': 'mg',
      'Коста-Рика': 'cr',
      'Сальвадор': 'sv',
      'Макао': 'mo',
      'Андорра': 'ad',
      'Италия': 'it',
      'Намибия': 'na',
      'Сейшельские Острова': 'sc',
      'Панама': 'pa',
      'Гаити': 'ht',
      'Аргентина': 'ar',
      'Нигер': 'ne',
      'Малави': 'mw',
      'Острова Питкэрн': 'pn',
      'Германия': 'de',
      'Кирибати': 'ki',
      'Сирия': 'sy',
      'Маршалловы Острова': 'mh',
      'Венгрия': 'hu',
      'Острова Кайман': 'ky',
      'Дания': 'dk',
      'Сент-Люсия': 'lc',
      'Боливия': 'bo',
      'Джибути': 'dj',
      'Южно-Африканская Республика': 'za',
      'Нигерия': 'ng',
      'Сан-Томе и Принсипи': 'st',
      'Никарагуа': 'ni',
      'Гваделупа': 'gp',
      'Сен-Пьер и Микелон': 'pm',
      'Эквадор': 'ec',
      'Гренландия': 'gl',
      'Гренада': 'gd',
      'Багамские Острова': 'bs',
      'Чили': 'cl',
      'Малайзия': 'my',
      'Тувалу': 'tv',
      'Остров Рождества': 'cx',
      'Соломоновы Острова': 'sb',
      'Танзания': 'tz',
      'Северная Корея': 'kp',
      'Гвинея-Бисау': 'gw',
      'Косово': 'xk',
      'Ватикан': 'va',
      'Норвегия': 'no',
      'Палестина': 'ps',
      'Кокосовые острова (Килинг)': 'cc',
      'Ямайка': 'jm',
      'Египет': 'eg',
      'Камбоджа': 'kh',
      'Маврикий': 'mu',
      'Гамбия': 'gm',
      'Экваториальная Гвинея': 'gq',
      'Лесото': 'ls',
      'Мартиника': 'mq',
      'Соединенные Штаты Америки': 'us',
      'Америка': 'us',
      'США': 'us',
      'Западная Сахара': 'eh',
      'Объединенные Арабские Эмираты': 'ae',
      'ОАЭ': 'ae',
      'Мозамбик': 'mz',
      'Алжир': 'dz',
      'Замбия': 'zm',
      'Гватемала': 'gt',
      'Южная Корея': 'kr',
      'Киргизия': 'kg',
      'Восточный Тимор': 'tl',
      'Аландские острова': 'ax',
      'Иордания': 'jo',
      'Мальта': 'mt',
      'Кипр': 'cy',
      'Фолклендские острова': 'fk',
      'Казахстан': 'kz',
      'Ботсвана': 'bw',
      'Святой Винсент и Гренадины': 'vc',
      'Барбадос': 'bb',
      'Тонга': 'to',
      'Таиланд': 'th',
      'Бельгия': 'be',
      'Канада': 'ca',
      'Грузия': 'ge',
      'Уоллис и Футуна': 'wf',
      'Фиджи': 'fj',
      'Нидерланды': 'nl',
      'Армения': 'am',
      'Доминиканская Республика': 'do',
      'Гернси': 'gg',
      'Туркменистан': 'tm',
      'Непал': 'np',
      'Мальдивы': 'mv',
      'Ливия': 'ly',
      'Бразилия': 'br'
    };
    return countryCodes[countryName] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Детали страны: ${widget.countryName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
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
              'Текстовая информация о стране:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              region.isNotEmpty ? region : 'Информация о стране загружается...',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Интересные факты:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              subregion.isNotEmpty ? subregion : 'Факты загружаются...',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Советы для путешественников:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              officialName.isNotEmpty ? officialName : 'Советы загружаются...',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

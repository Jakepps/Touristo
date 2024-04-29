import 'package:flutter/material.dart';
import 'country.dart';

class SearchResultsScreen extends StatelessWidget {
  final String countryName;

  const SearchResultsScreen({super.key, required this.countryName});

  static final Map<String, String> countryCodes = {
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
    'Западная Сахара': 'eh',
    'Объединенные Арабские Эмираты': 'ae',
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

  @override
  Widget build(BuildContext context) {
    final countryCode = countryCodes[countryName] ?? countryName;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Результаты поиска: $countryName'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GestureDetector(
            onTap: () {
              _fetchCountryDetails(countryCode, context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.map,
                  size: 40,
                ),
                const SizedBox(height: 20),
                Text(
                  countryName,
                  style: const TextStyle(fontSize: 30),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _fetchCountryDetails(String countryCode, BuildContext context) async {
    void showNotFoundError() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Ошибка'),
            content: const Text('Страна не найдена'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    if (!countryCodes.containsValue(countryCode)) {
      showNotFoundError();
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CountryDetailsScreen(countryName: countryName)),
    );
  }
}

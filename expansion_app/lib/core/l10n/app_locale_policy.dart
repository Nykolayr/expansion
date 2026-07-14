import 'dart:ui';

/// Правила языка по умолчанию (первый запуск, без сохранённых настроек).
///
/// Русский: постсоветские республики, кроме Украины и Прибалтики.
/// Английский: Украина, Латвия, Литва, Эстония и остальной мир.
abstract final class AppLocalePolicy {
  static const Locale russian = Locale('ru');
  static const Locale english = Locale('en');

  /// Бывшие республики СССР → русский по умолчанию.
  static const Set<String> russianDefaultCountries = {
    'AM', // Армения
    'AZ', // Азербайджан
    'BY', // Беларусь
    'GE', // Грузия
    'KZ', // Казахстан
    'KG', // Киргизия
    'MD', // Молдова
    'RU', // Россия
    'TJ', // Таджикистан
    'TM', // Туркменистан
    'UZ', // Узбекистан
  };

  /// Украина и Прибалтика → английский по умолчанию.
  static const Set<String> englishDefaultCountries = {
    'UA',
    'LV',
    'LT',
    'EE',
  };

  /// Языки системы, для которых вне UA/Прибaltики выбираем русский.
  static const Set<String> cisLanguageCodes = {
    'ru',
    'kk',
    'be',
    'ky',
    'uz',
    'tg',
    'tk',
    'az',
    'hy',
    'ka',
  };

  static Locale resolveDefault(Locale systemLocale) {
    final country = systemLocale.countryCode?.toUpperCase();
    final lang = systemLocale.languageCode.toLowerCase();

    if (country != null) {
      if (englishDefaultCountries.contains(country)) {
        return english;
      }
      if (russianDefaultCountries.contains(country)) {
        return russian;
      }
    }

    if (cisLanguageCodes.contains(lang)) {
      return russian;
    }

    if (lang == 'uk' || lang == 'lv' || lang == 'lt' || lang == 'et') {
      return english;
    }

    if (lang == 'ru') {
      return russian;
    }

    return english;
  }
}

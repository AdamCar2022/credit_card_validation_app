import 'package:hive/hive.dart';

class BannedCountriesService {
  static List<String> getAllBannedCountries() {
    final bannedCountriesBox = Hive.box('configBannedCountries');
    return List<String>.from(
      bannedCountriesBox.get('bannedCountries', defaultValue: <String>[]),
    );
  }

  static bool isCountryBanned(String country) {
    return getAllBannedCountries().contains(country);
  }

  static Future<void> addCountry(String country) async {
    final bcBox = Hive.box('configBannedCountries');
    final current = getAllBannedCountries();

    if (!current.contains(country)) {
      current.add(country);
      await bcBox.put('bannedCountries', current);
    }
  }

  static Future<void> removeCountry(String country) async {
    final bcBoxRemove = Hive.box('configBannedCountries');
    final current = getAllBannedCountries();
    current.remove(country);
    await bcBoxRemove.put('bannedCountries', current);
  }
}

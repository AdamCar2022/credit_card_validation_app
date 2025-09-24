import 'package:bloc/bloc.dart';
import 'package:credit_card_validation_app/core/utils/banned_countries.dart';

class BannedCountriesCubit extends Cubit<List<String>> {
  BannedCountriesCubit()
    : super(BannedCountriesService.getAllBannedCountries());

  Future<void> addBannedCountry(String bannedCountry) async {
    await BannedCountriesService.addCountry(bannedCountry);
    emit(BannedCountriesService.getAllBannedCountries());
  }

  Future<void> removeBannedCountry(String bannedCountry) async {
    await BannedCountriesService.removeCountry(bannedCountry);
    emit(BannedCountriesService.getAllBannedCountries());
  }
}

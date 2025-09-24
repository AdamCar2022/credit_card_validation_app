import 'package:country_picker/country_picker.dart';
import 'package:credit_card_validation_app/logic/banned_countries/banned_countries_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BannedCountriesScreen extends StatelessWidget {
  const BannedCountriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BannedCountriesCubit(),
      child: Scaffold(
        backgroundColor: Colors.greenAccent,
        appBar: AppBar(
          title: Text('Banned Countries'),
          backgroundColor: Colors.greenAccent,
        ),
        body: BlocBuilder<BannedCountriesCubit, List<String>>(
          builder: (context, bannedCountries) {
            if (bannedCountries.isEmpty) {
              return Center(
                child: Text('There are no banned countries at the moment'),
              );
            }

            return ListView.builder(
              itemCount: bannedCountries.length,
              itemBuilder: (context, index) {
                final bannedCountryName = bannedCountries[index];
                return Card(
                  color: Colors.teal,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: buildBannedCountryFlag(bannedCountryName),
                    title: Text(
                      bannedCountryName,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        context
                            .read<BannedCountriesCubit>()
                            .removeBannedCountry(bannedCountryName);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$bannedCountryName has been removed from your banned countries',
                            ),
                          ),
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.lightGreen),
                    ),
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            final bcCubit = context.read<BannedCountriesCubit>();

            showCountryPicker(
              context: context,
              showPhoneCode: false,
              onSelect: (bannedCountry) async {
                Navigator.of(context).pop();
                await bcCubit.addBannedCountry(bannedCountry.name);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${bannedCountry.name} has been added to your banned countries',
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildBannedCountryFlag(String bannedCountryName) {
    final country = Country.tryParse(bannedCountryName);
    if (country != null) {
      return Text(country.flagEmoji, style: TextStyle(fontSize: 28));
    }
    return Icon(Icons.flag);
  }
}

import 'package:credit_card_validation_app/data/models/credit_card.dart';
import 'package:credit_card_validation_app/logic/banned_countries/banned_countries_cubit.dart';
import 'package:credit_card_validation_app/logic/card/card_bloc.dart';
import 'package:credit_card_validation_app/logic/card/card_cubit.dart';
import 'package:credit_card_validation_app/presentation/screens/add_card_screen.dart';
import 'package:credit_card_validation_app/presentation/screens/banned_countries_screen.dart';
import 'package:credit_card_validation_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CreditCardAdapter());
  await Hive.openBox<CreditCard>('creditCards');
  await Hive.openBox('configBannedCountries');

  final configBannedCountries = Hive.box('configBannedCountries');
  if (configBannedCountries.get('bannedCountries') == null) {
    await configBannedCountries.put('bannedCountries', [
      'North Korea',
      'Burma',
      'Antarctica',
      'Barbados',
      'Côte d’Ivoire',
      'Afghanistan',
      'Belarus',
      'Cuba',
      'Iran',
    ]);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final creditCardBox = Hive.box<CreditCard>('creditCards');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CreditCardBloc(creditCardBox)..add(LoadCreditCards()),
        ),
        BlocProvider(create: (_) => BannedCountriesCubit()),
      ],
      child: MaterialApp(
        title: 'Credit Card Validator',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const CardHomeScreen(),
          '/add_card': (context) => const AddCardScreen(),
          '/banned_countries': (context) => const BannedCountriesScreen(),
        },
      ),
    );
  }
}

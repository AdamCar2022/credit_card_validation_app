import 'package:hive/hive.dart';
part 'credit_card.g.dart';

@HiveType(typeId: 0)
class CreditCard extends HiveObject {
  @HiveField(0)
  String cardNumber;
  @HiveField(1)
  String cardType;
  @HiveField(2)
  String cvv;
  @HiveField(3)
  String? issuingCountry;
  @HiveField(4)
  String cardHolder;
  @HiveField(5)
  String validDate;

  CreditCard({
    required this.cardNumber,
    required this.cardType,
    required this.cvv,
    required this.issuingCountry,
    required this.cardHolder,
    required this.validDate,
  });
}

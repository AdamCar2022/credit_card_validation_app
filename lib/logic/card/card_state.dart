import 'package:credit_card_validation_app/data/models/credit_card.dart';

abstract class CreditCardState {}

class CreditCardLoading extends CreditCardState {}

class CreditCardLoaded extends CreditCardState {
  final List<CreditCard> creditCards;

  CreditCardLoaded(this.creditCards);
}

class CreditCardError extends CreditCardState {
  final String errorMessage;
  final List<CreditCard> creditCards;

  CreditCardError(this.errorMessage, this.creditCards);
}

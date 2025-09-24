import 'package:credit_card_validation_app/data/models/credit_card.dart';

abstract class CreditCardEvent {}

class AddCreditCard extends CreditCardEvent {
  final CreditCard creditCard;

  AddCreditCard(this.creditCard);
}

class UpdateCreditCard extends CreditCardEvent {
  final int index;
  final CreditCard updatedCreditCard;

  UpdateCreditCard(this.index, this.updatedCreditCard);
}

class DeleteCreditCard extends CreditCardEvent {
  final int index;

  DeleteCreditCard(this.index);
}

class LoadCreditCards extends CreditCardEvent {}

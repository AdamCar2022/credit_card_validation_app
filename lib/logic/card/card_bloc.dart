import 'package:bloc/bloc.dart';
import 'package:credit_card_validation_app/data/models/credit_card.dart';
import 'package:credit_card_validation_app/logic/card/card_cubit.dart';
import 'package:credit_card_validation_app/logic/card/card_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CreditCardBloc extends Bloc<CreditCardEvent, CreditCardState> {
  final Box<CreditCard> creditCardBox;

  CreditCardBloc(this.creditCardBox) : super(CreditCardLoading()) {
    on<LoadCreditCards>((event, emit) {
      List<CreditCard> creditCards = creditCardBox.values.toList();
      emit(CreditCardLoaded(creditCards));
    });

    on<AddCreditCard>((event, emit) {
      final exists = creditCardBox.values.any(
        (card) => card.cardNumber == event.creditCard.cardNumber,
      );

      if (exists) {
        emit(
          CreditCardError(
            'This card already exists.',
            creditCardBox.values.toList(),
          ),
        );
      } else {
        creditCardBox.add(event.creditCard);
        emit(CreditCardLoaded(creditCardBox.values.toList()));
      }
    });

    on<UpdateCreditCard>((event, emit) {
      creditCardBox.putAt(event.index, event.updatedCreditCard);
      add(LoadCreditCards());
    });

    on<DeleteCreditCard>((event, emit) {
      creditCardBox.deleteAt(event.index);
      add(LoadCreditCards());
    });
  }
}

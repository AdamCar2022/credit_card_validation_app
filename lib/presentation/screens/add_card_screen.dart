import 'package:card_scanner/card_scanner.dart';
import 'package:country_picker/country_picker.dart';
import 'package:credit_card_validation_app/core/utils/banned_countries.dart';
import 'package:credit_card_validation_app/core/utils/validators.dart';
import 'package:credit_card_validation_app/data/models/credit_card.dart';
import 'package:credit_card_validation_app/logic/card/card_bloc.dart';
import 'package:credit_card_validation_app/logic/card/card_cubit.dart';
import 'package:credit_card_validation_app/logic/card/card_state.dart';
import 'package:credit_card_validation_app/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddCardScreen extends StatelessWidget {
  const AddCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final creditCardBloc = BlocProvider.of<CreditCardBloc>(context);

    return Scaffold(
      backgroundColor: Colors.teal,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.teal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<String>(
                  color: Colors.teal.shade700,
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onSelected: (value) async {
                    try {
                      if (value == 'bannedCountries') {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushNamed('/banned_countries');
                      } else if (value == 'home') {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => const CardHomeScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    } catch (e, stack) {
                      debugPrint('Popup menu navigation failed: $e\n$stack');
                    }
                  },
                  itemBuilder:
                      (context) => <PopupMenuEntry<String>>[
                        PopupMenuItem(
                          value: 'bannedCountries',
                          child: Row(
                            children: const [
                              Icon(Icons.warning, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Banned Countries',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'home',
                          child: Row(
                            children: const [
                              Icon(Icons.home, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                'Home',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),

                const Text(
                  'My Cards',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => showAddCardDialog(context, creditCardBloc),
                  icon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.credit_card, color: Colors.white),
                      SizedBox(width: 4),
                      Icon(Icons.add, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocConsumer<CreditCardBloc, CreditCardState>(
              listener: (context, state) {
                if (state is CreditCardError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
                }
              },
              builder: (context, state) {
                List<CreditCard> creditCards = [];
                if (state is CreditCardLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CreditCardLoaded) {
                  creditCards = state.creditCards;
                } else if (state is CreditCardError) {
                  creditCards = state.creditCards;
                }

                if (creditCards.isEmpty) {
                  return const Center(child: Text('No cards available'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: creditCards.length,
                  itemBuilder: (context, index) {
                    final card = creditCards[index];

                    return GestureDetector(
                      onTap:
                          () => showCardDetailsDialog(
                            context,
                            creditCardBloc,
                            card,
                            index,
                          ),
                      child: Card(
                        color: Colors.greenAccent,
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'assets/images/credit-card-chip.png',
                                    width: 100,
                                    height: 60,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    card.cardType,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '•••• •••• •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    card.cardHolder,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                  Column(
                                    children: [
                                      const Text('Valid'),
                                      Text(card.validDate),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void showCardDetailsDialog(
    BuildContext context,
    CreditCardBloc bloc,
    CreditCard card,
    int index,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'Card Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.credit_card),
                      SizedBox(width: 8),
                      Text("Card Number: ${card.cardNumber}"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Text("Holder: ${card.cardHolder}"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.date_range),
                      SizedBox(width: 8),
                      Text("Expiry: ${card.validDate}"),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.flag),
                      SizedBox(width: 8),
                      Text("Country: ${card.issuingCountry ?? "Unknown"}"),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder:
                        (confirmContext) => AlertDialog(
                          title: const Text('Confirm Delete'),
                          content: const Text(
                            'Are you sure you want to delete this card?',
                          ),
                          actions: [
                            TextButton(
                              onPressed:
                                  () => Navigator.of(confirmContext).pop(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                bloc.add(DeleteCreditCard(index));
                                Navigator.of(confirmContext).pop();
                                Navigator.of(context).pop();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                  );
                },
                icon: const Icon(Icons.delete),
                label: const Text('Delete'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
    );
  }

  void showAddCardDialog(BuildContext context, CreditCardBloc creditCardBloc) {
    final cardNumberController = TextEditingController();
    final cvvController = TextEditingController();
    final cardHolderController = TextEditingController();
    final cardExpiryMonthController = TextEditingController();
    final cardExpiryYearController = TextEditingController();
    String? selectedCountry;
    String detectedCardType = 'Unknown';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => StatefulBuilder(
            builder: (context, setState) {
              bool isCardValid() =>
                  CreditCardUtils.isValidLuhn(cardNumberController.text);
              bool isCvvValid() => CreditCardUtils.isValidCvv(
                cvvController.text,
                detectedCardType,
              );
              bool isHolderValid() =>
                  CreditCardUtils.isValidCardHolder(cardHolderController.text);
              bool isMonthValid() => CreditCardUtils.isValidExpiryMonth(
                cardExpiryMonthController.text,
              );
              bool isYearValid() => CreditCardUtils.isValidExpiryYear(
                cardExpiryMonthController.text,
                cardExpiryYearController.text,
              );

              void updateValidation() {
                setState(() {
                  detectedCardType = CreditCardUtils.detectCardType(
                    cardNumberController.text,
                  );
                });
              }

              InputDecoration inputDecoration(String hint, bool valid) =>
                  InputDecoration(
                    hintText: hint,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(
                      valid ? Icons.check_circle : Icons.error,
                      color: valid ? Colors.green : Colors.red,
                    ),
                  );

              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: const Center(
                  child: Text(
                    'Add Credit Card',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: const Icon(Icons.camera_alt_sharp),
                          label: const Text(
                            'Scan Card',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () async {
                            try {
                              final scannedDetails = await CardScanner.scanCard(
                                scanOptions: const CardScanOptions(
                                  scanCardHolderName: true,
                                  scanExpiryDate: true,
                                ),
                              );
                              if (scannedDetails != null) {
                                cardNumberController.text =
                                    scannedDetails.cardNumber;
                                cardHolderController.text =
                                    scannedDetails.cardHolderName;

                                final expiry =
                                    scannedDetails.expiryDate.toString();
                                final cleaned = expiry.replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                );
                                if (cleaned.length >= 4) {
                                  cardExpiryMonthController.text = cleaned
                                      .substring(0, 2);
                                  cardExpiryYearController.text = cleaned
                                      .substring(2, 4);
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Captured Card: ••••${scannedDetails.cardNumber.substring(scannedDetails.cardNumber.length - 4)}, Holder: ${scannedDetails.cardHolderName}',
                                    ),
                                  ),
                                );
                                updateValidation();
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to capture card: $e'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: cardNumberController,
                        decoration: inputDecoration(
                          "Card Number",
                          isCardValid(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(16),
                        ],
                        onChanged: (_) => updateValidation(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: cvvController,
                        decoration: inputDecoration("CVV", isCvvValid()),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(
                            detectedCardType == 'American Express' ? 4 : 3,
                          ),
                        ],
                        onChanged: (_) => updateValidation(),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: cardHolderController,
                        decoration: inputDecoration(
                          "Cardholder",
                          isHolderValid(),
                        ),
                        keyboardType: TextInputType.name,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[a-zA-Z\s]'),
                          ),
                        ],
                        onChanged: (_) => updateValidation(),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cardExpiryMonthController,
                              decoration: inputDecoration("MM", isMonthValid()),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (_) => updateValidation(),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Text('/', style: TextStyle(fontSize: 18)),
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: cardExpiryYearController,
                              decoration: inputDecoration("YY", isYearValid()),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onChanged: (_) => updateValidation(),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: false,
                              onSelect: (country) {
                                if (BannedCountriesService.isCountryBanned(
                                  country.name,
                                )) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${country.name} is not allowed',
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                setState(() {
                                  selectedCountry = country.name;
                                });
                              },
                            );
                          },
                          child: Text(
                            selectedCountry ?? 'Select Country',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (!isCardValid() ||
                          !isCvvValid() ||
                          !isHolderValid() ||
                          !isMonthValid() ||
                          !isYearValid()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Please enter valid credit card details',
                            ),
                          ),
                        );
                        return;
                      }

                      if (selectedCountry == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a country'),
                          ),
                        );
                        return;
                      }

                      creditCardBloc.add(
                        AddCreditCard(
                          CreditCard(
                            cardNumber: cardNumberController.text,
                            cardType: detectedCardType,
                            cvv: cvvController.text,
                            issuingCountry: selectedCountry!,
                            cardHolder: cardHolderController.text.toUpperCase(),
                            validDate:
                                '${cardExpiryMonthController.text}/${cardExpiryYearController.text}',
                          ),
                        ),
                      );

                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Add Card',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              );
            },
          ),
    );
  }
}

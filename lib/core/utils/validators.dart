class CreditCardUtils {
  static String digitsOnly(String cInput) =>
      cInput.replaceAll(RegExp(r'[^0-9]'), '');

  static bool isValidLuhn(String input) {
    if (input.isEmpty) return false;
    int sum = 0;
    bool alternate = false;

    for (int i = input.length - 1; i >= 0; i--) {
      int n = int.tryParse(input[i]) ?? 0;
      if (alternate) {
        n *= 2;
        if (n > 9) n -= 9;
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }

  static String detectCardType(String input) {
    if (input.startsWith(RegExp(r'4'))) return 'Visa';
    if (input.startsWith(RegExp(r'5[1-5]'))) return 'MasterCard';
    if (input.startsWith(RegExp(r'3[47]'))) return 'American\nExpress';
    if (input.startsWith(RegExp(r'6'))) return 'Discover';
    return 'Unknown';
  }

  static bool isValidCvv(String cvv, String cardType) {
    if (cardType == 'American Express') {
      return cvv.length == 4;
    }
    return cvv.length == 3;
  }

  static bool isValidExpiryMonth(String? value) {
    if (value == null || value.isEmpty) return false;
    final month = int.tryParse(value);
    if (month == null) return false;
    return month >= 1 && month <= 12;
  }

  static bool isValidExpiryYear(String? month, String? year) {
    if (year == null || year.isEmpty) return false;
    final yy = int.tryParse(year);
    final mm = int.tryParse(month ?? "");
    if (yy == null || mm == null) return false;

    final now = DateTime.now();
    final fourDigitYear = 2000 + yy;

    final expiryDate = DateTime(fourDigitYear, mm + 1, 0);
    final currentDate = DateTime(now.year, now.month);

    return expiryDate.isAfter(currentDate) ||
        expiryDate.isAtSameMomentAs(currentDate);
  }

  static bool isValidCardHolder(String? name) {
    if (name == null || name.trim().isEmpty) return false;
    final regex = RegExp(r"^[A-Za-z\s]+$");
    return regex.hasMatch(name.trim()) && name.trim().length > 1;
  }
}

import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

import '../models/coin_model.dart';

String currencyConverter(double num, {bool isCurrency = true, bool isSell = false}) {
  if (num == 0) return '\$$num';

  double localNum = num;

  if (localNum < 1000 && !isCurrency) {
    return localNum.toString();
  }

  if (localNum.toString().contains('-')) {
    final List<String> numList = localNum.toString().split('');
    numList.removeAt(0);
    localNum = double.parse(numList.join());
  }

  late int allowedDecimalDigits;

  final String numAfterDecimalPoint = (Decimal.parse(localNum.toString())).toString().split('.').last;

  for (int i = 0; i < numAfterDecimalPoint.length; i++) {
    final int digit = int.parse(numAfterDecimalPoint[i]);

    if (i == 0 && digit > 0) {
      if (localNum >= 1) {
        allowedDecimalDigits = 2;
      } else if (localNum >= 0.1) {
        allowedDecimalDigits = 3;
      }

      break;
    } else if (digit > 0) {
      if (localNum <= 0.1) {
        allowedDecimalDigits = i + 3;
      } else {
        allowedDecimalDigits = i + 1;
      }

      break;
    }
  }

  String commaNum = NumberFormat.currency(
    symbol: isCurrency ? '\$' : '',
    decimalDigits: allowedDecimalDigits,
    locale: 'en_US',
  ).format(localNum);

  String formattedAfterDecimal = commaNum.split('.').last;

  if (int.parse(formattedAfterDecimal) == 0) {
    return commaNum.split('.').first;
  } else {
    return commaNum;
  }
}

double calTotalCost(CoinModel coin) {
  double totalCost = 0;

  for (Transaction transaction in coin.transactions!) {
    final double singleTransactionCost = transaction.buyPrice * transaction.amount;

    totalCost += singleTransactionCost;
  }

  return totalCost;
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}

extension DoubleCasingExtension on String {
  String removeTrailingZerosAndNumberfy() {
    return replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}

String convertPerToNum(String percentage) {
  final doubleStr = double.parse(percentage).toStringAsFixed(2);
  return doubleStr;
}

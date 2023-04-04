import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:number_display/number_display.dart';

import '../model/coin_model.dart';

Color bgColor = const Color(0xff142E48);
Color lightBlue = const Color(0xff1976D2);

const Color lightYellow = Colors.yellow;

double defaultPadding = 16;

String currencyConverter(double num, {bool isCurrency = true, bool isSell = false}) {
  if (num == 0) return '\$num';

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
      if (localNum > 1) {
        allowedDecimalDigits = 2;
      } else if (localNum > 0.1) {
        allowedDecimalDigits = 3;
      }

      break;
    } else if (digit > 0) {
      if (localNum < 0.1) {
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

void navigateToPage(BuildContext context, Widget getPage) {
  Navigator.pushReplacement(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation1, animation2) => getPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        Offset begin = const Offset(0, 0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );
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
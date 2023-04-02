import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

import '../model/coin_model.dart';

Color bgColor = const Color(0xff142E48);
Color lightBlue = const Color(0xff1976D2);

const Color lightYellow = Colors.yellow;

double defaultPadding = 16;

String currencyConverter(double num, {bool isCurrency = true}) {
  // late String formattedString;
  // late int decimalDigits;

  // if (num > 10) {
  //   if (num <= 100) {
  //     decimalDigits = num.toString().split('.').last.length;
  //   }

  //   String lastDigit = num.toString().split('.').last;

  //   if (lastDigit.startsWith("0")) {
  //     decimalDigits = 0;
  //   } else {
  //     decimalDigits = 2;
  //   }
  // } else {
  //   if (num == 0 || double.tryParse(num.toString()) == null) return '\$$num';

  //   String afterDecimal = (Decimal.parse(num.toString())).toString().split('.').last;

  //   late int indexNonZero;

  //   for (int i = 0; i < afterDecimal.length; i++) {
  //     int digit = int.parse(afterDecimal[i]);

  //     if (digit > 0) {
  //       indexNonZero = i;

  //       break;
  //     }
  //   }
  //   decimalDigits = indexNonZero + 2;

  //   if (afterDecimal.endsWith('.00')) {
  //     decimalDigits = 0;
  //   }
  // }

  // formattedString = NumberFormat.currency(
  //   symbol: isCurrency ? '\$' : '',
  //   decimalDigits: decimalDigits,
  //   locale: 'en_US',
  // ).format(num);

  // return formattedString;
  if (!isCurrency) {
    return convertToQuantity(num);
  } else {
    if (num < 0.01) {
      if (num == 0 || double.tryParse(num.toString()) == null) return '\$$num';
      late String formattedString;
      late int decimalDigits;

      String afterDecimal = (Decimal.parse(num.toString())).toString().split('.').last;

      late int indexNonZero;

      for (int i = 0; i < afterDecimal.length; i++) {
        int digit = int.parse(afterDecimal[i]);

        if (digit > 0) {
          indexNonZero = i;

          break;
        }
      }
      decimalDigits = indexNonZero + 2;

      if (afterDecimal.endsWith('.00')) {
        decimalDigits = 0;
      }

      formattedString = NumberFormat.currency(
        symbol: isCurrency ? '\$' : '',
        decimalDigits: decimalDigits,
        locale: 'en_US',
      ).format(num);

      return formattedString;
    }
    return NumberFormat.simpleCurrency().format(num);
  }
}

String convertToQuantity(double num) {
  final String stringNum = num.toString();

  final String formattedString = Decimal.parse(stringNum).toString();

  return formattedString;
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

double calTotalTransactions(CoinModel coin) {
  var transactions = coin.transactions as List<Transaction>;

  double totalCost = 0;

  for (var transaction in transactions) {
    final double totalValue = transaction.buyPrice * transaction.amount;
    totalCost += totalValue;
  }

  return totalCost;
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}

extension DoubleCasingExtension on String {
  String removeTrailingZeros() {
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return formatter.format(double.parse(this));
  }

  String removeTrailingZerosAndNumberfy() {
    return replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
  }
}

//reduces Percentage number to 2 digits after decimal point
String convertPerToNum(String percentage) {
  final doubleStr = double.parse(percentage).toStringAsFixed(2);
  return doubleStr;
}

//Convert BTC amount to Doller value
double convertBtcToDoller(double btcAmount) {
  const double oneBtcValue = 29850.15;

  return btcAmount * oneBtcValue;
}

//convert Doller to BTC Value
double convertDollerToBTC(double dollerAmount) {
  const oneBtcValue = 29850.15;
  return dollerAmount / oneBtcValue;
}

String removeTrailingZeros(String n) {
  return n.replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "");
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/coin_model.dart';

Color bgColor = const Color(0xff142E48);
Color lightBlue = const Color(0xff1976D2);

const Color lightYellow = Colors.yellow;

double defaultPadding = 16;

String currencyConverter(double num, {bool isCurrency = true}) {
  String formattedString;
  int decimalDigits;

  if (num < 1.1) {
    decimalDigits = num.toString().split('.').last.length;
  } else {
    String lastDigit = num.toString().split('.').last;

    if (lastDigit.startsWith("0")) {
      decimalDigits = 0;
    } else {
      decimalDigits = 2;
    }
  }

  formattedString = NumberFormat.currency(
    symbol: isCurrency ? '\$' : '',
    decimalDigits: decimalDigits,
    locale: 'en_US',
  ).format(num);

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

void calTotalTransactions(CoinModel cm, bool isBought, double coinAmount, double totalValue) {
  if (!isBought) return;

  var transactions = cm.transactions as List<Transaction>;

  for (var transaction in transactions) {
    coinAmount += transaction.amount;
    totalValue += transaction.buyPrice * transaction.amount;
  }
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

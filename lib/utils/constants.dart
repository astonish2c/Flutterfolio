import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/coin_model.dart';

Color bgColor = const Color(0xff142E48);
Color lightBlue = const Color(0xff1976D2);

const Color lightYellow = Colors.yellow;

double defaultPadding = 16;

String numToCurrency({required double num, bool isCuurency = true}) {
  if (num == 0.0) return isCuurency ? '\$0' : '0';

  final l = log(num) / log(10);

  if (l < 1) {
    // change this logic to l < -5 or some other number as per requirement
    String rounded = num.toStringAsFixed(-l.floor());

    return isCuurency ? '\$$rounded' : rounded;
  } else {
    if (isCuurency) {
      String s = NumberFormat.simpleCurrency().format(num);

      s = s.replaceAll('.00', '');

      return s;
    }

    String s = NumberFormat.currency(symbol: '').format(num);

    s = s.replaceAll('.00', '');

    return s;
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

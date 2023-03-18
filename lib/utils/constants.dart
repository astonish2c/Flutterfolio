import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

import '../model/coin_model.dart';

//BG color and FG color
Color darkBlue = const Color(0xff142E48);
Color lightBlue = const Color(0xff1976D2);

//Button Color
const Color settingsIcon = Colors.yellow;

//Padding for overall app
double defaultPadding = 16;

//Covert String to Num (removing and adding things)
String convertStrToNum(double num) {
  final String readyOutput = NumberFormat.decimalPattern().format(num); //now has comma in between
  if (readyOutput == '0') {
    if (num > 0) {
      return num.toString();
    }
  }
  return readyOutput;
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

//Calculates Transaction expenditure of a coin
void calExpenditure(CoinModel cm, bool isBought, double coinAmount, double totalValue) {
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
    return replaceAll(RegExp(r"([.]*0+)(?!.*\d)"), "" //remove all trailing 0's and extra decimals at end if any
        );
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

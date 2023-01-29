import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

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

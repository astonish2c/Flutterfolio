import 'package:crypto_exchange_app/model/coin_model.dart';
import 'package:flutter/material.dart';
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
  final String trimedString = num.toStringAsFixed(2); //2 digits after decimal
  final double trimedDouble = double.parse(trimedString); //converted to double

  final NumberFormat numberFormat = NumberFormat.decimalPattern(); //will be used to include comma

  final String readyOutput = numberFormat.format(trimedDouble); //now has comma in between

  return readyOutput;
}

//Convert BTC amount to Doller value
double convertBtcToDoller(double btcAmount) {
  final double oneBtcValue = 29850.15;

  return btcAmount * oneBtcValue;
}

//convert Doller to BTC Value
double convertDollerToBTC(double dollerAmount) {
  final oneBtcValue = 29850.15;
  return dollerAmount / oneBtcValue;
}

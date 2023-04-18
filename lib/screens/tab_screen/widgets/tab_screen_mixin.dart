import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/allCoins_provider.dart';
import '../../../provider/userCoins_provider.dart';
import '../../../models/coin_model.dart';

mixin TabScreenMixin<T extends StatefulWidget> on State<T> {
  Future<void> selectDateAndTime({
    required BuildContext context,
    required bool isDateSet,
    required DateTime selectedDate,
    required Function setDate,
  }) async {
    final DateTime? inputDate = await showDatePicker(
      context: context,
      initialDate: isDateSet ? selectedDate : DateTime.now(),
      firstDate: DateTime(2011),
      lastDate: DateTime.now(),
    );
    if (inputDate != null) {
      if (context.mounted) {
        final TimeOfDay? inputTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (inputTime != null) {
          setDate(inputDate: inputDate, inputTime: inputTime);
        }
      }
    }
  }
}

double findCurrentPrice({required BuildContext context, required CoinModel coin}) {
  final List<CoinModel> coins = context.read<AllCoinsProvider>().getCoins;

  final coinSymbol = coin.symbol;

  late CoinModel foundCoin;

  for (int i = 0; i < coins.length; i++) {
    foundCoin = coins.firstWhere((element) => element.symbol == coinSymbol);
  }

  return foundCoin.currentPrice;
}

String removeDoller(String dollerDouble, {bool removeComma = false}) {
  String input = dollerDouble;

  if (input.isEmpty) return '';

  if (input.contains(',') && removeComma) {
    input = input.replaceAll(',', '');
  }

  if (input[0].contains('\$')) {
    final inputListChar = input.split('');
    inputListChar.removeAt(0);

    final fixed = inputListChar.join().toString();

    input = fixed;

    return input;
  } else {
    return dollerDouble;
  }
}

bool checkUserInput(String value) {
  if (value.isEmpty) {
    return true;
  }
  if (value.contains(RegExp(','))) {
    return true;
  }
  if (double.tryParse(value) == null) {
    return true;
  }
  if (double.parse(value) <= 0) {
    return true;
  }

  return false;
}

Future<void> submit({
  required BuildContext context,
  required double price,
  required CoinModel coin,
  required TextEditingController amountController,
  required DateTime selectedDate,
  required bool? isPushHomePage,
  required bool isSell,
}) async {
  await context.read<UserCoinsProvider>().addTransaction(
        CoinModel(
          currentPrice: price,
          name: coin.name,
          symbol: coin.symbol,
          image: coin.image,
          priceDiff: coin.priceDiff,
          transactions: [
            Transaction(
              buyPrice: price,
              amount: double.parse(amountController.text),
              dateTime: selectedDate,
              isSell: isSell,
            ),
          ],
        ),
      );
  if (context.mounted) {
    Navigator.of(context).pop();
  }
}

Future<void> addOrUpdate({
  required BuildContext context,
  required int? indexTransaction,
  required CoinModel coin,
  required TextEditingController amountController,
  required bool? isPushHomePage,
  required double price,
  required DateTime selectedDate,
  required bool isSell,
}) async {
  if (indexTransaction == null) {
    await submit(
      coin: coin,
      amountController: amountController,
      context: context,
      isPushHomePage: isPushHomePage,
      price: price,
      selectedDate: selectedDate,
      isSell: isSell,
    );
    return;
  }

  await context.read<UserCoinsProvider>().updateTransaction(
      coin,
      indexTransaction,
      Transaction(
        buyPrice: price,
        amount: double.parse(amountController.text),
        dateTime: selectedDate,
        isSell: isSell,
      ));

  if (context.mounted) {
    Navigator.of(context).pop();
  }
}

void showAddLimit(BuildContext context) {
  ScaffoldMessenger.of(context).removeCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      duration: const Duration(seconds: 2),
      content: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.red[700], borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Sorry!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text('Transactions with less than 10\$ can not be added.', style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    ),
  );
}

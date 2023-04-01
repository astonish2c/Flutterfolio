import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../home_screen/home_page.dart';
import '../../transactions_screen/transactions_screen.dart';

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

void submit({
  required BuildContext context,
  required double price,
  required CoinModel coin,
  required TextEditingController amountController,
  required DateTime selectedDate,
  required bool? isPushHomePage,
  required bool isSell,
}) {
  context.read<DataProvider>().addUserCoin(
        CoinModel(
          currentPrice: price,
          name: coin.name,
          symbol: coin.symbol,
          image: coin.image,
          priceDiff: coin.priceDiff,
          color: coin.color,
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

  Navigator.of(context).pop();

  if (isPushHomePage != null) return;

  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HoldingsPage()));
}

void addOrUpdate({
  required BuildContext context,
  required int? indexTransaction,
  required CoinModel coin,
  required TextEditingController amountController,
  required bool? isPushHomePage,
  required double price,
  required DateTime selectedDate,
  required bool isSell,
}) {
  if (indexTransaction == null) {
    submit(
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

  context.read<DataProvider>().updateTransaction(
      coin,
      indexTransaction,
      Transaction(
        buyPrice: price,
        amount: double.parse(amountController.text),
        dateTime: selectedDate,
        isSell: isSell,
      ));

  Navigator.of(context).pop();

  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TransactionsScreen(coin: coin)));
}

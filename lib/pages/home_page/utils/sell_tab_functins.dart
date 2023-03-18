import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../home_page.dart';
import '/utils/constants.dart';
import '../../../model/coin_model.dart';

mixin SellTabFunction<T extends StatefulWidget> on State<T> {
  void setPreValues({
    required TextEditingController amountController,
    required CoinModel coinModel,
    required int initialPage,
    required DateTime selectedDate,
    required bool isDateSet,
    required bool isPriceSet,
    required double priceValue,
    int? indexTransaction,
  }) {
    if (indexTransaction == null) return;

    final Transaction transaction = coinModel.transactions![indexTransaction];

    if (initialPage == 1) {
      amountController.text = transaction.amount.toString().removeTrailingZerosAndNumberfy();
      selectedDate = transaction.dateTime;
      isDateSet = true;
      priceValue = transaction.buyPrice;
      isPriceSet = true;
    } else {
      amountController.text = '0';
      selectedDate = DateTime.now();
      isDateSet = false;
      priceValue = transaction.buyPrice;
      isPriceSet = false;
    }
  }

  bool check(String value) {
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

  Future<void> selectDateAndTime({required DateTime selectedDate, required bool isDateSet}) async {
    final DateTime? inputDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2011),
      lastDate: DateTime.now(),
    );
    if (inputDate != null) {
      final TimeOfDay? inputTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (inputTime != null) {
        setState(() {
          selectedDate = DateTime(inputDate.year, inputDate.month, inputDate.day, inputTime.hour, inputTime.minute);
          isDateSet = true;
        });
      }
    }
  }

  Future<void> setNote({required TextEditingController noteController, required bool isNoteSet}) async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        return SizedBox(
          height: keyboardSize > 0.0 ? keyboardSize + 260 : 270,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 32),
            child: Column(
              children: [
                TextField(
                  controller: noteController,
                  autofocus: true,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    noteController.value = TextEditingValue(
                      text: value,
                      selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
                    );
                  },
                  style: const TextStyle(),
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    label: const Text('Note'),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Add Note here....',
                    hintStyle: const TextStyle(),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[900],
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: () {
                      setState(() {
                        isNoteSet = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Set Note',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> setFee({required TextEditingController feeController, required bool isFeeSet}) async {
    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: keyboardSize + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: feeController,
                autofocus: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  feeController.value = TextEditingValue(
                    text: value,
                    selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
                  );
                },
                style: const TextStyle(),
                decoration: InputDecoration(
                  label: const Text('Fee'),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: '\$0.0',
                  hintStyle: const TextStyle(),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue[900],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    setState(() {
                      isFeeSet = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Update Fee',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> setPricePerCoin({required TextEditingController priceController, required double priceValue, required bool isPriceSet, required CoinModel coinModel}) async {
    isPriceSet ? priceController.text = priceValue.toString().removeTrailingZerosAndNumberfy() : priceController.text = coinModel.currentPrice.toString().removeTrailingZerosAndNumberfy();

    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: keyboardSize + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: priceController,
                autofocus: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  priceController.value = TextEditingValue(
                    text: value,
                    selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
                  );
                },
                style: const TextStyle(),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(16),
                  filled: true,
                  label: const Text('Price Per Coin'),
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: const TextStyle(),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(width: 0, color: Colors.transparent),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue[900],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: () {
                    if (check(priceController.value.text)) return;

                    setState(() {
                      priceValue = double.parse(priceController.value.text);
                      isPriceSet = true;
                    });

                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Update Price',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void submit({required CoinModel coinModel, required double priceValue, required String amounControllerText, required DateTime selectedDate, required bool isSell, bool? pushHomePage}) {
    context.read<DataProvider>().addUserCoin(
          CoinModel(
            currentPrice: priceValue,
            name: coinModel.name,
            symbol: coinModel.symbol,
            image: coinModel.image,
            priceDiff: coinModel.priceDiff,
            color: coinModel.color,
            transactions: [
              Transaction(
                buyPrice: priceValue,
                amount: double.parse(amounControllerText),
                dateTime: selectedDate,
                isSell: isSell,
              ),
            ],
          ),
        );
    Navigator.of(context).pop();
    if (pushHomePage != null) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HoldingsPage()));
  }
}

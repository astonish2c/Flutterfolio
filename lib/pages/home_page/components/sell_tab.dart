// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../home_page.dart';
import '../utils/details_row_item.dart';
import '/pages/home_page/components/transactions_screen.dart';
import '/utils/constants.dart';
import '../../../model/coin_model.dart';

class SellTab extends StatefulWidget {
  const SellTab({
    Key? key,
    required this.coinModel,
    this.indexTransaction,
    this.pushHomePage,
    required this.initialPage,
  }) : super(key: key);

  final CoinModel coinModel;
  final int? indexTransaction;
  final bool? pushHomePage;
  final int initialPage;

  @override
  State<SellTab> createState() => _SellTabState();
}

class _SellTabState extends State<SellTab> {
  late TextEditingController _amountController, _priceController, _feeController, _noteController;
  late FocusNode _focusNode;
  late double _priceValue;

  bool _isPriceSet = false;
  final bool _isFeeSet = false;
  final bool _isNoteSet = false;
  bool _isDateSet = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _focusNode = FocusNode();
    _amountController = TextEditingController();
    _priceValue = widget.coinModel.currentPrice;
    _priceController = TextEditingController(text: widget.coinModel.currentPrice.toString());
    _feeController = TextEditingController();
    _noteController = TextEditingController();
    setPreValues();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _amountController.dispose();
    _priceController.dispose();
    _feeController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        //Amount Section
        Expanded(
          child: Row(
            children: [
              const SizedBox(width: 48),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //coin amount
                        Container(
                          constraints: const BoxConstraints(
                            minHeight: 0,
                            minWidth: 0,
                            maxWidth: 200,
                          ),
                          child: IntrinsicWidth(
                            child: TextField(
                              focusNode: _focusNode,
                              controller: _amountController,
                              onChanged: (value) {
                                setState(() {
                                  _amountController.value = TextEditingValue(
                                    text: value,
                                    selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
                                  );
                                });
                              },
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              showCursor: false,
                              style: const TextStyle(
                                fontSize: 82,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  fontSize: 82,
                                  fontWeight: FontWeight.bold,
                                ),
                                hintText: '0',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //Price per coin
                    Text(
                      '\$${convertStrToNum(_priceValue)}',
                      style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
            ],
          ),
        ),
        //Details Row
        SizedBox(
          height: 40,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              const SizedBox(width: 12),
              //Date
              DetailsRowItem(
                icon: Icon(
                  Icons.date_range,
                  size: 16,
                  color: _isDateSet ? Colors.white : Colors.black54,
                ),
                onTap: () => selectDateAndTime(),
                text: DateFormat('d, MMM, y, h:m a').format(_selectedDate),
                textColor: _isDateSet ? Colors.white : Colors.black54,
                bgColor: _isDateSet ? Colors.blue[900] : Colors.grey[300],
              ),
              const SizedBox(width: 12),
              //Price
              DetailsRowItem(
                icon: Icon(
                  Icons.attach_money_rounded,
                  size: 18,
                  color: _isPriceSet ? Colors.white : Colors.black54,
                ),
                onTap: () => setPricePerCoin(),
                text: 'Price Per Coin',
                textColor: _isPriceSet ? Colors.white : Colors.black54,
                bgColor: _isPriceSet ? Colors.blue[900] : Colors.grey[300],
              ),
              const SizedBox(width: 12),
              //Fee
              DetailsRowItem(
                icon: Icon(
                  Icons.attach_money_rounded,
                  size: 18,
                  color: _isFeeSet ? Colors.white : Colors.black54,
                ),
                onTap: () => setFee(feeController: _feeController, isFeeSet: _isFeeSet),
                text: 'Fee',
                textColor: _isFeeSet ? Colors.white : Colors.black54,
                bgColor: _isFeeSet ? Colors.blue[900] : Colors.grey[300],
              ),
              const SizedBox(width: 12),
              //Note
              DetailsRowItem(
                icon: Icon(
                  Icons.edit,
                  size: 16,
                  color: _isNoteSet ? Colors.white : Colors.black54,
                ),
                onTap: () => setNote(noteController: _noteController, isNoteSet: _isNoteSet),
                text: 'Note',
                textColor: _isNoteSet ? Colors.white : Colors.black54,
                bgColor: _isNoteSet ? Colors.blue[900] : Colors.grey[300],
              ),
              const SizedBox(width: 12),
            ],
          ),
        ),
        const SizedBox(height: 12),
        //Add Btn
        Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 12, right: 12, bottom: keyboardSize + 24),
          child: ValueListenableBuilder(
            valueListenable: _amountController,
            builder: (context, value, child) => TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: checkUserInput(value.text) ? Colors.white : Colors.blue[900],
                minimumSize: Size.zero,
              ),
              onPressed: checkUserInput(value.text)
                  ? null
                  : () {
                      if (widget.indexTransaction == null) return submit();

                      context.read<DataProvider>().updateTransaction(
                            widget.coinModel,
                            widget.indexTransaction!,
                            Transaction(buyPrice: _priceValue, amount: double.parse(_amountController.text), dateTime: _selectedDate, isSell: true),
                          );
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => TransactionsScreen(coinModel: widget.coinModel)));
                    },
              child: Text(
                'Add Transaction',
                style: TextStyle(
                  color: checkUserInput(value.text) ? Colors.black12 : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setPreValues() {
    print("indexTransaction is: ${widget.indexTransaction}");
    if (widget.indexTransaction == null) return;

    final Transaction transaction = widget.coinModel.transactions![widget.indexTransaction!];

    // if (initialPage == 1) {
    _amountController.text = transaction.amount.toString().removeTrailingZerosAndNumberfy();
    _selectedDate = transaction.dateTime;
    _isDateSet = true;
    _priceValue = transaction.buyPrice;
    _isPriceSet = true;
    // } else {

    // amountController.text = '0';
    // selectedDate = DateTime.now();
    // isDateSet = false;
    // priceValue = transaction.buyPrice;
    // isPriceSet = false;

    // }
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

  Future<void> selectDateAndTime() async {
    final DateTime? inputDate = await showDatePicker(
      context: context,
      initialDate: _isDateSet ? _selectedDate : DateTime.now(),
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
          _selectedDate = DateTime(inputDate.year, inputDate.month, inputDate.day, inputTime.hour, inputTime.minute);
          _isDateSet = true;
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

  Future<void> setPricePerCoin() async {
    _isPriceSet ? _priceController.text = _priceValue.toString().removeTrailingZerosAndNumberfy() : _priceController.text = widget.coinModel.currentPrice.toString().removeTrailingZerosAndNumberfy();

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
                controller: _priceController,
                autofocus: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _priceController.value = TextEditingValue(
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
                    if (checkUserInput(_priceController.value.text)) return;

                    setState(() {
                      _priceValue = double.parse(_priceController.value.text);
                      _isPriceSet = true;
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

  void submit() {
    context.read<DataProvider>().addUserCoin(
          CoinModel(
            currentPrice: _priceValue,
            name: widget.coinModel.name,
            symbol: widget.coinModel.symbol,
            image: widget.coinModel.image,
            priceDiff: widget.coinModel.priceDiff,
            color: widget.coinModel.color,
            transactions: [
              Transaction(
                buyPrice: _priceValue,
                amount: double.parse(_amountController.text),
                dateTime: _selectedDate,
                isSell: true,
              ),
            ],
          ),
        );
    Navigator.of(context).pop();
    if (widget.pushHomePage != null) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HoldingsPage()));
  }
}

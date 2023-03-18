// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../utils/details_row_item.dart';
import '../utils/sell_tab_functins.dart';
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

class _SellTabState extends State<SellTab> with SellTabFunction {
  late TextEditingController _amountController, _priceController, _feeController, _noteController;
  late FocusNode _focusNode;
  late double _priceValue;

  final bool _isPriceSet = false;
  final bool _isFeeSet = false;
  final bool _isNoteSet = false;
  final bool _isDateSet = false;

  final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _focusNode = FocusNode();
    _amountController = TextEditingController();
    _priceValue = widget.coinModel.currentPrice;
    _priceController = TextEditingController(text: widget.coinModel.currentPrice.toString());
    _feeController = TextEditingController();
    _noteController = TextEditingController();
    setPreValues(
      amountController: _amountController,
      coinModel: widget.coinModel,
      initialPage: widget.initialPage,
      isDateSet: _isDateSet,
      isPriceSet: _isPriceSet,
      priceValue: _priceValue,
      selectedDate: _selectedDate,
      indexTransaction: widget.indexTransaction,
    );
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
                onTap: () => selectDateAndTime(selectedDate: _selectedDate, isDateSet: _isDateSet),
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
                onTap: () => setPricePerCoin(coinModel: widget.coinModel, isPriceSet: _isPriceSet, priceController: _priceController, priceValue: _priceValue),
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
                backgroundColor: check(value.text) ? Colors.white : Colors.blue[900],
                minimumSize: Size.zero,
              ),
              onPressed: check(value.text)
                  ? null
                  : () {
                      if (widget.indexTransaction == null)
                        return submit(
                          coinModel: widget.coinModel,
                          amounControllerText: _amountController.text,
                          isSell: true,
                          priceValue: _priceValue,
                          selectedDate: _selectedDate,
                          pushHomePage: widget.pushHomePage,
                        );

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
                  color: check(value.text) ? Colors.black12 : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

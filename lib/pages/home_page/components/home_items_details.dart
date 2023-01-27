// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:crypto_exchange_app/pages/holdings_page/components/holdings_item_transactions.dart';
import 'package:crypto_exchange_app/pages/home_page/home_page.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';

import '../../../provider/theme_provider.dart';

class BuyView extends StatefulWidget {
  const BuyView({
    Key? key,
    required this.coinModel,
    this.indexOfBuyCoin,
    this.pushHomePage,
  }) : super(key: key);

  final CoinModel coinModel;
  final int? indexOfBuyCoin;
  final bool? pushHomePage;

  @override
  State<BuyView> createState() => _BuyViewState();
}

class _BuyViewState extends State<BuyView> {
  late TextEditingController _amountController;
  late FocusNode _focusNode;

  late TextEditingController _priceController;
  late double _priceValue;
  bool _isPriceSet = false;

  late TextEditingController _feeController;
  bool _isFeeSet = false;

  late TextEditingController _noteController;
  bool _isNoteSet = false;

  DateTime _selectedDate = DateTime.now();
  bool _isDateSet = false;

  bool _toggleCoinValue = false;

  void setPreValues(TextEditingController amountController) {
    if (widget.indexOfBuyCoin != null) {
      // print('amount here is: ${amountController.text}');
      amountController.text = widget.coinModel.transactions![widget.indexOfBuyCoin!].amount.toString();
      _selectedDate = widget.coinModel.transactions![widget.indexOfBuyCoin!].dateTime;
      _isDateSet = true;
      _priceValue = widget.coinModel.transactions![widget.indexOfBuyCoin!].buyPrice;
      _isPriceSet = true;
    } else {
      return;
    }
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _amountController = TextEditingController();
    _priceValue = widget.coinModel.currentPrice;
    _priceController = TextEditingController(text: widget.coinModel.currentPrice.toString());
    _feeController = TextEditingController();
    _noteController = TextEditingController();
    setPreValues(_amountController);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  void _submit() {
    Provider.of<DataProvider>(context, listen: false).addUserCoin(
      CoinModel(
        currentPrice: _priceValue,
        name: widget.coinModel.name,
        shortName: widget.coinModel.shortName,
        imageUrl: widget.coinModel.imageUrl,
        priceDiff: widget.coinModel.priceDiff,
        color: widget.coinModel.color,
        transactions: [
          Transaction(
            buyPrice: _priceValue,
            amount: double.parse(_amountController.text),
            dateTime: _selectedDate,
          ),
        ],
      ),
    );
    Navigator.of(context).pop();
    if (widget.pushHomePage == null) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }

  //to Check if our input is legit
  bool check(String value) {
    if (value.isEmpty) {
      // print('value is empty');
      return true;
    }
    if (value.contains(RegExp(','))) {
      // print('value contains: ,');
      return true;
    }
    if (double.tryParse(value) == null) {
      // print('value cant be parsed to double its null');
      return true;
    }
    if (double.parse(value) <= 0) {
      // print('value is less than zero');
      return true;
    }
    // print('value is ok ');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
    // print('index of BuyCoin at BuyView Widget: ${widget.indexOfBuyCoin}');
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
                        //Title in Doller
                        if (_toggleCoinValue)
                          Padding(
                            padding: const EdgeInsets.only(top: 24, right: 8),
                            child: Icon(
                              Icons.attach_money_rounded,
                              size: 40,
                              // color: _themeProvider.isDark ? Colors.white54 : Colors.black54,
                            ),
                          ),
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
                                // color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
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
                        //Title in Coin
                        if (_toggleCoinValue == false)
                          Padding(
                            padding: const EdgeInsets.only(top: 24, left: 8),
                            child: Text(
                              widget.coinModel.shortName.toUpperCase(),
                              style: theme.textTheme.titleMedium!.copyWith(fontSize: 20),
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
              //USD or Coin
              InkWell(
                onTap: () {
                  setState(() {
                    _toggleCoinValue = !_toggleCoinValue;
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.swap_vert,
                      size: 30,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _toggleCoinValue ? widget.coinModel.shortName.toUpperCase() : 'USD',
                      style: TextStyle(),
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
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(width: 12),
              //Date
              DetailsRowItem(
                icon: Icon(
                  Icons.date_range,
                  size: 16,
                  color: _isDateSet ? Colors.white : Colors.black54,
                ),
                onTap: () => _selectDateAndTime(),
                text: DateFormat('d, MMM, y, h:m a').format(_selectedDate),
                textColor: _isDateSet ? Colors.white : Colors.black54,
                bgColor: _isDateSet ? Colors.blue[900] : Colors.grey[300],
              ),
              SizedBox(width: 12),
              //Price
              DetailsRowItem(
                icon: Icon(
                  Icons.attach_money_rounded,
                  size: 18,
                  color: _isPriceSet ? Colors.white : Colors.black54,
                ),
                onTap: () => _setPricePerCoin(),
                text: 'Price Per Coin',
                textColor: _isPriceSet ? Colors.white : Colors.black54,
                bgColor: _isPriceSet ? Colors.blue[900] : Colors.grey[300],
              ),
              SizedBox(width: 12),
              //Fee
              DetailsRowItem(
                icon: Icon(
                  Icons.attach_money_rounded,
                  size: 18,
                  color: _isFeeSet ? Colors.white : Colors.black54,
                ),
                onTap: () => _setFee(),
                text: 'Fee',
                textColor: _isFeeSet ? Colors.white : Colors.black54,
                bgColor: _isFeeSet ? Colors.blue[900] : Colors.grey[300],
              ),
              SizedBox(width: 12),
              //Note
              DetailsRowItem(
                icon: Icon(
                  Icons.edit,
                  size: 16,
                  color: _isNoteSet ? Colors.white : Colors.black54,
                ),
                onTap: () => _setNote(),
                text: 'Note',
                textColor: _isNoteSet ? Colors.white : Colors.black54,
                bgColor: _isNoteSet ? Colors.blue[900] : Colors.grey[300],
              ),
              SizedBox(width: 12),
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
                      if (widget.indexOfBuyCoin != null) {
                        Provider.of<DataProvider>(context, listen: false).updateTransaction(
                          widget.coinModel,
                          widget.indexOfBuyCoin!,
                          Transaction(buyPrice: _priceValue, amount: double.parse(_amountController.text), dateTime: _selectedDate),
                        );
                        Provider.of<DataProvider>(context, listen: false).calTotalUserBalance();
                        Navigator.of(context).pop();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HoldingsItemTransactions(coinModel: widget.coinModel)));
                      } else {
                        _submit();
                      }
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

  Future<void> _selectDateAndTime() async {
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
          _selectedDate = DateTime(inputDate.year, inputDate.month, inputDate.day, inputTime.hour, inputTime.minute);
          _isDateSet = true;
        });
      }
    }
  }

  Future<void> _setNote() async {
    return await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        return SizedBox(
          height: keyboardSize > 0.0 ? keyboardSize + 260 : 270,
          child: Padding(
            padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 32),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _noteController,
                  autofocus: true,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  onChanged: (value) {
                    _noteController.value = TextEditingValue(
                      text: value,
                      selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
                    );
                  },
                  style: TextStyle(
                      // color: Colors.black,
                      ),
                  decoration: InputDecoration(
                    filled: true,
                    // fillColor: Colors.black12,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    label: Text('Note'),
                    labelStyle: TextStyle(
                      // color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: 'Add Note here....',
                    hintStyle: TextStyle(
                        // color: Colors.black54,
                        // decorationColor: Colors.black54,
                        ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        // color: Colors.black54,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[900],
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                    ),
                    onPressed: () {
                      setState(() {
                        _isNoteSet = true;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text(
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

  Future<void> _setFee() async {
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
                controller: _feeController,
                autofocus: true,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  _feeController.value = TextEditingValue(
                    text: value,
                    selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
                  );
                },
                style: TextStyle(
                    // color: Colors.black,
                    ),
                decoration: InputDecoration(
                  label: Text('Fee'),
                  labelStyle: TextStyle(
                    // color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  hintText: '\$0.0',
                  hintStyle: TextStyle(
                      // color: Colors.black54,
                      ),
                  filled: true,
                  // fillColor: Colors.black12,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      // color: Colors.black54,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue[900],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () {
                    setState(() {
                      _isFeeSet = true;
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(
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

  Future<void> _setPricePerCoin() async {
    _isPriceSet ? _priceController.text = _priceValue.toString() : _priceController.text = widget.coinModel.currentPrice.toString();
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
                style: TextStyle(
                    // color: Colors.black,
                    ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(16),
                  // fillColor: Colors.black12,
                  filled: true,
                  label: Text('Price Per Coin'),
                  labelStyle: TextStyle(
                    // color: Colors.black54,
                    fontWeight: FontWeight.bold,
                  ),
                  hintStyle: TextStyle(
                      // color: Colors.black,
                      ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      // color: Colors.black54,
                      width: 2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(width: 0, color: Colors.transparent),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue[900],
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                  ),
                  onPressed: () {
                    if (check(_priceController.value.text)) {
                      return;
                    } else {
                      setState(() {
                        _priceValue = double.parse(_priceController.value.text);
                        _isPriceSet = true;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(
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
}

class DetailsRowItem extends StatelessWidget {
  final VoidCallback onTap;
  final Icon icon;
  final String text;
  final Color? textColor;
  final Color? bgColor;

  const DetailsRowItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.textColor,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: bgColor ?? Colors.grey[300],
        ),
        child: Row(
          children: [
            icon,
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

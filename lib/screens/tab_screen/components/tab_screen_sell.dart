import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

import '/screens/tab_screen/widgets/tab_screen_mixin.dart';
import '../widgets/tab_buy_amount.dart';
import '../widgets/tab_buy_price.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../../models/coin_model.dart';
import '../widgets/tab_transaction_details.dart';

class SellTab extends StatefulWidget {
  const SellTab({
    Key? key,
    required this.coin,
    this.indexTransaction,
    this.isPushHomePage,
    required this.initialPage,
  }) : super(key: key);

  final CoinModel coin;
  final int? indexTransaction;
  final bool? isPushHomePage;
  final int initialPage;

  @override
  State<SellTab> createState() => _SellTabState();
}

class _SellTabState extends State<SellTab> with TabScreenMixin {
  late TextEditingController _amountController, _priceController;
  late FocusNode _focusNode;
  late double _price;

  bool _isLoadingAdd = false;
  bool _isPriceSet = false;
  bool _isDateSet = false;
  bool _isUpdateTransaction = false;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _amountController = TextEditingController();
    _price = findCurrentPrice(coin: widget.coin, context: context);
    _priceController = TextEditingController(text: widget.coin.currentPrice.toString());
    setPreValues();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;

    return Column(children: [
      TabBuyAmount(
        coinModel: widget.coin,
        amountController: _amountController,
        focusNode: _focusNode,
        price: _price,
      ),
      TabTransactionDetails(
        isDateSet: _isDateSet,
        isPriceSet: _isPriceSet,
        selectedDate: _selectedDate,
        setPricePerCoin: setPricePerCoin,
        setDateTime: setDate,
      ),
      const SizedBox(height: 12),
      Container(
        width: double.infinity,
        margin: EdgeInsets.only(left: 12, right: 12, bottom: keyboardSize + 24),
        child: ValueListenableBuilder(
          valueListenable: _amountController,
          builder: (context, value, child) => TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: checkUserInput(value.text) ? Colors.white : Colors.blue[900],
            ),
            onPressed: checkUserInput(value.text) || _isLoadingAdd
                ? null
                : () async {
                    setState(() {
                      _isLoadingAdd = true;
                    });
                    if (double.parse(_amountController.text) * _price < 10.0) {
                      showAddLimit(context);
                      setState(() {
                        _isLoadingAdd = false;
                      });
                      return;
                    }

                    await addOrUpdate(
                      context: context,
                      coin: widget.coin,
                      amountController: _amountController,
                      indexTransaction: widget.indexTransaction,
                      isPushHomePage: widget.isPushHomePage,
                      isSell: true,
                      price: _price,
                      selectedDate: _selectedDate,
                    );
                    setState(() {
                      _isLoadingAdd = false;
                    });
                  },
            child: _isLoadingAdd
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: Colors.white),
                  )
                : Text(
                    _isUpdateTransaction ? 'Update Transaction' : 'Add Transaction',
                    style: TextStyle(color: checkUserInput(value.text) ? Colors.black12 : Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    ]);
  }

  void setDate({required DateTime inputDate, required TimeOfDay inputTime}) {
    setState(() {
      _selectedDate = DateTime(inputDate.year, inputDate.month, inputDate.day, inputTime.hour, inputTime.minute);
      _isDateSet = true;
    });
  }

  void setPreValues() {
    _amountController = TextEditingController();

    if (widget.indexTransaction == null) return;

    final Transaction transaction = widget.coin.transactions![widget.indexTransaction!];

    _amountController.text = transaction.amount.toString().removeTrailingZerosAndNumberfy();
    _selectedDate = transaction.dateTime;
    _price = transaction.buyPrice;

    _isDateSet = true;
    _isPriceSet = true;
    _isUpdateTransaction = true;
  }

  Future<void> setPricePerCoin() async {
    void updatePrice() {
      if (checkUserInput(removeDoller(_priceController.value.text, removeComma: true))) return print('Wrong input.');

      setState(() {
        _price = Decimal.parse(removeDoller(_priceController.value.text, removeComma: true)).toDouble();
        _isPriceSet = true;
      });

      Navigator.of(context).pop();
    }

    _isPriceSet ? _priceController.text = currencyConverter(_price) : _priceController.text = removeDoller(currencyConverter(widget.coin.currentPrice), removeComma: true);

    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        return TabBuyPrice(priceController: _priceController, keyboardSize: keyboardSize, updatePrice: updatePrice);
      },
    );
  }
}

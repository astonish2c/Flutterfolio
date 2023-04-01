import 'package:flutter/material.dart';

import '/screens/tab_screen/widgets/tab_screen_mixin.dart';
import '../widgets/tab_buy_amount.dart';
import '../widgets/tab_buy_price.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../../model/coin_model.dart';
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
  late double _priceValue;

  bool _isPriceSet = false;
  bool _isDateSet = false;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _focusNode = FocusNode();
    _amountController = TextEditingController();
    _priceValue = widget.coin.currentPrice;
    _priceController = TextEditingController(text: widget.coin.currentPrice.toString());
    setPreValues();
    super.initState();
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
        price: _priceValue,
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
              backgroundColor: checkUserInput(value.text) ? Colors.white : Colors.blue[900],
              minimumSize: Size.zero,
            ),
            onPressed: checkUserInput(value.text)
                ? null
                : () => addOrUpdate(
                      coin: widget.coin,
                      amountController: _amountController,
                      context: context,
                      indexTransaction: widget.indexTransaction,
                      isPushHomePage: widget.isPushHomePage,
                      isSell: true,
                      price: _priceValue,
                      selectedDate: _selectedDate,
                    ),
            child: Text(
              'Add Transaction',
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
    if (widget.indexTransaction == null) return;

    final Transaction transaction = widget.coin.transactions![widget.indexTransaction!];

    _amountController.text = transaction.amount.toString().removeTrailingZerosAndNumberfy();
    _selectedDate = transaction.dateTime;
    _isDateSet = true;
    _priceValue = transaction.buyPrice;
    _isPriceSet = true;
  }

  Future<void> setPricePerCoin() async {
    void updatePrice() {
      if (checkUserInput(_priceController.value.text)) return;

      setState(() {
        _priceValue = double.parse(_priceController.value.text);
        _isPriceSet = true;
      });

      Navigator.of(context).pop();
    }

    _isPriceSet ? _priceController.text = _priceValue.toString().removeTrailingZerosAndNumberfy() : _priceController.text = widget.coin.currentPrice.toString().removeTrailingZerosAndNumberfy();

    return await showModalBottomSheet(
      context: context,
      builder: (context) {
        final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;
        return TabBuyPrice(priceController: _priceController, keyboardSize: keyboardSize, updatePrice: updatePrice);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../exchange_page/components/exchange_big_btn.dart';

class HomeBottomSheet extends StatefulWidget {
  const HomeBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeBottomSheet> createState() => _HomeBottomSheetState();
}

class _HomeBottomSheetState extends State<HomeBottomSheet> {
  late TextEditingController _amountController;
  late TextEditingController _priceController;

  int _currentIndex = 0;
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    _amountController = TextEditingController();
    _priceController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    final String amountText = _amountController.text;
    final String priceText = _priceController.text;
    final List<CoinModel> allCoins = Provider.of<DataProvider>(context, listen: false).allCoins;

    if (amountText.isEmpty || priceText.isEmpty) {
      return;
    } else {
      CoinModel coinModel = allCoins[_currentIndex];
      final double buyPrice = double.parse(priceText);
      final double amount = double.parse(amountText);

      Provider.of<DataProvider>(context, listen: false).addUserCoin(
        CoinModel(
          currentPrice: coinModel.currentPrice,
          name: coinModel.name,
          shortName: coinModel.shortName,
          imageUrl: coinModel.imageUrl,
          priceDiff: coinModel.priceDiff,
          color: coinModel.color,
          buyCoin: [
            BuyCoin(buyPrice: buyPrice, amount: amount, dateTime: _dateTime),
          ],
        ),
      );
      Provider.of<DataProvider>(context, listen: false).calTotalUserBalance();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final List<CoinModel> allCoins = dataProvider.allCoins;
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 32,
        bottom: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          //Coin & Amount
          Theme(
            data: ThemeData(
              hintColor: Colors.grey,
            ),
            child: TextField(
              controller: _amountController,
              onChanged: (value) {
                setState(() {
                  _amountController.text = value;
                  _amountController.selection = TextSelection.fromPosition(TextPosition(offset: _amountController.text.length));
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount',
                border: const OutlineInputBorder(
                  gapPadding: 0,
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
                prefixIcon: Container(
                  constraints: const BoxConstraints(
                    minWidth: 100,
                    maxWidth: 150,
                  ),
                  padding: const EdgeInsets.all(4),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  //PopUpMenuButton
                  child: PopupMenuButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onSelected: (value) {
                      setState(() {
                        _currentIndex = value;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: Image.asset(allCoins[_currentIndex].imageUrl),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          allCoins[_currentIndex].name,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black,
                        ),
                      ],
                    ),
                    itemBuilder: (context) {
                      return [
                        ...allCoins.map((e) {
                          return PopupMenuItem(
                            value: allCoins.indexOf(e),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(e.imageUrl),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  e.name,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ];
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          //price
          Theme(
            data: ThemeData(
              hintColor: Colors.grey,
            ),
            child: TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  _priceController.text = value;
                  _priceController.selection = TextSelection.collapsed(offset: _priceController.text.length);
                });
              },
              decoration: const InputDecoration(
                hintText: 'Price',
                border: OutlineInputBorder(
                  gapPadding: 0,
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          //Select date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                onPressed: () async {
                  //The function that we will call later
                  Future<DateTime> selectDateAndTime() async {
                    DateTime selectedDateTime = DateTime.now();

                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );

                    if (pickedDate != null) {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );

                      if (pickedTime != null) {
                        final DateTime pickedDateTime = DateTime(
                          pickedDate.year,
                          pickedDate.month,
                          pickedDate.day,
                          pickedTime.hour,
                          pickedTime.minute,
                        );

                        selectedDateTime = pickedDateTime;
                      }
                    }
                    return selectedDateTime;
                  }

                  DateTime selectedDateAndTime;

                  selectedDateAndTime = await selectDateAndTime();

                  setState(() {
                    _dateTime = selectedDateAndTime;
                  });
                },
                child: const Text(
                  'Select Date',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                DateFormat('d-MMM-y H:m a').format(_dateTime),
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          //Add to Portfolio
          ExchnageBigBtn(
            text: 'Add to Portfolio',
            bgColor: Colors.blue,
            textColor: Colors.white,
            onTap: () => _submit(),
          ),
        ],
      ),
    );
  }
}

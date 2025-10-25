import 'package:flutter/material.dart';

import '../../../models/coin_model.dart';
import '../../../custom_widgets/helper_methods.dart';

class TabBuyAmount extends StatefulWidget {
  const TabBuyAmount({super.key, required this.coinModel, required this.amountController, required this.focusNode, required this.price});

  final CoinModel coinModel;
  final TextEditingController amountController;
  final FocusNode focusNode;
  final double price;

  @override
  State<TabBuyAmount> createState() => _TabBuyAmountState();
}

class _TabBuyAmountState extends State<TabBuyAmount> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Expanded(
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
                    Container(
                      constraints: const BoxConstraints(
                        minHeight: 0,
                        minWidth: 0,
                        maxWidth: 300,
                      ),
                      child: IntrinsicWidth(
                        child: TextField(
                          focusNode: widget.focusNode,
                          controller: widget.amountController,
                          onChanged: (value) {
                            setState(() {
                              widget.amountController.value = TextEditingValue(
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
                Text(
                  currencyConverter(widget.price),
                  style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

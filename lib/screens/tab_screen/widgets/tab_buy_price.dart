import 'package:flutter/material.dart';

class TabBuyPrice extends StatefulWidget {
  const TabBuyPrice({
    super.key,
    required this.priceController,
    required this.keyboardSize,
    required this.updatePrice,
  });

  final TextEditingController priceController;
  final double keyboardSize;
  final Function updatePrice;

  @override
  State<TabBuyPrice> createState() => _TabBuyPriceState();
}

class _TabBuyPriceState extends State<TabBuyPrice> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: widget.keyboardSize + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: widget.priceController,
            autofocus: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              widget.priceController.value = TextEditingValue(
                text: value,
                selection: TextSelection(baseOffset: value.length, extentOffset: value.length),
              );
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(16),
              filled: true,
              label: const Text('Price Per Coin'),
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
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
                widget.updatePrice();
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
  }
}

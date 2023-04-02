import 'package:flutter/material.dart';

class TabBuyPrice extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
                updatePrice();
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

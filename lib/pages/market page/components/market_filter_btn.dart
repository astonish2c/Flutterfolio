import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class MarketFilterBtn extends StatelessWidget {
  final bool isSelected;
  final String? text;
  final Function onTap;

  const MarketFilterBtn({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Ink(
        width: double.infinity,
        height: 35,
        child: TextButton.icon(
          icon: isSelected
              ? const Icon(
                  Icons.arrow_drop_up,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
          label: Text(
            text!,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: defaultPadding,
              vertical: defaultPadding / 2,
            ),
            backgroundColor: isSelected ? Colors.blueAccent : Colors.white,
          ),
          onPressed: () => onTap(),
        ),
      ),
    );
  }
}

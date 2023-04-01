import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '/screens/tab_screen/widgets/tab_screen_mixin.dart';
import 'tab_transaction_details_item.dart';

class TabTransactionDetails extends StatefulWidget {
  const TabTransactionDetails({
    super.key,
    required this.isDateSet,
    required this.isPriceSet,
    required this.selectedDate,
    required this.setDateTime,
    required this.setPricePerCoin,
  });

  final DateTime selectedDate;

  final bool isDateSet;
  final bool isPriceSet;

  final Function setDateTime;
  final Function setPricePerCoin;

  @override
  State<TabTransactionDetails> createState() => _TabTransactionDetailsState();
}

class _TabTransactionDetailsState extends State<TabTransactionDetails> with TabScreenMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: 12),
          TabTransactionDetailsItem(
            icon: Icon(
              Icons.date_range,
              size: 16,
              color: widget.isDateSet ? Colors.white : Colors.black54,
            ),
            onTap: () => selectDateAndTime(
              context: context,
              isDateSet: widget.isDateSet,
              selectedDate: widget.selectedDate,
              setDate: widget.setDateTime,
            ),
            text: DateFormat('d, MMM, y, h:m a').format(widget.selectedDate),
            textColor: widget.isDateSet ? Colors.white : Colors.black54,
            bgColor: widget.isDateSet ? Colors.blue[900] : Colors.grey[300],
          ),
          const SizedBox(width: 12),
          TabTransactionDetailsItem(
            icon: Icon(
              Icons.attach_money_rounded,
              size: 18,
              color: widget.isPriceSet ? Colors.white : Colors.black54,
            ),
            onTap: () => widget.setPricePerCoin(),
            text: 'Price Per Coin',
            textColor: widget.isPriceSet ? Colors.white : Colors.black54,
            bgColor: widget.isPriceSet ? Colors.blue[900] : Colors.grey[300],
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

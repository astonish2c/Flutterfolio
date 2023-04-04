import 'package:flutter/material.dart';

class TransactionsBottomSheetRow extends StatelessWidget {
  final String title1, title2;

  const TransactionsBottomSheetRow({
    Key? key,
    required this.title1,
    required this.title2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title1,
            style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            title2,
            style: theme.textTheme.titleSmall,
          ),
        ],
      ),
    );
  }
}

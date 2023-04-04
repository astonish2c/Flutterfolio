import 'package:flutter/material.dart';

import '../../../../model/coin_model.dart';

class AddCoinsItem extends StatelessWidget {
  final CoinModel coinModel;

  const AddCoinsItem({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 4,
          leading: SizedBox(
            height: 30,
            width: 30,
            child: Image.network(
              coinModel.image,
              errorBuilder: (context, error, stackTrace) => Image.asset(
                'assets/images/no-wifi.png',
                color: theme.colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          title: Row(
            children: [
              Text(
                coinModel.symbol.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                coinModel.name,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
        ),
        const Divider(
          color: Colors.white24,
          thickness: 0,
        ),
      ],
    );
  }
}

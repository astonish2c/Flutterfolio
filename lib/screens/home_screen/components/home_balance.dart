import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../../custom_widgets/helper_methods.dart';

class HomeBalance extends StatelessWidget {
  const HomeBalance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: theme.backgroundColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'My Balance',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Consumer<DataProvider>(
              builder: (context, value, child) => Text(
                currencyConverter(value.userBalance),
                maxLines: 1,
                style: theme.textTheme.titleLarge,
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '/custom_widgets/helper_methods.dart';
import '../../../models/coin_model.dart';
import '/custom_widgets/custom_image.dart';
import '../components/portfolio_priceColumn.dart';

class PortfolioCoinSkeleton extends StatelessWidget {
  const PortfolioCoinSkeleton({
    required this.coin,
    Key? key,
  }) : super(key: key);

  final CoinModel coin;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16 / 2),
          child: Row(
            children: [
              Image.network(
                coin.image,
                width: 50,
                height: 50,
                errorBuilder: (context, error, stackTrace) => const CustomImage(
                  imagePath: 'assets/images/no-wifi.png',
                  size: 50,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(coin.name.toCapitalized(), style: theme.textTheme.titleMedium),
                  const SizedBox(height: 16 / 4),
                  Text(coin.symbol.toUpperCase(), style: theme.textTheme.bodyMedium!.copyWith(color: theme.colorScheme.onPrimaryContainer.withOpacity(0.4))),
                ],
              ),
              const Spacer(),
              PortfolioPriceColumn(coin: coin),
            ],
          ),
        ),
        const Divider(thickness: 0.2),
      ],
    );
  }
}

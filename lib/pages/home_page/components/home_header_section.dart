import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // print('Home Header is called');
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(defaultPadding * 1.5),
      margin: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: theme.backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Title
          Text(
            'My Balance',
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: defaultPadding / 1.75),
          //Price Row
          Row(
            children: [
              //Price
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Consumer<DataProvider>(
                    builder: (context, value, child) => Text(
                      '\$${convertStrToNum(value.totalUserBalance)}',
                      maxLines: 1,
                      style: theme.textTheme.titleLarge,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              //PNL value
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.green[300],
                ),
                child: Consumer<DataProvider>(
                  builder: (context, value, child) => Text(
                    value.userCoins.isNotEmpty ? '20%' : '0%',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: defaultPadding / 1.75),
          //Todays Profit
          Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Todays PNL ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium!,
              ),
              const SizedBox(width: 4),
              Consumer<DataProvider>(
                builder: (context, value, child) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green[300],
                  ),
                  child: Text(
                    value.userCoins.isNotEmpty ? '\$1,896' : '\$0',
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(defaultPadding * 1.5),
      margin: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: lightBlue.withOpacity(0.4),
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
            style: textTheme.bodyMedium!.copyWith(
              color: Colors.grey[300],
            ),
          ),
          SizedBox(height: defaultPadding / 1.75),
          //Price Row
          Row(
            children: [
              //Price
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '\$${convertStrToNum(dataProvider.totalUserBalance)}',
                    maxLines: 1,
                    style: textTheme.headline4!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              SizedBox(width: defaultPadding),
              //PNL value
              Container(
                padding: EdgeInsets.symmetric(horizontal: defaultPadding / 2, vertical: defaultPadding / 3),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.2),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.arrow_upward_rounded,
                      color: Colors.greenAccent,
                      size: 16,
                    ),
                    Text(
                      dataProvider.userCoins.isNotEmpty ? '20%' : '0%',
                      style: textTheme.bodyLarge!.copyWith(
                        color: Colors.greenAccent,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: defaultPadding / 1.75),
          //Todays Profit
          Wrap(
            direction: Axis.horizontal,
            spacing: defaultPadding * 0.75,
            runSpacing: defaultPadding / 4,
            children: [
              Text(
                'Todays PNL ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium!.copyWith(
                  color: Colors.grey[300],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: Colors.greenAccent,
                    size: 16,
                  ),
                  SizedBox(width: defaultPadding / 2),
                  Text(
                    dataProvider.userCoins.isNotEmpty ? '\$1,896' : '\$0',
                    style: textTheme.bodyMedium!.copyWith(
                      color: Colors.greenAccent,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

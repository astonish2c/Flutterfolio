// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/constants.dart';
import 'chart.dart';

class CoinListItem extends StatefulWidget {
  const CoinListItem({
    required this.coinModel,
    Key? key,
  }) : super(key: key);

  final CoinModel coinModel;

  @override
  State<CoinListItem> createState() => _CoinListItemState();
}

class _CoinListItemState extends State<CoinListItem> {
  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        //Row
        Padding(
          padding: EdgeInsets.symmetric(vertical: defaultPadding / 2),
          child: Row(
            children: [
              //Icon
              SizedBox(
                width: 50,
                height: 50,
                child: Image.network(widget.coinModel.imageUrl),
              ),
              SizedBox(width: defaultPadding),
              //Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.coinModel.shortName.toUpperCase(),
                    style: theme.textTheme.titleMedium,
                  ),
                  SizedBox(height: defaultPadding / 4),
                  Text(
                    widget.coinModel.name,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
              Spacer(),
              //Price Row
              buildPriceColumn(deviceWidth),
            ],
          ),
        ),
        //Divider
        Divider(),
      ],
    );
  }

  Column buildPriceColumn(double deviceWidth) {
    bool isNegative = double.parse(widget.coinModel.priceDiff).isNegative;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        //Price
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '\$${convertStrToNum(widget.coinModel.currentPrice)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        SizedBox(height: defaultPadding / 4),
        //Percentage
        Consumer<ThemeProvider>(
          builder: (context, value, child) => FittedBox(
            fit: BoxFit.scaleDown,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: isNegative ? Colors.red[300] : Colors.green[300], borderRadius: BorderRadius.circular(4)),
              child: Text('${isNegative ? '' : '+'}${convertPerToNum(widget.coinModel.priceDiff)}%', maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.black)),
            ),
          ),
        ),
      ],
    );
  }
}

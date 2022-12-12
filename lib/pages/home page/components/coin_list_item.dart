// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../model/coin_model.dart';
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
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

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
                child: Image.asset(widget.coinModel.imageUrl),
              ),
              SizedBox(width: defaultPadding),
              //Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.coinModel.shortName.toUpperCase(),
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: defaultPadding / 4),
                  Text(
                    widget.coinModel.name,
                    style: TextStyle(
                      color: Colors.white.withOpacity(.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              //Chart
              if (deviceWidth >= 370)
                Expanded(
                  child: Row(
                    children: [
                      SizedBox(width: defaultPadding),
                      //Chart
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: Chart(
                            coinModel: widget.coinModel,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(width: defaultPadding),
              //Price Row
              if (deviceWidth < 370)
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: buildPriceColumn(deviceWidth),
                      ),
                      IconButton(
                        padding: EdgeInsets.symmetric(horizontal: defaultPadding),
                        constraints: BoxConstraints(),
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              if (deviceWidth >= 370) buildPriceColumn(deviceWidth),
            ],
          ),
        ),

        //Hidden Chart
        if (_isExpanded && deviceWidth < 370)
          SizedBox(
            height: 70,
            width: double.infinity,
            child: Chart(coinModel: widget.coinModel),
          ),
        //Divider
        Divider(
          color: Colors.white.withOpacity(0.1),
          thickness: 1,
        ),
      ],
    );
  }

  Column buildPriceColumn(double deviceWidth) {
    NumberFormat numberFormat = NumberFormat.decimalPattern();

    return Column(
      crossAxisAlignment: deviceWidth < 370 ? CrossAxisAlignment.end : CrossAxisAlignment.end,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '\$${convertStrToNum(widget.coinModel.currentPrice)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(height: defaultPadding / 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.coinModel.priceDiff,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Colors.greenAccent,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

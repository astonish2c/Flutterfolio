// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:intl/intl.dart';
import 'package:crypto_exchange_app/utils/scaffold_bg.dart';
import 'package:flutter/material.dart';

import '../../../model/coin_model.dart';

class CoinDetailScreen extends StatelessWidget {
  static const routeName = 'CoinDetailScreen';

  const CoinDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, CoinModel> args = ModalRoute.of(context)!.settings.arguments as Map<String, CoinModel>;
    final CoinModel coinModel = args['obj']!;

    return SafeArea(
      child: ScaffoldBG(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(coinModel.name),
          ),
          body: Padding(
            padding: EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Title
                Text(
                  'Transactions',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: defaultPadding),
                //Type & Quantity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type'),
                    Text('Quantity'),
                  ],
                ),
                SizedBox(height: defaultPadding),
                //Item Details
                Expanded(
                  child: ListView.builder(
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return CoinDetailScreenListItem(coinModel: coinModel);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CoinDetailScreenListItem extends StatelessWidget {
  const CoinDetailScreenListItem({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  final CoinModel coinModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            //Icon
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_downward_rounded,
                color: Colors.white,
              ),
            ),
            SizedBox(width: defaultPadding / 2),
            //Buy & Date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Buy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    DateFormat('E, MMM d, y, h:m a').format(DateTime.now()),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: defaultPadding / 2),
            //Price & Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$36.32',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '+3.9 ${coinModel.shortName}',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: defaultPadding / 2),
        Divider(
          color: Colors.white.withOpacity(0.2),
          thickness: 1,
        ),
        SizedBox(height: defaultPadding / 2),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:crypto_exchange_app/provider/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';
import '../utils/holdings_acton_btn.dart';
import '../../../utils/icon_btn_zero_padding.dart';

class HoldingsHeaderSection extends StatelessWidget {
  HoldingsHeaderSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);
    final TextTheme textTheme = Theme.of(context).textTheme;
    final double totalBtcValue = convertDollerToBTC(dataProvider.totalUserBalance);
    final double totalBalanceInDoller = convertBtcToDoller(totalBtcValue);
    final String totalDollerBalance = convertStrToNum(totalBalanceInDoller);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        //Equity Value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Value Row
            Row(
              children: [
                Text(
                  'Equit Value (BTC)',
                  style: textTheme.bodyMedium,
                ),
                SizedBox(width: 4),
                Consumer<ThemeProvider>(
                  builder: (context, value, child) => IconBtnZeroPadding(
                    icon: Icons.remove_red_eye,
                    size: 20,
                    color: value.isDark ? Colors.grey[300] : Colors.black54,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                // dataProvider.togglePieChart();
              },
              child: Row(
                children: [
                  Text('Change view', style: textTheme.bodyMedium),
                  SizedBox(width: 4),
                  Icon(Icons.pie_chart_rounded, size: 20),
                ],
              ),
            ),
          ],
        ),
        //Value in BTC
        Text(
          totalBtcValue.toStringAsFixed(8),
          style: textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
        ),
        //Value in Doller
        Text(
          '~ \$$totalDollerBalance',
          style: textTheme.bodyMedium,
        ),
        SizedBox(height: defaultPadding),
        //Today's PNL
        Row(
          children: [
            Text(
              'Today\'s PNL',
              style: textTheme.bodyMedium,
            ),
            IconBtnZeroPadding(icon: Icons.show_chart),
          ],
        ),
        //PNL Value
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(4)),
                child: Text(
                  '+\$0.77/+1.43%',
                  style: textTheme.bodySmall!.copyWith(color: Colors.black),
                ),
              ),
              Icon(Icons.arrow_right),
            ],
          ),
        ),
        // IconBtnZeroPadding(icon: Icons.arrow_right, size: 22),
        SizedBox(height: defaultPadding),
        //Deposit Btns Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              child: HoldingsActionBtn(
                text: 'Deposit',
                btnColor: lightBlue,
                txtColor: Colors.white,
              ),
            ),
            SizedBox(width: defaultPadding / 2),
            Expanded(child: HoldingsActionBtn(text: 'Withdraw')),
            SizedBox(width: defaultPadding / 2),
            Expanded(child: HoldingsActionBtn(text: 'Transfer')),
          ],
        ),
      ],
    );
  }
}

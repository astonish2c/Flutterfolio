// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/data_provider.dart';
import '../../../utils/constants.dart';
import 'holdings_acton_btn.dart';
import 'grey_small_txt.dart';
import 'icon_btn_zero_padding.dart';

class HoldingsHeader extends StatelessWidget {
  HoldingsHeader({
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
                GreySmallText(
                  textTheme: textTheme,
                  text: 'Equit Value (BTC)',
                ),
                SizedBox(width: defaultPadding * .25),
                // SizedBox(width: defaultPadding / 4),
                IconBtnZeroPadding(
                  icon: Icons.remove_red_eye,
                  size: 20,
                ),
              ],
            ),
            InkWell(
              onTap: () {
                dataProvider.togglePieChart();
              },
              child: Row(
                children: [
                  Text('Change view'),
                  SizedBox(width: defaultPadding * .25),
                  Icon(
                    Icons.pie_chart_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        //Value in BTC
        WhiteMediumText(
          textTheme: textTheme,
          text: totalBtcValue.toStringAsFixed(8),
        ),
        //Value in Doller
        GreySmallText(
          textTheme: textTheme,
          text: '~ \$$totalDollerBalance',
        ),
        SizedBox(height: defaultPadding),
        //Today's PNL
        Row(
          children: [
            GreySmallText(
              textTheme: textTheme,
              text: 'Today\'s PNL',
            ),
            // SizedBox(width: defaultPadding / 4),
            IconBtnZeroPadding(icon: Icons.show_chart),
          ],
        ),
        //PNL Value
        Row(
          children: [
            Text(
              '+\$0.77/+1.43%',
              style: TextStyle(
                fontSize: 16,
                color: Colors.greenAccent,
              ),
            ),
            // SizedBox(width: defaultPadding / 4),
            IconBtnZeroPadding(icon: Icons.arrow_right, size: 22),
          ],
        ),
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

class WhiteMediumText extends StatelessWidget {
  final String text;

  const WhiteMediumText({
    Key? key,
    required this.textTheme,
    required this.text,
  }) : super(key: key);

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: textTheme.headline4!.copyWith(
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

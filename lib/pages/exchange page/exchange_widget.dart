// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:flutter/material.dart';

import '../holdings page/components/grey_small_txt.dart';
import 'components/exchange_big_btn.dart';
import 'components/exchange_coin_row.dart';
import 'components/exchange_page_btn.dart';

class ExchangeWidget extends StatelessWidget {
  final Function changePageValue;
  final int pageIndex;

  const ExchangeWidget({super.key, required this.changePageValue, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        //body
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Navigation Titles
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ExchangePageBtn(
                    text: "Market",
                    value: 0,
                    show: pageIndex == 0 ? true : false,
                    onTap: () => changePageValue(0),
                    color: pageIndex == 0 ? Colors.white : Colors.grey[400],
                  ),
                  ExchangePageBtn(
                    text: "Limit",
                    value: 1,
                    show: pageIndex == 1 ? true : false,
                    onTap: () => changePageValue(1),
                    color: pageIndex == 1 ? Colors.white : Colors.grey[400],
                  ),
                ],
              ),
              SizedBox(height: defaultPadding * 2),
              //From Row
              Row(
                children: [
                  //From
                  Expanded(
                    child: GreySmallText(textTheme: textTheme, text: 'From'),
                  ),
                  //Spot Wallet
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Spot Wallet'),
                      SizedBox(width: defaultPadding / 4),
                      InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.swap_horiz_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: defaultPadding / 2),
              //coin Row
              ExchangeCoinRow(
                iconUrl: "assets/images/bitcoin.png",
                coinTitle: 'BTC',
                hintText: '0.0038 - 14000',
                showTrail: true,
              ),
              SizedBox(height: defaultPadding / 2),
              //Available
              GreySmallText(textTheme: textTheme, text: 'Available: 0.17607917 BTC'),
              SizedBox(height: defaultPadding),
              //Exchange Icon
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  borderRadius: BorderRadius.circular(30),
                  onTap: () {},
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.swap_vert,
                      color: Colors.blueAccent,
                      size: 30,
                    ),
                  ),
                ),
              ),
              //To
              GreySmallText(
                text: 'To',
                textTheme: textTheme,
              ),
              SizedBox(height: defaultPadding / 2),
              //coin Row
              ExchangeCoinRow(
                iconUrl: "assets/images/ethereum.png",
                coinTitle: 'ETH',
                hintText: '0.002 - 14000',
                showTrail: false,
              ),
              SizedBox(height: defaultPadding * 2),
            ],
          ),
        ),
        //Preview Exchange
        ExchnageBigBtn(
          text: 'Preview Conversion',
          fontSize: 18,
        ),
      ],
    );
  }
}

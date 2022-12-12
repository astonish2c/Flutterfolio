// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutablesimport 'package:crypto_exchange_app/pages/holdings%20page/components/icon_btn_zero_padding.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import '../../../provider/data_provider.dart';
import 'package:crypto_exchange_app/utils/constants.dart';

class HoldingsPieChart extends StatelessWidget {
  const HoldingsPieChart({super.key});

  String calPercentage(BuildContext context, int index) {
    final dataProvider = Provider.of<DataProvider>(context);
    final totalBalance = dataProvider.userCoins.fold(0.0, (previousValue, element) => (element.currentPrice * element.amount!) + previousValue);
    final value = (dataProvider.userCoins[index].amount! * dataProvider.userCoins[index].currentPrice) / totalBalance;
    final percentageValue = value * 100;
    return '${percentageValue.toStringAsFixed(2)}%';
  }

  @override
  Widget build(BuildContext context) {
    final DataProvider dataProvider = Provider.of<DataProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Title Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Title
            Text(
              'Holdings Percentage',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            //Change View
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
                    color: Colors.blueAccent,
                    size: 16,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        //Chart
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //Pie-Chart
              SizedBox(
                height: 170,
                width: double.infinity,
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0.0,
                    centerSpaceRadius: 50.0,
                    startDegreeOffset: 0,
                    sections: [
                      ...dataProvider.userCoins.map((e) {
                        return PieChartSectionData(
                          showTitle: false,
                          value: (e.amount! * e.currentPrice),
                          title: calPercentage(context, dataProvider.userCoins.indexOf(e)),
                          titleStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                          color: e.color,
                          radius: 30,
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: defaultPadding),
              //Coin Title with percentage
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    runSpacing: defaultPadding / 4,
                    children: [
                      ...dataProvider.userCoins.map((e) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          // crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            //Color Container
                            Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: e.color,
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            SizedBox(width: defaultPadding * 0.25),
                            //Title
                            Text(
                              e.name,
                              style: TextStyle(
                                color: e.color,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: defaultPadding * 0.25),
                            //Percentage
                            Text(
                              calPercentage(
                                context,
                                dataProvider.userCoins.indexOf(e),
                              ),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: defaultPadding * 0.5),
                          ],
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

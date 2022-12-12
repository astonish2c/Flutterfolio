// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../model/coin_model.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  final CoinModel coinModel;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              fitInsideVertically: true,
              tooltipPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
            ),
          ),
          minX: 0,
          maxX: 18,
          minY: 0,
          maxY: 6,
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          clipData: FlClipData.none(),
          lineBarsData: [
            LineChartBarData(
              isCurved: true,
              dotData: FlDotData(show: false),
              color: coinModel.color,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    coinModel.color.withOpacity(0.4),
                    coinModel.color.withOpacity(0.1),
                  ],
                ),
              ),
              spots: [
                FlSpot(0, 3),
                FlSpot(2.6, 2),
                FlSpot(4.9, 5),
                FlSpot(6.8, 2.5),
                FlSpot(8, 4),
                FlSpot(9.5, 3),
                FlSpot(11, 4),
                FlSpot(12, 3),
                FlSpot(13, 2),
                FlSpot(14, 5),
                FlSpot(15, 2.5),
                FlSpot(16, 4),
                FlSpot(17, 3),
                FlSpot(18, 4),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

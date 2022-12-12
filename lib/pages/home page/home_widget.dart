import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'components/home_header.dart';
import 'components/home_portfolio.dart';

class HomeWidget extends StatelessWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HomeHeader(),
        SizedBox(height: defaultPadding * 0.75),
        const Expanded(
          child: HomePortfolio(),
        ),
      ],
    );
  }
}

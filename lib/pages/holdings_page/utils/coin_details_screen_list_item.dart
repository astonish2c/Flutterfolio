import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';
import '../../../utils/constants.dart';

class CoinDetailScreenListItem extends StatelessWidget {
  const CoinDetailScreenListItem({
    Key? key,
    required this.coinModel,
    this.buyCoin,
  }) : super(key: key);

  final CoinModel coinModel;
  final Transaction? buyCoin;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              //Icon
              Consumer<ThemeProvider>(
                builder: (context, value, child) => Container(
                  padding: const EdgeInsets.only(left: 4, top: 6, bottom: 6, right: 4),
                  decoration: BoxDecoration(
                    color: value.isDark ? Colors.white.withOpacity(0.2) : Colors.black.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_downward_rounded,
                    color: value.isDark ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              //Buy & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4, left: 4),
                      child: Text(
                        'Buy',
                        textAlign: TextAlign.start,
                        style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        DateFormat('E, MMM d, y, h:m a').format(buyCoin!.dateTime),
                        textAlign: TextAlign.start,
                        style: textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              //Price & Amount
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '+\$${convertStrToNum(buyCoin!.buyPrice * buyCoin!.amount)}',
                        style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green[300], borderRadius: BorderRadius.circular(4)),
                      child: Text(
                        '+${buyCoin!.amount} ${coinModel.shortName.toUpperCase()}',
                        style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          color: Colors.white.withOpacity(0.2),
          thickness: 1,
        ),
        SizedBox(height: defaultPadding / 2),
      ],
    );
  }
}

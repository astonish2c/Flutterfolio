import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_iconButton.dart';
import '../../models/coin_model.dart';
import '../../provider/allCoins_provider.dart';
import '../tab_screen/tab_screen.dart';
import 'components/addCoins_skeleton.dart';

class AddCoinsScreen extends StatefulWidget {
  static const routeName = 'Home_Items_List';
  const AddCoinsScreen({super.key});

  @override
  State<AddCoinsScreen> createState() => _AddCoinsScreenState();
}

class _AddCoinsScreenState extends State<AddCoinsScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<CoinModel> coins = context.read<AllCoinsProvider>().getCoins;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leading: CustomIconButton(
          icon: Icons.keyboard_arrow_left,
          size: 25,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Select Coin', style: theme.textTheme.titleMedium!.copyWith(fontSize: 18)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: coins.isEmpty
            ? const Text('No coins available')
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: coins.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              TabScreen.routeName,
                              arguments: {'coinModel': coins[index], 'initialPage': 0},
                            );
                          },
                          child: AddCoinsSkeleton(coinModel: coins[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

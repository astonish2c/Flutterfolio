import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_alertDialog.dart';
import '../../custom_widgets/custom_iconButton.dart';
import '../../model/coin_model.dart';
import '../../provider/allCoins_provider.dart';
import '../tab_screen/tab_screen.dart';
import 'components/addCoins_shimmer.dart';
import 'components/addCoins_skeleton.dart';
import 'widgets/helper_methods.dart';

class AddCoinsScreen extends StatefulWidget {
  static const routeName = 'Home_Items_List';
  const AddCoinsScreen({super.key});

  @override
  State<AddCoinsScreen> createState() => _AddCoinsScreenState();
}

class _AddCoinsScreenState extends State<AddCoinsScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDbStatus(context: context);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<CoinModel> coins = context.read<AllCoinsProvider>().getCoins;

    final bool isLoadingDatabase = context.select((AllCoinsProvider dataProvider) => dataProvider.isLoadingDatabase);
    final bool isDatabaseAvailable = context.select((AllCoinsProvider dataProvider) => dataProvider.isDatabaseAvailable);

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
        child: isLoadingDatabase
            ? const AddCoinsShimmer()
            : coins.isEmpty
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
      floatingActionButton: isDatabaseAvailable
          ? const Text('')
          : isLoadingDatabase
              ? const Text('')
              : FloatingActionButton(
                  child: const Icon(Icons.refresh),
                  onPressed: () async {
                    try {
                      await context.read<AllCoinsProvider>().getApiCoins();
                    } catch (e) {
                      await showDialog(
                        context: context,
                        builder: (context) => CustomAlertDialog(
                          error: e.toString(),
                        ),
                      );
                    }
                  },
                ),
    );
  }
}

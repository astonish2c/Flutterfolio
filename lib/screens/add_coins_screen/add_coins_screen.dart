import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../custom_widgets/custom_alert_dialog.dart';
import '/screens/tab_screen/tab_screen.dart';
import '/custom_widgets/custom_icon_btn.dart';
import '../../model/coin_model.dart';
import '../../provider/data_provider.dart';
import '../../provider/theme_provider.dart';

import 'components/add_coins_item.dart';
import 'components/add_coins_shimmer.dart';
import 'helper_methods.dart';

class AddCoinsScreen extends StatefulWidget {
  static const routeName = 'Home_Items_List';
  const AddCoinsScreen({super.key});

  @override
  State<AddCoinsScreen> createState() => _AddCoinsScreenState();
}

class _AddCoinsScreenState extends State<AddCoinsScreen> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDbStatus(context: context);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final List<CoinModel> coins = context.read<DataProvider>().getCoins;

    final bool isLoadingDatabase = context.select((DataProvider dataProvider) => dataProvider.isLoadingDatabase);
    final bool isDatabaseAvailable = context.select((DataProvider dataProvider) => dataProvider.isDatabaseAvailable);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: Consumer<ThemeProvider>(
            builder: (context, value, child) => CustomIconButton(
              icon: Icons.keyboard_arrow_left,
              size: 25,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text('Select Coin', style: theme.textTheme.titleMedium!.copyWith(fontSize: 18)),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
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
                                    Navigator.of(context).pushNamed(TabScreen.routeName, arguments: {'coinModel': coins[index], 'initialPage': 0});
                                  },
                                  child: AddCoinsItem(coinModel: coins[index]),
                                );
                              }),
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
                        await context.read<DataProvider>().getApiCoins();
                      } catch (e) {
                        await showDialog(
                          context: context,
                          builder: (context) => CustomAlertDialog(error: e.toString()),
                        );
                      }
                    },
                  ));
  }
}

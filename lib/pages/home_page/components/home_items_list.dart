import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../provider/theme_provider.dart';
import 'home_tab_bar.dart';
import 'package:crypto_exchange_app/utils/custom_icon_button.dart';

class HomeItemsList extends StatefulWidget {
  static const routeName = 'Home_Items_List';
  const HomeItemsList({super.key});

  @override
  State<HomeItemsList> createState() => _HomeItemsListState();
}

class _HomeItemsListState extends State<HomeItemsList> {
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    // context.read<DataProvider>().setApiCoins();
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

    return GestureDetector(
      onTap: () => _searchFocusNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          titleSpacing: 0,
          leading: Consumer<ThemeProvider>(
            builder: (context, value, child) => CustomIconButton(
              icon: Icons.keyboard_arrow_left,
              size: 25,
              color: value.isDark ? Colors.white : Colors.black,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          title: Text('Select Coin', style: theme.textTheme.titleMedium!.copyWith(fontSize: 18)),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Builder(builder: (context) {
                  List<CoinModel> coins = context.watch<DataProvider>().getCoins;
                  return Expanded(
                    child: coins.isEmpty
                        ? const Text('No coins available')
                        : ListView.builder(
                            itemCount: coins.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => HomeTabBar(coinModel: coins[index], initialPage: 0),
                                    ),
                                  );
                                },
                                child: ListItem(coinModel: coins[index]),
                              );
                            }),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final CoinModel coinModel;

  const ListItem({
    Key? key,
    required this.coinModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          horizontalTitleGap: 4,
          leading: SizedBox(
            height: 30,
            width: 30,
            child: Image.network(coinModel.image),
          ),
          title: Row(
            children: [
              Text(
                coinModel.symbol.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                coinModel.name,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
        ),
        const Divider(
          color: Colors.white24,
          thickness: 0,
        ),
      ],
    );
  }
}

// ignore_for_file: non_constant_identifier_names, avoid_print, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:crypto_exchange_app/pages/market_page/market_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/coin_model.dart';
import '../../../provider/data_provider.dart';
import '../../../provider/theme_provider.dart';
import '../components/home_tab_bar.dart';
import 'package:crypto_exchange_app/utils/custom_icon_button.dart';

class AddCoinsPage extends StatefulWidget {
  static const routeName = 'Home_Items_List';
  const AddCoinsPage({super.key});

  @override
  State<AddCoinsPage> createState() => _AddCoinsPageState();
}

class _AddCoinsPageState extends State<AddCoinsPage> {
  final FocusNode _searchFocusNode = FocusNode();

  Future<void> checkDbStatus() async {
    final bool is_Database_Available = context.read<DataProvider>().isDatabaseAvailable;

    if (is_Database_Available) return;

    try {
      await context.read<DataProvider>().getApiCoins();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkDbStatus();
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

    final bool isLoading = context.select((DataProvider dataProvider) => dataProvider.isLoadingDatabase);
    final bool is_Database_Available = context.select((DataProvider dataProvider) => dataProvider.isDatabaseAvailable);

    return Scaffold(
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
        body: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: isLoading
              ? Shimmer.fromColors(
                  baseColor: Colors.blue,
                  highlightColor: Colors.black,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemCount: 12,
                          itemBuilder: (context, index) => Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Skelton(
                                height: 50,
                                width: 50,
                                borderCircle: 32,
                              ),
                              SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Skelton(width: 60),
                                  SizedBox(height: 16 / 4),
                                  const Skelton(width: 30),
                                ],
                              ),
                              const Spacer(),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const Skelton(width: 60),
                                  SizedBox(height: 16 / 4),
                                  const Skelton(width: 40),
                                ],
                              ),
                            ],
                          ),
                          separatorBuilder: (BuildContext context, int index) => SizedBox(height: 32),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: coins.isEmpty
                          ? const Text('No coins available')
                          : ListView.builder(
                              physics: const BouncingScrollPhysics(),
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
                                  child: CoinItem(coinModel: coins[index]),
                                );
                              }),
                    ),
                  ],
                ),
        ),
        floatingActionButton: is_Database_Available
            ? const Text('')
            : isLoading
                ? const Text('')
                : FloatingActionButton(
                    child: const Icon(Icons.refresh),
                    onPressed: () async {
                      try {
                        await context.read<DataProvider>().getApiCoins();
                      } catch (e) {
                        AlertDialog(
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                          title: const Text(
                            'Oh snap!',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          content: Text('$e', style: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 14, color: Colors.white)),
                        );
                      }
                    },
                  ));
  }
}

class CoinItem extends StatelessWidget {
  final CoinModel coinModel;

  const CoinItem({
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

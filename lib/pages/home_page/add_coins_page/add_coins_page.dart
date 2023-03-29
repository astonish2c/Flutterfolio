// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    final bool is_Database_Available = context.read<DataProvider>().is_DataBase_Available;
    bool isSnackBarVisible = false;

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

    final bool hasError = context.select((DataProvider dataProvider) => dataProvider.hasError);
    final bool isLoading = context.select((DataProvider dataProvider) => dataProvider.isLoading);
    final bool is_Database_Available = context.select((DataProvider dataProvider) => dataProvider.is_DataBase_Available);

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
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: Column(
                    children: [
                      Expanded(
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
                                    child: CoinItem(coinModel: coins[index]),
                                  );
                                }),
                      ),
                    ],
                  ),
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
                        //TODO: remove floating button while SnackBar shows

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

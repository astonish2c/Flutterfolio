// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:crypto_exchange_app/utils/custom_icon_button.dart';
import 'package:provider/provider.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:flutter/material.dart';

import '../../../provider/data_provider.dart';
import '../../../provider/theme_provider.dart';
import 'home_tab_bar.dart';

class HomeItemsList extends StatefulWidget {
  static const routeName = 'Home_Items_List';
  const HomeItemsList({super.key});

  @override
  State<HomeItemsList> createState() => _HomeItemsListState();
}

class _HomeItemsListState extends State<HomeItemsList> {
  final FocusNode _searchFocusNode = FocusNode();

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
                Expanded(
                  child: Consumer<DataProvider>(
                    builder: (context, value, child) => ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: value.allCoins.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeTabBar(coinModel: value.allCoins[index], initialPage: 0)));
                          },
                          child: ListItem(dataProvider: value, index: index),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final int index;
  final DataProvider dataProvider;

  const ListItem({
    Key? key,
    required this.index,
    required this.dataProvider,
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
            child: Image.network(dataProvider.allCoins[index].image),
          ),
          title: Row(
            children: [
              Text(
                dataProvider.allCoins[index].symbol.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 6),
              Text(
                dataProvider.allCoins[index].name,
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ),
          trailing: Icon(
            Icons.keyboard_arrow_right,
            color: Colors.grey,
          ),
        ),
        Divider(
          color: Colors.white24,
          thickness: 0,
        ),
      ],
    );
  }
}

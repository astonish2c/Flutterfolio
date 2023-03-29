import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/provider/theme_provider.dart';
import '/utils/custom_icon_button.dart';
import '../add_coins_page/add_coins_page.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Consumer<ThemeProvider>(
        builder: (context, value, child) => CustomIconButton(
          size: 25,
          onPressed: () {
            value.toggleThemeMode();
          },
          icon: Icons.dark_mode,
        ),
      ),
      title: Text(
        'CryptoLand',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AddCoinsPage.routeName),
          child: Row(
            children: [
              const Icon(
                color: Colors.black,
                size: 25,
                Icons.add,
              ),
              Center(
                child: Text(
                  'Add',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:crypto_exchange_app/provider/theme_provider.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    // print('HomeAppBar build');
    return AppBar(
      centerTitle: true,
      leading: Consumer<ThemeProvider>(
        builder: (context, value, child) => CustomIconButton(
          onPressed: () {
            value.toggleThemeMode();
          },
          icon: const Icon(Icons.dark_mode),
        ),
      ),
      title: Text(
        'CryptoLand',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      actions: [
        CustomIconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications),
        ),
        SizedBox(width: defaultPadding),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/custom_icon_btn.dart';
import '../../add_coins_screen/add_coins_Screen.dart';
import '/provider/theme_provider.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
    required this.hasErrorUserCoin,
  }) : super(key: key);

  final bool hasErrorUserCoin;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      centerTitle: true,
      title: Text(
        'CryptoLand',
        style: theme.textTheme.titleMedium,
      ),
      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) => CustomIconButton(
            size: 25,
            onPressed: () {
              themeProvider.toggleThemeMode();
            },
            icon: Icons.dark_mode,
          ),
        ),
      ],
    );
  }
}

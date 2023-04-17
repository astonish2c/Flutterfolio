import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '/provider/theme_provider.dart';

class PortfolioAppBar extends StatefulWidget with PreferredSizeWidget {
  const PortfolioAppBar();

  @override
  State<PortfolioAppBar> createState() => _PortfolioAppBarState();

  @override
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _PortfolioAppBarState extends State<PortfolioAppBar> {
  late bool _isDarkTheme;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('configs');
    _isDarkTheme = box.get('isDarkTheme') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppBar(
      centerTitle: true,
      title: Text(
        'Flutterfolio',
        style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700, letterSpacing: 1.2),
      ),
      actions: [
        Consumer<ThemeProvider>(
          builder: (context, themeProvider, child) => GestureDetector(
            onTap: () async {
              await themeProvider.toggleThemeMode();
              setState(() {
                _isDarkTheme = !_isDarkTheme;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _isDarkTheme ? const Icon(Icons.wb_sunny_rounded, size: 25) : const Icon(Icons.nightlight_round_rounded, size: 25),
            ),
          ),
        ),
      ],
    );
  }
}

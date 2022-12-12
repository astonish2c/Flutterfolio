// ignore_for_file: prefer_const_constructors

import 'package:crypto_exchange_app/pages/settings%20pages/settings_widget.dart';
import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/nav_bar.dart';
import 'package:crypto_exchange_app/utils/scaffold_bg.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = 'Settings_Page';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ScaffoldBG(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            titleSpacing: 0,
            centerTitle: true,
            title: Text(
              'Settings',
              textAlign: TextAlign.center,
              style: textTheme.headline5!.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: defaultPadding, right: defaultPadding, left: defaultPadding),
            child: SettingsWidget(),
          ),
          bottomNavigationBar: NavBar(currentIndex: 4),
        ),
      ),
    );
  }
}

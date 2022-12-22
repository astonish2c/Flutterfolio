import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:crypto_exchange_app/utils/nav_bar.dart';
import 'package:flutter/material.dart';

import '../exchange_page/components/exchange_big_btn.dart';
import 'components/settings_items.dart';

class SettingsPage extends StatelessWidget {
  static const routeName = 'Settings_Page';

  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        titleSpacing: 0,
        centerTitle: true,
        title: Text(
          'Settings',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium!.copyWith(fontSize: 18),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: defaultPadding, right: defaultPadding, left: defaultPadding),
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Expanded(
                      child: SettingsItems(),
                    ),
                    SizedBox(height: 16),
                    ExchnageBigBtn(
                      text: 'Sign out',
                      borderRadius: 12,
                    ),
                    SizedBox(height: 16),
                    Text('App version: 1.0'),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(currentIndex: 4),
    );
  }
}

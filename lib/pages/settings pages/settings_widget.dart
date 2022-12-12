import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../exchange page/components/exchange_big_btn.dart';
import 'components/settings_items.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SettingsItems()),
              SizedBox(height: defaultPadding),
              const ExchnageBigBtn(
                text: 'Sign out',
                borderRadius: 12,
              ),
              SizedBox(height: defaultPadding),
              const Text('App version: 1.0'),
              SizedBox(height: defaultPadding),
            ],
          ),
        ),
      ],
    );
  }
}

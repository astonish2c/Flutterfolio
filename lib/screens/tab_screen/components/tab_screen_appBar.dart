import 'package:flutter/material.dart';

import '/custom_widgets/custom_image.dart';
import '../../../custom_widgets/custom_iconButton.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../../models/coin_model.dart';

class TabScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TabScreenAppBar({
    super.key,
    required this.coinModel,
    required this.tabBar,
  });

  final CoinModel coinModel;
  final TabBar tabBar;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: CustomIconButton(
        icon: Icons.keyboard_arrow_left,
        size: 25,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          Image.network(
            coinModel.image,
            height: 25,
            width: 25,
            errorBuilder: (context, error, stackTrace) => const CustomImage(
              imagePath: 'assets/images/no-wifi.png',
              size: 25,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            coinModel.symbol.toUpperCase(),
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(width: 4),
          Text(
            coinModel.name.toCapitalized(),
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: tabBar.preferredSize,
        child: tabBar,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(tabBar.preferredSize.height + 50);
}

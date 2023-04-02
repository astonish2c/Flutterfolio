import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../custom_widgets/custom_icon_btn.dart';
import '../../../custom_widgets/helper_methods.dart';
import '../../../model/coin_model.dart';
import '../../../provider/theme_provider.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      leading: CustomIconButton(
        icon: Icons.keyboard_arrow_left,
        size: 25,
        color: context.watch<ThemeProvider>().isDark ? Colors.white : Colors.black,
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          SizedBox(
            height: 25,
            width: 25,
            child: Image.network(
              coinModel.image,
              errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/no-wifi.png'),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            coinModel.symbol.toUpperCase(),
            style: textTheme.titleMedium!.copyWith(fontSize: 18),
          ),
          const SizedBox(width: 4),
          Text(
            coinModel.name.toCapitalized(),
            style: textTheme.bodyMedium,
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

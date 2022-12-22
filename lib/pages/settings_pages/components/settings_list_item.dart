import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/theme_provider.dart';

class SettingsListItem extends StatelessWidget {
  final IconData icon;
  final String? title;
  final Widget? titleAsWidget;
  final Widget? trailing;

  const SettingsListItem({
    Key? key,
    required this.icon,
    this.title,
    this.trailing,
    this.titleAsWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, value, child) => ListTile(
        onTap: () {},
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          color: value.isDark ? Colors.white : Colors.black,
        ),
        title: titleAsWidget ??
            Text(
              title!,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
            ),
        trailing: trailing ??
            Icon(
              Icons.arrow_right,
              color: value.isDark ? Colors.white : Colors.black,
            ),
      ),
    );
  }
}

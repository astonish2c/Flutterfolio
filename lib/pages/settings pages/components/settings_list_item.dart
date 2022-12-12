import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

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
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.zero,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: titleAsWidget ?? Text(title!),
      trailing: trailing ??
          Icon(
            Icons.arrow_right,
            color: Colors.white.withOpacity(0.8),
          ),
    );
  }
}

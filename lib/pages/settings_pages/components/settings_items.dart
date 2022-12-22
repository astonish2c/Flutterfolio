// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'settings_list_item.dart';

class SettingsItems extends StatefulWidget {
  const SettingsItems({super.key});

  @override
  State<SettingsItems> createState() => _SettingsItemsState();
}

class _SettingsItemsState extends State<SettingsItems> {
  bool _switchValue = false;
  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General',
            style: textTheme.titleMedium!.copyWith(fontSize: 18),
          ),
          SizedBox(height: defaultPadding),
          SettingsListItem(
            icon: Icons.notifications,
            title: 'Notifications',
          ),
          SizedBox(height: defaultPadding / 2),
          SettingsListItem(
            icon: Icons.mic,
            title: 'Contact Us',
          ),
          SizedBox(height: defaultPadding * 2),
          Text(
            'Privacy & Security',
            style: textTheme.titleMedium!.copyWith(fontSize: 18),
          ),
          SizedBox(height: defaultPadding),
          SettingsListItem(
            icon: Icons.face_unlock_outlined,
            title: 'Fingerprint & Face ID',
            trailing: Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
            ),
          ),
          SizedBox(height: defaultPadding / 2),
          SettingsListItem(
            icon: Icons.document_scanner,
            title: 'Documents',
          ),
          SizedBox(height: defaultPadding / 2),
          SettingsListItem(
            icon: Icons.document_scanner,
            titleAsWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: textTheme.titleMedium!.copyWith(fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: InkWell(
                    onTap: () {},
                    child: Text(
                      "Choose what data you share with us",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: defaultPadding / 2),
          SettingsListItem(
            icon: Icons.cases_outlined,
            title: 'Legal',
          ),
        ],
      ),
    );
  }
}

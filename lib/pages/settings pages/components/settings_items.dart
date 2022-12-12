// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'settings_list_item.dart';

class SettingsItems extends StatelessWidget {
  const SettingsItems({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'General',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
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
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
          SizedBox(height: defaultPadding),
          SettingsListItem(
            icon: Icons.face_unlock_outlined,
            title: 'Fingerprint & Face ID',
            trailing: Switch(
              value: false,
              onChanged: (value) {},
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
                        color: Colors.greenAccent,
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

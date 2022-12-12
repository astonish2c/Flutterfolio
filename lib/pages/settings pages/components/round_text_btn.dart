// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../utils/constants.dart';

class RoundTextBtn extends StatelessWidget {
  const RoundTextBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.circular(36),
      ),
      child: TextButton(
        onPressed: () {},
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: defaultPadding,
            vertical: defaultPadding,
          ),
          child: Text(
            'Sign Out',
            style: TextStyle(
              color: settingsIcon,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'constants.dart';

class ScaffoldBG extends StatelessWidget {
  final Widget child;

  const ScaffoldBG({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgColor, lightBlue],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}

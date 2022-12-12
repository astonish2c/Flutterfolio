import 'package:flutter/material.dart';

class ResponsiveFramework extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveFramework({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  //Mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 850;
  }

  //Tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850;
  }

  //Desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 1100;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    //Desktop
    if (size.width >= 1100) {
      return desktop;
    }
    //Tablet
    else if (size.width >= 850 && tablet != null) {
      return tablet!;
    }
    //Mobile
    else {
      return mobile;
    }
  }
}

import 'package:flutter/material.dart';

class ShimmerSkelton extends StatelessWidget {
  const ShimmerSkelton({super.key, this.height, this.width, this.borderCircle});

  final double? height, width;
  final double? borderCircle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: theme.colorScheme.onSurface.withOpacity(0.2), borderRadius: BorderRadius.circular(borderCircle ?? 12)),
    );
  }
}

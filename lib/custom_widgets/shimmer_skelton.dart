import 'package:flutter/material.dart';

class ShimmerSkelton extends StatelessWidget {
  const ShimmerSkelton({
    super.key,
    this.height,
    this.width,
    this.borderCircle,
  });

  final double? height, width;
  final double? borderCircle;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(borderCircle ?? 12)),
    );
  }
}

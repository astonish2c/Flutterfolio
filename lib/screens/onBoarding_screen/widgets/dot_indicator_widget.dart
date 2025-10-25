import 'package:flutter/material.dart';

class DotIndicator extends StatelessWidget {
  const DotIndicator({super.key, required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: SizedBox(
        height: isActive ? 12 : 4,
        width: 4,
        child: Container(
          decoration: BoxDecoration(color: isActive ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withOpacity(0.4), borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}

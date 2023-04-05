import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MarketCustomError extends StatelessWidget {
  const MarketCustomError({
    super.key,
    required this.error,
    this.pngPath,
    this.svgPath,
  });
  final String error;
  final String? pngPath;
  final String? svgPath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: Image.asset(
              '$pngPath',
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '''$error''',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

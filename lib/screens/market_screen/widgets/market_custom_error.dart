import 'package:Flutterfolio/custom_widgets/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MarketCustomError extends StatelessWidget {
  const MarketCustomError({
    super.key,
    required this.error,
    this.pngPath,
  });

  final String error;
  final String? pngPath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImage(imagePath: '$pngPath', size: 150),
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

import 'package:flutter/material.dart';

import '/custom_widgets/custom_image.dart';

class MarketErrorModel extends StatelessWidget {
  const MarketErrorModel({
    super.key,
    required this.error,
    this.pngPath,
  });

  final String error;
  final String? pngPath;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImage(imagePath: '$pngPath', size: 150),
          const SizedBox(height: 24),
          Text(
            '''$error''',
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

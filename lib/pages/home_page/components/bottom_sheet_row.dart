import 'package:flutter/material.dart';

class BottomSheetRow extends StatelessWidget {
  final String title1, title2;

  const BottomSheetRow({
    Key? key,
    required this.title1,
    required this.title2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title1,
            style: textTheme.bodyMedium,
          ),
          Text(
            title2,
            style: textTheme.titleSmall!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

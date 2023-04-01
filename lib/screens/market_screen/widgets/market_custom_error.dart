import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MarketCustomError extends StatelessWidget {
  const MarketCustomError({
    super.key,
    required this.error,
  });
  final String error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/svg/error.svg',
            width: 140,
            height: 140,
            color: Colors.black.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            '''$error''',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black.withOpacity(0.4),
                ),
          ),
        ],
      ),
    );
  }
}

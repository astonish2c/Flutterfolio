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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pngPath == null
              ? SvgPicture.asset(
                  '$svgPath',
                  width: 140,
                  height: 140,
                  color: Colors.black.withOpacity(0.4),
                )
              : SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('$pngPath'),
                ),
          const SizedBox(height: 16),
          Text(
            '''$error''',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black.withOpacity(
                    0.7,
                  ),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }
}

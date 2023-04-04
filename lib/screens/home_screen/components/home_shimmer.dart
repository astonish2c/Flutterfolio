import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../custom_widgets/shimmer_skelton.dart';
import '../../market_screen/market_screen.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.primary,
      highlightColor: theme.colorScheme.onPrimary,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ShimmerSkelton(height: 180, width: double.infinity),
            const SizedBox(height: 30),
            const ShimmerSkelton(height: 20, width: 120),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: 12,
                itemBuilder: (context, index) => Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const ShimmerSkelton(
                      height: 50,
                      width: 50,
                      borderCircle: 32,
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        ShimmerSkelton(width: 60),
                        SizedBox(height: 16 / 4),
                        ShimmerSkelton(width: 30),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        ShimmerSkelton(width: 60),
                        SizedBox(height: 16 / 4),
                        ShimmerSkelton(width: 40),
                      ],
                    ),
                  ],
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

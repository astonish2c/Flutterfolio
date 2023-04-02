import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../custom_widgets/shimmer_skelton.dart';

class MarketShimmer extends StatelessWidget {
  const MarketShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue,
      highlightColor: Colors.black,
      child: Padding(
        padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerSkelton(width: 90),
                    SizedBox(height: 8),
                    ShimmerSkelton(height: 36, width: 150, borderCircle: 8),
                  ],
                ),
                const Spacer(),
                const ShimmerSkelton(height: 50, width: 70, borderCircle: 8),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: 12,
                itemBuilder: (context, index) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
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
                              SizedBox(height: 4),
                              ShimmerSkelton(width: 30),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              ShimmerSkelton(width: 60),
                              SizedBox(height: 4),
                              ShimmerSkelton(width: 60),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

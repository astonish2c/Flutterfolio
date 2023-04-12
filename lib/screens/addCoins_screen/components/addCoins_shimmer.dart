
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../custom_widgets/shimmer_skelton.dart';

class AddCoinsShimmer extends StatelessWidget {
  const AddCoinsShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.blue,
      highlightColor: Colors.black,
      child: Column(
        children: [
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
    );
  }
}

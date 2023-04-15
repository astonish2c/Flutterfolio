import 'package:flutter/material.dart';

class OnBoardingContent extends StatelessWidget {
  const OnBoardingContent({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
  });

  final String imageUrl, title, description;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      children: [
        const Spacer(),
        SizedBox(
          height: 420,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(imageUrl, fit: BoxFit.contain),
        ),
        const Spacer(),
        Text(
          title,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: theme.textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium,
        ),
        const Spacer(flex: 2),
      ],
    );
  }
}

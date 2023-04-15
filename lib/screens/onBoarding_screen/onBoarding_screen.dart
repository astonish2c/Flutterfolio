import 'package:crypto_exchange_app/main.dart';
import 'package:flutter/material.dart';

import 'data/onBoard_data.dart';
import 'widgets/dot_indicator_widget.dart';
import 'widgets/onBoard_content_widget.dart';
import 'models/onBoard_model.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;

  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: onBoardData.length,
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnBoardingContent(
                    imageUrl: onBoardData[index].imageUrl,
                    title: onBoardData[index].title,
                    description: onBoardData[index].description,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...List.generate(onBoardData.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: DotIndicator(isActive: index == _pageIndex),
                    );
                  }),
                  const Spacer(),
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_pageIndex != 3) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        } else {
                          // Navigator.pushReplacement(context, newRoute);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.onBackground,
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_right_alt,
                          size: 35,
                          color: theme.colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

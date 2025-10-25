import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '/Auth/user_auth.dart';
import 'data/onBoard_data.dart';
import 'widgets/dot_indicator_widget.dart';
import 'widgets/onBoard_content_widget.dart';

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

    bool isLastPage = !(_pageIndex < onBoardData.length - 1);

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
                  return OnBoardingContent(imageUrl: onBoardData[index].imageUrl, title: onBoardData[index].title, description: onBoardData[index].description);
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
                  ElevatedButton(
                    onPressed: () {
                      if (!isLastPage) {
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      } else {
                        // persist that onboarding was completed
                        Hive.box('configs').put('isFirstRun', false);
                        Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, animation, secondaryAnimation) => const UserAuth()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.onSurface,
                      shape: !isLastPage ? const CircleBorder() : RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: EdgeInsets.zero,
                    ),
                    child: Padding(
                      padding: !isLastPage ? const EdgeInsets.all(8) : const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Center(
                        child: !isLastPage ? Icon(Icons.arrow_right_alt, size: 30, color: theme.colorScheme.surface) : Text("Let's start", style: theme.textTheme.titleMedium!.copyWith(color: theme.colorScheme.surface)),
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

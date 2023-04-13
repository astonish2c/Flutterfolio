import 'package:crypto_exchange_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/home_screen/home_screen.dart';
import '../../../custom_widgets/custom_image.dart';
import '../../../provider/userCoins_provider.dart';
import '../../home_screen/widgets/utils.dart';
import '../widgets/helper_methods.dart';
import '../widgets/portfolio_drawerSkeleton.dart';

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final ThemeData theme = Theme.of(context);

    return Drawer(
      child: Container(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              height: 180,
              width: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 1, color: theme.colorScheme.onPrimaryContainer),
              ),
              child: const CustomImage(imagePath: 'assets/images/thinking.png'),
            ),
            const SizedBox(height: 12),
            Text('${user?.email}'),
            const SizedBox(height: 48),
            PortfolioDrawerSkeleton(
              text: 'Report a bug',
              icon: Icons.report,
              onClicked: () {
                launchEmail();
              },
            ),
            const SizedBox(height: 8),
            PortfolioDrawerSkeleton(
              text: 'Sign out',
              icon: Icons.logout_rounded,
              onClicked: () async {
                try {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    context.read<UserCoinsProvider>().resetUser();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: ((context) => const HomeScreen())));
                  }
                } on FirebaseAuthException catch (e) {
                  Utils.showSnackBar(e.message);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

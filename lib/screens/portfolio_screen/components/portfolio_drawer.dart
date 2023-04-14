import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/screens/home_screen/password_reset_screen.dart';
import '/screens/home_screen/home_screen.dart';
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
      child: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15.0),
          children: [
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Email: ',
                  style: theme.textTheme.titleMedium,
                ),
                Text('${user?.email}'),
              ],
            ),
            const SizedBox(height: 48),
            PortfolioDrawerSkeleton(
              text: 'Change password',
              icon: Icons.mode_edit_outline_rounded,
              onClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PasswordResetScreen(),
                  ),
                );
              },
            ),
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
                    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
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

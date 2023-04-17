import 'package:Flutterfolio/Auth/user_auth.dart';
import 'package:Flutterfolio/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Auth/screens/reset_password_screen/reset_password_screen.dart';
import '../../../Auth/widgets/utils.dart';
import '../../../provider/userCoins_provider.dart';
import '../widgets/helper_methods.dart';
import '../widgets/portfolio_drawerSkeleton.dart';

class PortfolioDrawer extends StatelessWidget {
  const PortfolioDrawer({super.key, required this.scaffoldKey});

  final GlobalKey<ScaffoldState> scaffoldKey;
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
            const Divider(thickness: 0.5),
            PortfolioDrawerSkeleton(
              text: 'Change password',
              icon: Icons.mode_edit_outline_rounded,
              onClicked: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResetPasswordScreen(scaffoldKey: scaffoldKey)),
                );
              },
            ),
            const Divider(thickness: 0.5),
            PortfolioDrawerSkeleton(
              text: 'Report a bug',
              icon: Icons.report,
              onClicked: () {
                launchEmail();
              },
            ),
            const Divider(thickness: 0.5),
            const SizedBox(height: 8),
            PortfolioDrawerSkeleton(
              text: 'Sign out',
              icon: Icons.logout_rounded,
              onClicked: () async {
                try {
                  navigatorKey.currentState!.pop();
                  context.read<UserCoinsProvider>().resetUser();
                  await FirebaseAuth.instance.signOut();
                } on FirebaseAuthException catch (e) {
                  Utils.showSnackBar(e.message);
                }
              },
            ),
            const Divider(thickness: 0.5),
          ],
        ),
      ),
    );
  }
}

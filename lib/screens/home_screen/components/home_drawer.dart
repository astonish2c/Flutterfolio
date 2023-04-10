import 'package:crypto_exchange_app/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../sign_in_screen/widgets/utils.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;
    final ThemeData theme = Theme.of(context);

    return Drawer(
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Container(
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
                  child: Image.asset('assets/images/thinking.png', color: theme.colorScheme.onPrimaryContainer),
                ),
                const SizedBox(height: 12),
                Text('${user?.email}'),
                const SizedBox(height: 12),
                MenuItem(
                  text: 'Notifications',
                  icon: Icons.notifications_outlined,
                  onClicked: () {},
                ),
                MenuItem(
                  text: 'Updates',
                  icon: Icons.update,
                  onClicked: () {},
                ),
                MenuItem(
                  text: 'Report a bug',
                  icon: Icons.report,
                  onClicked: () {},
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 8),
                MenuItem(
                  text: 'Sign out',
                  icon: Icons.logout_rounded,
                  onClicked: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      if (context.mounted) {
                        Navigator.popAndPushNamed(context, HomePage.routeName);
                      }
                    } on FirebaseAuthException catch (e) {
                      Utils.showSnackBar(e.message);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onClicked;

  const MenuItem({
    required this.text,
    required this.icon,
    this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: onClicked,
    );
  }
}

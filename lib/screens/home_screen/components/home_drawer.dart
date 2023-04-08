import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
          ),
          child: Text('Logged in as: ${user!.email}'),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log out'),
            style: ButtonStyle(shape: MaterialStateProperty.all(const RoundedRectangleBorder())),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
              } on Exception catch (e) {
                print(e);
              }
            },
          ),
        ),
      ],
    );
  }
}

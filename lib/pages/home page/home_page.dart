// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, iterable_contains_unrelated_type, unnecessary_nullable_for_final_variable_declarations
import 'package:flutter/material.dart';

import '../../utils/scaffold_bg.dart';
import '../../utils/nav_bar.dart';
import 'components/home_app_bar.dart';
import 'home_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldBG(
      child: Scaffold(
        appBar: HomeAppBar(),
        body: HomeWidget(),
        bottomNavigationBar: NavBar(currentIndex: 0),
      ),
    );
  }
}

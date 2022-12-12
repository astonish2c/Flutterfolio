// import 'package:flutter/material.dart';

// // Define the page route for the next page
// final pageRoute = PageRouteBuilder(
//   // Set the transition duration
//   transitionDuration: const Duration(milliseconds: 500),
//   // Define the page transition animation
//   pageBuilder: (context, animation, secondaryAnimation) => NextPage(),
//   transitionsBuilder: (context, animation, secondaryAnimation, child) {
//     // Define the animation for the page entrance
//     var begin = Offset(0.0, 1.0);
//     var end = Offset.zero;
//     var curve = Curves.ease;

//     var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

//     return SlideTransition(
//       position: animation.drive(tween),
//       child: child,
//     );
//   },
// );

// // Use pushNamed to navigate to the next page with the custom page route
// Navigator.of(context).pushNamed('/next-page', arguments: pageRoute);

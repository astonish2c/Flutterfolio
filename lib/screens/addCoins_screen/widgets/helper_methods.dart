import 'package:crypto_exchange_app/provider/allCoins_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home_screen/widgets/utils.dart';

Future<void> checkDbStatus({required BuildContext context}) async {
  final bool isDatabaseAvailable = context.read<AllCoinsProvider>().isDatabaseAvailable;

  if (isDatabaseAvailable) return;

  try {
    await context.read<AllCoinsProvider>().getApiCoins();
  } catch (e) {
    Utils.showSnackBar(e.toString());
  }
}
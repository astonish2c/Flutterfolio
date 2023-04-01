import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/data_provider.dart';

Future<void> checkDbStatus({required BuildContext context}) async {
  final bool isDatabaseAvailable = context.read<DataProvider>().isDatabaseAvailable;

  if (isDatabaseAvailable) return;

  try {
    await context.read<DataProvider>().getApiCoins();
  } catch (e) {
    print(e);
  }
}

import 'package:crypto_exchange_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HomeAppBar extends StatelessWidget with PreferredSizeWidget {
  const HomeAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      toolbarHeight: 60,
      leading: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () {},
        icon: SvgPicture.asset(
          'assets/icons/wallet.svg',
          color: Colors.white,
          height: 30,
          width: 30,
        ),
      ),
      title: const Text(
        'CryptoLand',
        style: TextStyle(
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            //Notification btn
            SizedBox(
              height: 30,
              width: 30,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {},
                icon: SvgPicture.asset(
                  'assets/icons/circle_notification.svg',
                  color: Colors.white,
                ),
              ),
            ),
            //Red Dot
            Positioned(
              right: 0,
              top: 15,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
                  border: Border.all(color: Colors.white, width: 2),
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: defaultPadding,
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

class AppBarPrimary extends AppBar {
  AppBarPrimary({
    Key? key,
    required BuildContext context,
  }) : super(
          key: key,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                AppConstant.imageLogo,
                height: 18,
              ),
              const SizedBox(width: 10),
              Text(
                "Social",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
}

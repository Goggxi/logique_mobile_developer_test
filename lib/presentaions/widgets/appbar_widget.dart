import 'package:flutter/material.dart';
import 'package:logique_mobile_developer_test/utils/utils.dart';

class AppBarPrimary extends AppBar {
  AppBarPrimary({
    Key? key,
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
              const Text(
                "Social",
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
}

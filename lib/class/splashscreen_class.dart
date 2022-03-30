import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../style/style.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({
    Key? key,
    required this.mediaQueryData,
    required PackageInfo packageInfo,
  })  : _packageInfo = packageInfo,
        super(key: key);

  final MediaQueryData mediaQueryData;
  final PackageInfo _packageInfo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
          ),
          Image.asset(
            "assets/logo/logo.png",
            width: mediaQueryData.size.width * 0.4,
            height: mediaQueryData.size.height * 0.4,
          ),
          Text(
            'Inventory App',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.25),
          ),
          Text(
            _packageInfo.version,
            style: const TextStyle(color: subtitleText),
          )
        ],
      ),
    );
  }
}

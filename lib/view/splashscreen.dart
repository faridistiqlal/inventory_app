import 'package:flutter/material.dart';
import 'dart:async';
import 'package:inventory_app/view/login_page.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../class/splashscreen_class.dart';
import '../style/style.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 3);
    return Timer(
      duration,
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) {
              return const LoginPage(); //masuk halaman login
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startSplashScreen();
    _initPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: bgCOlor,
      body: SplashScreenView(
        mediaQueryData: mediaQueryData,
        packageInfo: _packageInfo,
      ),
    );
  }
}

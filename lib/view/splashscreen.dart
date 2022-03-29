import 'package:flutter/material.dart';
import 'dart:async';
import 'package:inventory_app/view/login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
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
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFffffff),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
            ),
            Image.asset(
              "assets/logo/logokendal.png",
              width: mediaQueryData.size.width * 0.3,
              height: mediaQueryData.size.height * 0.3,
            ),
            Padding(
              padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.17),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/logokendal.png',
                  width: 50.0,
                  height: 50.0,
                ),
                const Text(
                  " Pemerintah \n Kabupaten Kendal",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

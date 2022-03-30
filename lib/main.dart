// import 'package:flutter/material.dart';
// import 'package:inventory_app/view/splashscreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Inventory App',
//       theme: ThemeData.light(),
//       home: const SplashScreen(),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:inventory_app/view/splashscreen.dart';
import 'package:provider/provider.dart';

import 'style/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return MaterialApp(
            title: "Flutter Provider",
            debugShowCheckedModeBanner: false,
            theme: notifier.darkTheme ? dark : light,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

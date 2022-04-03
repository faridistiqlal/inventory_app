import 'package:flutter/material.dart';
import 'package:inventory_app/style/style.dart';
import 'package:inventory_app/style/theme_provider.dart';
import 'package:provider/provider.dart';

class HeaderLogin extends StatelessWidget {
  const HeaderLogin({
    Key? key,
    required this.mediaQueryData,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Consumer<ThemeNotifier>(
          builder: (context, notifier, child) => notifier.darkTheme
              ? Container(
                  width: mediaQueryData.size.width,
                  height: mediaQueryData.size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 34, 33, 33),
                    // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                )
              : Container(
                  width: mediaQueryData.size.width,
                  height: mediaQueryData.size.height * 0.2,
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                    // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //     vertical: defaultPadding * 4,
        //     horizontal: defaultPadding * 2,
        //   ),
        //   child: Text(
        //     "Login User",
        //     style: Theme.of(context).textTheme.headline5?.copyWith(
        //         // color: ,
        //         fontWeight: FontWeight.w700,
        //         fontSize: 30),
        //   ),
        // ),
        Positioned(
          top: mediaQueryData.size.height * 0.01,
          left: mediaQueryData.size.height * 0.03,
          child: Image.asset(
            'assets/logo/person2.png',
            width: mediaQueryData.size.height * 0.7,
            height: mediaQueryData.size.width * 0.7,
          ),
        ),
      ],
    );
  }
}

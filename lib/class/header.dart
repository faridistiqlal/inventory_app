import 'package:flutter/material.dart';
import 'package:inventory_app/style/style.dart';
// import 'package:inventory_app/style/theme_provider.dart';
// import 'package:provider/provider.dart';

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
        // Consumer<ThemeNotifier>(
        //   builder: (context, notifier, child) => notifier.darkTheme
        //       ? Container(
        //           width: mediaQueryData.size.width,
        //           height: mediaQueryData.size.height * 0.2,
        //           decoration: const BoxDecoration(
        //             color: Color.fromARGB(255, 34, 33, 33),
        //           ),
        //         )
        //       :
        Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.4,
          decoration: const BoxDecoration(
            color: Colors.amber,
          ),
        ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 7,
            horizontal: defaultPadding * 2,
          ),
          child: Text(
            "Inventory\nApp",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                // color: ,
                fontWeight: FontWeight.w700,
                fontSize: 30),
          ),
        ),
        Positioned(
          top: mediaQueryData.size.height * 0.05,
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

class HeaderAdmin extends StatelessWidget {
  const HeaderAdmin({
    Key? key,
    required this.mediaQueryData,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.4,
          decoration: const BoxDecoration(
            color: primaryColor,
          ),
        ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 3,
            horizontal: defaultPadding * 2,
          ),
          child: Text(
            "Cari\nSparepart",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                // color: ,
                fontWeight: FontWeight.w700,
                fontSize: 30),
          ),
        ),
        Positioned(
          top: mediaQueryData.size.height * 0.01,
          left: mediaQueryData.size.height * 0.03,
          child: Image.asset(
            'assets/logo/logo6.png',
            width: mediaQueryData.size.height * 0.7,
            height: mediaQueryData.size.width * 0.7,
          ),
        ),
      ],
    );
  }
}

class HeaderAddSparepart extends StatelessWidget {
  const HeaderAddSparepart({
    Key? key,
    required this.mediaQueryData,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: mediaQueryData.size.height,
          height: mediaQueryData.size.height * 0.4,
          decoration: const BoxDecoration(
            color: primaryColor,
          ),
          // child: Column(
          //   children: <Widget>[
          //     _inputuser(),

          //   ],
          // ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 6,
            horizontal: defaultPadding * 2,
          ),
          child: Text(
            "Tambah\nSparepart",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                // color: ,
                fontWeight: FontWeight.w700,
                fontSize: 30),
          ),
        ),
        Positioned(
          top: mediaQueryData.size.height * 0.05,
          left: mediaQueryData.size.height * 0.03,
          child: Image.asset(
            'assets/logo/person1.png',
            width: mediaQueryData.size.height * 0.7,
            height: mediaQueryData.size.width * 0.7,
          ),
        ),
      ],
    );
  }
}

class HeaderMekanik extends StatelessWidget {
  const HeaderMekanik({
    Key? key,
    required this.mediaQueryData,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.4,
          decoration: const BoxDecoration(
            color: bgMekanik,
          ),
        ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 3,
            horizontal: defaultPadding * 2,
          ),
          child: Text(
            "Dashboard\nSparepart",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                color: bgCOlor, fontWeight: FontWeight.w700, fontSize: 30),
          ),
        ),
        Positioned(
          top: mediaQueryData.size.height * 0.01,
          left: mediaQueryData.size.height * 0.03,
          child: Image.asset(
            'assets/logo/person1.png',
            width: mediaQueryData.size.height * 0.7,
            height: mediaQueryData.size.width * 0.7,
          ),
        ),
      ],
    );
  }
}

class HeaderInputSparepart extends StatelessWidget {
  const HeaderInputSparepart({
    Key? key,
    required this.mediaQueryData,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.4,
          decoration: const BoxDecoration(
            color: bgMekanik,
          ),
        ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 3,
            horizontal: defaultPadding * 2,
          ),
          child: Text(
            "Input\nSparepart",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                color: bgCOlor, fontWeight: FontWeight.w700, fontSize: 30),
          ),
        ),
        Positioned(
          top: mediaQueryData.size.height * 0.01,
          left: mediaQueryData.size.height * 0.03,
          child: Image.asset(
            'assets/logo/person1.png',
            width: mediaQueryData.size.height * 0.7,
            height: mediaQueryData.size.width * 0.7,
          ),
        ),
      ],
    );
  }
}

class HeaderPemimpin extends StatelessWidget {
  const HeaderPemimpin({
    Key? key,
    required this.mediaQueryData,
  }) : super(key: key);

  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: mediaQueryData.size.width,
          height: mediaQueryData.size.height * 0.4,
          decoration: BoxDecoration(
            color: Colors.red[400],
          ),
        ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: defaultPadding * 3,
            horizontal: defaultPadding * 2,
          ),
          child: Text(
            "Dashboard\nInventory",
            style: Theme.of(context).textTheme.headline5?.copyWith(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 30),
          ),
        ),
        Positioned(
          top: mediaQueryData.size.height * 0.01,
          left: mediaQueryData.size.height * 0.03,
          child: Image.asset(
            'assets/logo/person3.png',
            width: mediaQueryData.size.height * 0.7,
            height: mediaQueryData.size.width * 0.7,
          ),
        ),
      ],
    );
  }
}

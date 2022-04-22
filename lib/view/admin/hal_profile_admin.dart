import 'package:flutter/material.dart';

class HalProfilAdmin extends StatefulWidget {
  const HalProfilAdmin({Key? key}) : super(key: key);

  @override
  State<HalProfilAdmin> createState() => _HalProfilAdminState();
}

class _HalProfilAdminState extends State<HalProfilAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      title: const Text(
        'Admin',
      ),
      elevation: 0,
    ));
  }
}

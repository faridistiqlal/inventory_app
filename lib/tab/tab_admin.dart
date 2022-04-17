import 'package:flutter/material.dart';

import 'package:inventory_app/view/admin/hal_admin.dart' as admin;
import 'package:inventory_app/view/admin/hal_users_admin.dart' as useradmin;
import 'package:inventory_app/view/admin/hal_profile_admin.dart'
    as profileadmin;

class HalTabAdmin extends StatefulWidget {
  const HalTabAdmin({Key? key}) : super(key: key);

  @override
  _HalTabAdminState createState() => _HalTabAdminState();
}

class _HalTabAdminState extends State<HalTabAdmin> {
  int _currentIndex = 0;
  final tabs = [
    const admin.HalAdmin(),
    const useradmin.HalUsersAdmin(),
    const profileadmin.HalProfilAdmin(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        //backgroundColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.storage_rounded,
                // color: Color(0xFF44AEA5),
              ),
              icon: Icon(Icons.storage_rounded),
              label: 'Master'
              // backgroundColor: Colors.blue,
              ),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.people_alt_rounded,
                // color: Color(0xFF44AEA5),
              ),
              icon: Icon(
                Icons.people_alt_rounded,
                // color: Color(0xFF44AEA5),
              ),
              label: 'User'),
          BottomNavigationBarItem(
              activeIcon: Icon(
                Icons.account_circle,
                // color: Color(0xFF44AEA5),
              ),
              icon: Icon(
                Icons.account_circle,
                // color: Color(0xFF44AEA5),
              ),
              label: 'Profil'),
        ],
        onTap: (index) {
          if (index != 3) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          }
        },
      ),
    );
  }
}

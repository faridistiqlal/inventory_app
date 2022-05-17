import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inventory_app/function/add_sparepart.dart';
import 'package:inventory_app/tab/tab_admin.dart';
import 'package:inventory_app/view/admin/detail/detail_sparepart.dart';
import 'package:inventory_app/view/admin/hal_admin.dart';
import 'package:inventory_app/view/admin/hal_profile_admin.dart';
import 'package:inventory_app/view/admin/menuadmin/hal_sparepart.dart';
import 'package:inventory_app/view/cek.dart';
import 'package:inventory_app/view/login_page.dart';
import 'package:inventory_app/view/mekanik/hal_mekanik.dart';
import 'package:inventory_app/view/mekanik/input/post_request_sparepart.dart';
import 'package:inventory_app/view/pimpinan/detail/detail_filter_request.dart';
import 'package:inventory_app/view/pimpinan/detail/detail_filter_sparepart.dart';
import 'package:inventory_app/view/pimpinan/hal_pimpinan_laporan_request.dart';
import 'package:inventory_app/view/pimpinan/hal_pimpinan_laporan_sparepart.dart';
import 'package:inventory_app/view/pimpinan/hal_pimpinan_request.dart';
import 'package:inventory_app/view/pimpinan/hal_pimpinan_sparepart.dart';
import 'package:inventory_app/view/pimpinan/hal_pimpinan.dart';
import 'package:inventory_app/view/splashscreen.dart';

import 'view/pimpinan/detail/detail_pimpinan_request.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: const Color.fromARGB(255, 248, 161, 30),
      colorScheme: const ColorScheme.light()
          .copyWith(primary: const Color.fromARGB(255, 248, 161, 30)),
    ),
    debugShowCheckedModeBanner: false,
    title: 'Inventory App',
    routes: <String, WidgetBuilder>{
      '/FilterPimpinanLaporanSparepart': (BuildContext context) =>
          const FilterPimpinanLaporanSparepart(
            dTglAwal: '',
            dTglAkhir: '',
            dStatus: '',
          ),
      '/FilterPimpinanLaporanRequest': (BuildContext context) =>
          const FilterPimpinanLaporanRequest(
            dTglAwal: '',
            dTglAkhir: '',
            dStatus: '',
          ),
      '/HalAdmin': (BuildContext context) => const HalAdmin(),
      '/MyHomePage': (BuildContext context) => MyHomePage(),
      '/LoginPage': (BuildContext context) => const LoginPage(),
      '/HalTabAdmin': (BuildContext context) => const HalTabAdmin(),
      '/HalProfilAdmin': (BuildContext context) => const HalProfilAdmin(),
      '/HalSparepart': (BuildContext context) => const HalSparepart(),
      '/AddSparepart': (BuildContext context) => const AddSparepart(),
      '/HalMekanik': (BuildContext context) => const HalMekanik(),
      '/DetailListSparepart': (BuildContext context) =>
          const DetailListSparepart(
            dKode: '',
          ),
      '/HalPimpinanLaporanSparepart': (BuildContext context) =>
          const HalPimpinanLaporanSparepart(),
      '/HalPimpinanLaporanRequest': (BuildContext context) =>
          const HalPimpinanLaporanRequest(),
      '/HalRequestMekanikList': (BuildContext context) =>
          const HalRequestMekanikList(),
      '/HalMesinMekanik': (BuildContext context) => const HalMesinMekanik(),
      '/HalMesinMekanikList': (BuildContext context) =>
          const HalMesinMekanikList(),
      '/PostRequestSparepart': (BuildContext context) =>
          const PostRequestSparepart(),
      '/DetailSparepart': (BuildContext context) => const DetailSparepart(
            dId: '',
          ),
    },
    home: const SplashScreen(),
  ));
}

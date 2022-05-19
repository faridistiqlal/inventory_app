import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';
import 'package:inventory_app/style/style.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import '../../class/header.dart';

class HalMesinMekanik extends StatefulWidget {
  const HalMesinMekanik({Key? key}) : super(key: key);

  @override
  State<HalMesinMekanik> createState() => _HalMesinMekanikState();
}

class _HalMesinMekanikState extends State<HalMesinMekanik> {
  //NOTE Variable
  var formatedTanggal = DateFormat('yyyy-dd-MM').format(DateTime.now());
  List? dataJSON;
  List? laporanbydateJSON;
  List? topkeluardateJSON;
  List? topmasukdateJSON;
  var isloading = false;
  int? barangmasuk;
  int? barangkeluar;
  int? barangreturn;
  int? reqproses;
  int? reqselesai;
  int? reqtotal;
// ignore: unused_field
  bool _isLoggedIn = false;

//LINK Post laporan by date
  void laporanbyDate() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/laporanbydate';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      "tanggalawal": 'all',
      "tanggalakhir": 'all',
    });
    var laporanbydateJSON = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(
        () {
          barangmasuk = laporanbydateJSON['barangmasuk'];
          barangkeluar = laporanbydateJSON['barangkeluar'];
          barangreturn = laporanbydateJSON['barangreturn'];
          reqproses = laporanbydateJSON['reqproses'];
          reqselesai = laporanbydateJSON['reqselesai'];
          reqtotal = laporanbydateJSON['reqtotal'];
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print(laporanbydateJSON);
      print(formatedTanggal.toString());
    }
  }

//LINK Get Sparepart
  Future<dynamic> getSparepart() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/sperpart';
    final res = await http.get(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
    );
    if (res.statusCode == 200) {
      setState(
        () {
          dataJSON = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print(dataJSON);
    }
  }

//LINK Post Top Sparepart Masuk
  Future<dynamic> topsparepartmasuk() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/topbarang';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      "arus": "1"
    });
    if (res.statusCode == 200) {
      setState(
        () {
          topmasukdateJSON = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print(topmasukdateJSON);
    }
  }

//LINK Post Top Sparepart Keluar
  Future<dynamic> topsparepartkeluar() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/topbarang';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      "arus": "2"
    });
    if (res.statusCode == 200) {
      setState(
        () {
          topkeluardateJSON = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print(topkeluardateJSON);
    }
  }

//NOTE Cek Logout
  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      Navigator.pushReplacementNamed(context, '/LoginPage');
    } else {
      _isLoggedIn = true;
    }
  }

//NOTE Auto run fungsi
  @override
  void initState() {
    getSparepart();
    topsparepartkeluar();
    topsparepartmasuk();
    laporanbyDate();
    super.initState();
  }

//NOTE Scaffold
  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pimpinan',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(),
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          logoutbutton(),
        ],
      ),
      body: Stack(
        children: [
          HeaderPemimpin(mediaQueryData: mediaQueryData),
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.17),
            decoration: BoxDecoration(
              color: bgCOlor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  cardStock(),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.01,
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          laporanspareart(),
                          laporanrequest(),
                        ],
                      ),
                      Row(
                        children: [
                          laporanassembly(),
                        ],
                      ),
                    ],
                  ),
                  _topsparepartmasuk(),
                  _topsparepartkeluar(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //NOTE //////////////////// WIDGET ///////////////////////////////////////////////////////////////////
  Widget laporanassembly() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: mediaQueryData.size.width * 0.47,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Material(
          color: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/HalPimpinanLaporanAssembly');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const FaIcon(
                    FontAwesomeIcons.puzzlePiece,
                    color: Colors.white,
                    size: 35,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.01,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Laporan\nAssembly', //IBADAH
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.02,
                    ),
                  ),
                  Text(
                    "Tap to view",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget laporanrequest() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: mediaQueryData.size.width * 0.47,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Material(
          color: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/HalPimpinanLaporanRequest');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const FaIcon(
                    FontAwesomeIcons.fileImport,
                    color: Colors.white,
                    size: 35,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.01,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Laporan\nRequest', //IBADAH
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.02,
                    ),
                  ),
                  Text(
                    "Tap to view",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget laporanspareart() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: mediaQueryData.size.width * 0.47,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Material(
          color: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/HalPimpinanLaporanSparepart');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const FaIcon(
                    FontAwesomeIcons.gears,
                    color: Colors.white,
                    size: 35,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.01,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        'Laporan\nSparepart', //IBADAH
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: mediaQueryData.size.height * 0.02,
                    ),
                  ),
                  Text(
                    "Tap to view",
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget logoutbutton() {
    return IconButton(
      icon: Icon(
        Icons.logout,
        color: Colors.brown[800],
      ),
      onPressed: () {
        Dialogs.materialDialog(
          msg: 'Anda yakin ingin keluar aplikasi?',
          title: "Keluar",
          color: Colors.white,
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.pop(context);
              },
              text: 'Tidak',
              iconData: Icons.cancel_outlined,
              textStyle: const TextStyle(color: Colors.grey),
              iconColor: Colors.grey,
            ),
            IconsButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();
                _cekLogout();
                Navigator.pop(context);
              },
              text: 'Exit',
              iconData: Icons.exit_to_app,
              color: Colors.red,
              textStyle: const TextStyle(color: Colors.white),
              iconColor: Colors.white,
            ),
          ],
        );
      },
    );
  }

  Widget cardStock() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return isloading
        ? _buildProgressIndicator()
        : Container(
            height: mediaQueryData.size.height * 0.12,
            width: mediaQueryData.size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0.0, 5.0),
                    blurRadius: 7.0),
              ],
            ),
            child: Material(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: <Widget>[
                              Text(
                                "$barangmasuk",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Barang\nMasuk',
                                style: TextStyle(
                                  color: Color(0xFF2e2e2e),
                                  fontSize: 13.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "$barangkeluar",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Barang\nKeluar',
                                style: TextStyle(
                                  color: Color(0xFF2e2e2e),
                                  fontSize: 13.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "$barangreturn",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Barang\nReturn',
                                style: TextStyle(
                                  color: Color(0xFF2e2e2e),
                                  fontSize: 13.0,
                                ),
                              )
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                "$reqproses",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              const Text(
                                'Request\nProses',
                                style: TextStyle(
                                  color: Color(0xFF2e2e2e),
                                  fontSize: 13.0,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildProgressIndicator() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    // SizeConfig().init(context);
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: Shimmer.fromColors(
        direction: ShimmerDirection.ltr,
        highlightColor: Colors.white,
        baseColor: const Color.fromARGB(255, 201, 191, 191),
        child: Container(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey,
                    ),
                    height: mediaQueryData.size.height * 0.14,
                    width: mediaQueryData.size.width,
                    // color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _topsparepartmasuk() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return _isLoggedIn
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.only(
              // left: mediaQueryData.size.height * 0.005,
              // right: mediaQueryData.size.height * 0.005,
              // bottom: mediaQueryData.size.height * 0.01,
              top: mediaQueryData.size.height * 0.01,
            ),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: mediaQueryData.size.height * 0.05,
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.01,
                      // bottom: mediaQueryData.size.height * 0.01,
                      // top: mediaQueryData.size.height * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue[800],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Top Sparepart Masuk",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          color: Colors.white,
                          iconSize: 25.0,
                          onPressed: () {
                            Navigator.pushNamed(context, '/MyHomePage');
                          },
                        ),
                      ],
                    ),
                  ),
                  topsparepartlist(),
                  const SizedBox(),
                  Container(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.01,
                      bottom: mediaQueryData.size.height * 0.01,
                      top: mediaQueryData.size.height * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: <Widget>[
                          const Icon(
                            Icons.info_outline,
                            size: 12,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: mediaQueryData.size.height * 0.005),
                          ),
                          const Text(
                            'Data Sparepart',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ]),
                        Text(
                          formatedTanggal.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _topsparepartkeluar() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return _isLoggedIn
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Container(
            padding: EdgeInsets.only(
              // left: mediaQueryData.size.height * 0.005,
              // right: mediaQueryData.size.height * 0.005,
              // bottom: mediaQueryData.size.height * 0.01,
              top: mediaQueryData.size.height * 0.01,
            ),
            child: Card(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: mediaQueryData.size.height * 0.05,
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.01,
                      // bottom: mediaQueryData.size.height * 0.01,
                      // top: mediaQueryData.size.height * 0.02,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Top Sparepart Keluar",
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.open_in_new),
                          color: Colors.white,
                          iconSize: 25.0,
                          onPressed: () {
                            Navigator.pushNamed(context, '/DetailKesehatan');
                          },
                        ),
                      ],
                    ),
                  ),
                  topsparepartlistkeluar(),
                  const SizedBox(),
                  Container(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.01,
                      bottom: mediaQueryData.size.height * 0.01,
                      top: mediaQueryData.size.height * 0.01,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: <Widget>[
                          const Icon(
                            Icons.info_outline,
                            size: 12,
                            color: Colors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                left: mediaQueryData.size.height * 0.005),
                          ),
                          const Text(
                            'Data Sparepart',
                            style: TextStyle(
                              fontSize: 10,
                            ),
                          ),
                        ]),
                        Text(
                          formatedTanggal.toString(),
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  Widget topsparepartlist() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: topmasukdateJSON == null ? 0 : topmasukdateJSON?.length,
      itemBuilder: (BuildContext context, int i) {
        if (topmasukdateJSON?[i]["id"] == "NotFound") {
          return Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.notes_sharp,
                  size: 150,
                  color: Colors.grey[300],
                ),
                Text(
                  "Tidak ada Sparepart",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
          );
        } else {
          // ignore: prefer_typing_uninitialized_variables
          var arus;
          if (topmasukdateJSON?[i]["arus"] == '1') {
            arus = Container(
              width: mediaQueryData.size.height * 0.1,
              // margin: const EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.005,
                left: mediaQueryData.size.height * 0.005,
                right: mediaQueryData.size.height * 0.005,
                bottom: mediaQueryData.size.height * 0.005,
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              // margin: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.inbox,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.height * 0.01,
                  ),
                  const Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            );
          } else if (topmasukdateJSON?[i]["arus"] == '2') {
            arus = Container(
              width: mediaQueryData.size.height * 0.1,
              // margin: const EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.005,
                left: mediaQueryData.size.height * 0.005,
                right: mediaQueryData.size.height * 0.005,
                bottom: mediaQueryData.size.height * 0.005,
              ),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              // margin: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.outbox_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.height * 0.01,
                  ),
                  const Text(
                    "Keluar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            );
          } else {
            arus = Container(
              width: mediaQueryData.size.height * 0.1,
              // margin: const EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.005,
                left: mediaQueryData.size.height * 0.005,
                right: mediaQueryData.size.height * 0.005,
                bottom: mediaQueryData.size.height * 0.005,
              ),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              // margin: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_backup_restore_sharp,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.height * 0.01,
                  ),
                  const Text(
                    "Return",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            padding: EdgeInsets.only(
              top: mediaQueryData.size.height * 0.01,
              left: mediaQueryData.size.height * 0.01,
              right: mediaQueryData.size.height * 0.01,
              bottom: mediaQueryData.size.height * 0.005,
            ),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  // elevation: 1.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            width: mediaQueryData.size.height * 0.15,
                            height: mediaQueryData.size.height * 0.11,
                            child: topmasukdateJSON?[i]['foto'] != null
                                ? CachedNetworkImage(
                                    imageUrl: topmasukdateJSON?[i]['foto'],
                                    placeholder: (context, url) => Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/logo/22.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    height: 150.0,
                                    width: 110.0,
                                  )
                                : Image.asset(
                                    'assets/logo/22.png',
                                    // width: mediaQueryData.size.height * 0.7,
                                    // height: mediaQueryData.size.width * 0.7,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 5.0, bottom: 10.0),
                                  child: Text(
                                    topmasukdateJSON?[i]['sperpart'],
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                arus,
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: topmasukdateJSON?[i]['jumlah'] != null
                                      ? Text(
                                          'Jumlah : ' +
                                              topmasukdateJSON?[i]['jumlah'],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider()
              ],
            ),
          );
        }
      },
    );
  }

  Widget topsparepartlistkeluar() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: topkeluardateJSON == null ? 0 : topkeluardateJSON?.length,
      itemBuilder: (BuildContext context, int i) {
        if (topkeluardateJSON?[i]["id"] == "NotFound") {
          return Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.notes_sharp,
                  size: 150,
                  color: Colors.grey[300],
                ),
                Text(
                  "Tidak ada Sparepart",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
          );
        } else {
          // ignore: prefer_typing_uninitialized_variables
          var arus;
          if (topkeluardateJSON?[i]["arus"] == '1') {
            arus = Container(
              width: mediaQueryData.size.height * 0.1,
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.005,
                left: mediaQueryData.size.height * 0.005,
                right: mediaQueryData.size.height * 0.005,
                bottom: mediaQueryData.size.height * 0.005,
              ),
              decoration: const BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.inbox,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.height * 0.01,
                  ),
                  const Text(
                    "Masuk",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            );
          } else if (topkeluardateJSON?[i]["arus"] == '2') {
            arus = Container(
              width: mediaQueryData.size.height * 0.1,
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.005,
                left: mediaQueryData.size.height * 0.005,
                right: mediaQueryData.size.height * 0.005,
                bottom: mediaQueryData.size.height * 0.005,
              ),
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.outbox_rounded,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.height * 0.01,
                  ),
                  const Text(
                    "Keluar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            );
          } else {
            arus = Container(
              width: mediaQueryData.size.height * 0.1,
              // margin: const EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.005,
                left: mediaQueryData.size.height * 0.005,
                right: mediaQueryData.size.height * 0.005,
                bottom: mediaQueryData.size.height * 0.005,
              ),
              decoration: const BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              // margin: const EdgeInsets.only(top: 10.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.settings_backup_restore_sharp,
                    color: Colors.white,
                    size: 14,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.height * 0.01,
                  ),
                  const Text(
                    "Return",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(
            padding: EdgeInsets.only(
              top: mediaQueryData.size.height * 0.01,
              left: mediaQueryData.size.height * 0.01,
              right: mediaQueryData.size.height * 0.01,
              bottom: mediaQueryData.size.height * 0.005,
            ),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  // elevation: 1.0,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(right: 15.0),
                            width: mediaQueryData.size.height * 0.15,
                            height: mediaQueryData.size.height * 0.11,
                            child: topmasukdateJSON?[i]['foto'] != null
                                ? CachedNetworkImage(
                                    imageUrl: topkeluardateJSON?[i]['foto'],
                                    placeholder: (context, url) => Container(
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(
                                            "assets/logo/22.png",
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    fit: BoxFit.cover,
                                    height: 150.0,
                                    width: 110.0,
                                  )
                                : Image.asset(
                                    'assets/logo/22.png',
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 5.0, bottom: 10.0),
                                  child: Text(
                                    topkeluardateJSON?[i]['sperpart'],
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      //fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                                arus,
                                Container(
                                  margin: const EdgeInsets.only(top: 5.0),
                                  child: topkeluardateJSON?[i]['jumlah'] != null
                                      ? Text(
                                          'Jumlah : ' +
                                              topkeluardateJSON?[i]['jumlah'],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Divider()
              ],
            ),
          );
        }
      },
    );
  }

  Widget shimmerinventory() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: EdgeInsets.only(
        top: mediaQueryData.size.height * 0.01,
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Shimmer.fromColors(
          highlightColor: Colors.white,
          baseColor: const Color.fromARGB(255, 216, 216, 216),
          child: Column(
            children: <Widget>[
              Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.12,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              SizedBox(
                height: mediaQueryData.size.height * 0.01,
              ),
              Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.12,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              SizedBox(
                height: mediaQueryData.size.height * 0.01,
              ),
              Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.12,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              SizedBox(
                height: mediaQueryData.size.height * 0.01,
              ),
              Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.12,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ListSparepart extends StatelessWidget {
  const ListSparepart({
    Key? key,
    required this.dataJSON,
    required this.mediaQueryData,
  }) : super(key: key);

  final List? dataJSON;
  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataJSON == null ? 0 : dataJSON?.length,
      itemBuilder: (BuildContext context, int i) {
        if (dataJSON?[i]["id"] == null) {
          return Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.calendar_today,
                  size: 150,
                  color: Colors.grey[300],
                ),
                Text(
                  "Tidak ada Surat",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[300],
                  ),
                )
              ],
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(
              top: mediaQueryData.size.height * 0.01,
              left: mediaQueryData.size.height * 0.01,
              right: mediaQueryData.size.height * 0.01,
              // bottom: mediaQueryData.size.height * 0.02,
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      offset: const Offset(0.0, 5.0),
                      blurRadius: 7.0),
                ],
              ),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        width: mediaQueryData.size.height * 0.15,
                        height: mediaQueryData.size.height * 0.12,
                        child: dataJSON?[i]["foto"] != null
                            ? CachedNetworkImage(
                                imageUrl: dataJSON?[i]["foto"],
                                placeholder: (context, url) => Container(
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(
                                        "assets/logo/22.png",
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                fit: BoxFit.cover,
                                height: 150.0,
                                width: 110.0,
                              )
                            : Image.asset(
                                'assets/logo/22.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 10.0),
                              child: Text(
                                dataJSON?[i]["nama"],
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  //fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: dataJSON?[i]["nama_mesin"] != null
                                  ? Text(
                                      dataJSON?[i]["nama_mesin"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: dataJSON?[i]["kode"] != null
                                  ? Text(
                                      'Kode : ' + dataJSON?[i]["kode"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

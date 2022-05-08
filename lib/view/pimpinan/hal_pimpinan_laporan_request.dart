import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';
import 'package:inventory_app/style/style.dart';
// import 'package:material_dialogs/material_dialogs.dart';
// import 'package:material_dialogs/widgets/buttons/icon_button.dart';
// import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

// import '../../class/header.dart';

class HalPimpinanLaporanRequest extends StatefulWidget {
  const HalPimpinanLaporanRequest({Key? key}) : super(key: key);

  @override
  State<HalPimpinanLaporanRequest> createState() =>
      _HalPimpinanLaporanRequestState();
}

class _HalPimpinanLaporanRequestState extends State<HalPimpinanLaporanRequest> {
  List? dataJSONkeluar;
  List? dataJSONreturn;
  var isloading = false;
// ignore: unused_field
  bool _isLoggedIn = false;

  Future<dynamic> getRequestkeluar() async {
    setState(() {
      isloading = true;
    });
    // String theUrl = getMyUrl.url + 'prosses/stoksperpart';
    String theUrl = getMyUrl.url + 'prosses/laporanrequest';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      "tanggal ": '',
      "status": '4'
    });
    if (res.statusCode == 200) {
      setState(
        () {
          dataJSONkeluar = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print(dataJSONkeluar);
    }
  }

  Future<dynamic> getRequestreturn() async {
    setState(() {
      isloading = true;
    });
    // String theUrl = getMyUrl.url + 'prosses/stoksperpart';
    String theUrl = getMyUrl.url + 'prosses/laporanrequest';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      "tanggal ": '',
      "status": '5'
    });
    if (res.statusCode == 200) {
      setState(
        () {
          dataJSONreturn = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print(dataJSONreturn);
    }
  }

  // ignore: unused_element
  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      Navigator.pushReplacementNamed(context, '/LoginPage');
    } else {
      _isLoggedIn = true;
    }
  }

  @override
  void initState() {
    getRequestkeluar();
    getRequestreturn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.green,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      //   onPressed: () {
      //     Navigator.pushNamed(context, '/AddSparepart');
      //   },
      // ),
      appBar: AppBar(
        title: Text(
          'Laporan Request',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(),
          ),
        ),
        elevation: 0,
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(
        //       Icons.logout,
        //       color: Colors.brown[800],
        //     ),
        //     onPressed: () {
        //       Dialogs.materialDialog(
        //         msg: 'Anda yakin ingin keluar aplikasi?',
        //         title: "Keluar",
        //         color: Colors.white,
        //         context: context,
        //         actions: [
        //           IconsOutlineButton(
        //             onPressed: () {
        //               Navigator.pop(context);
        //             },
        //             text: 'Tidak',
        //             iconData: Icons.cancel_outlined,
        //             textStyle: const TextStyle(color: Colors.grey),
        //             iconColor: Colors.grey,
        //           ),
        //           IconsButton(
        //             onPressed: () async {
        //               SharedPreferences pref =
        //                   await SharedPreferences.getInstance();
        //               pref.clear();
        //               _cekLogout();
        //               Navigator.pop(context);
        //             },
        //             text: 'Exit',
        //             iconData: Icons.exit_to_app,
        //             color: Colors.red,
        //             textStyle: const TextStyle(color: Colors.white),
        //             iconColor: Colors.white,
        //           ),
        //         ],
        //       );
        //     },
        //   ),
        // ],
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  top: mediaQueryData.size.height * 0.01,
                  left: mediaQueryData.size.height * 0.01,
                  right: mediaQueryData.size.height * 0.01,
                  // bottom: mediaQueryData.size.height * 0.02,
                ),
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  // elevation: 1.0,
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
                  child: Column(
                    children: [
                      ExpansionTile(
                        leading: Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(
                                left: mediaQueryData.size.height * 0.012,
                                right: mediaQueryData.size.height * 0.012,
                                // bottom: mediaQueryData.size.height * 0.01,
                                // top:
                                //     mediaQueryData.size.height *
                                //         0.02,
                              ),
                              icon:
                                  const Icon(Icons.wifi_protected_setup_sharp),
                              color: Colors.green,
                              iconSize: 40.0,
                              onPressed: () {
                                // Navigator.pushNamed(context, '/DetailSurat');
                              },
                            ),
                          ],
                        ),
                        title: const Text("Request Proses"),
                        children: [
                          ListSparepartKeluar(
                              dataJSONkeluar: dataJSONkeluar,
                              mediaQueryData: mediaQueryData),
                        ],
                      ),
                      ExpansionTile(
                        leading: Column(
                          children: [
                            IconButton(
                              padding: EdgeInsets.only(
                                left: mediaQueryData.size.height * 0.012,
                                right: mediaQueryData.size.height * 0.012,
                                // bottom: mediaQueryData.size.height * 0.01,
                                // top:
                                //     mediaQueryData.size.height *
                                //         0.02,
                              ),
                              icon: const Icon(Icons.done),
                              color: Colors.blue,
                              iconSize: 40.0,
                              onPressed: () {
                                // Navigator.pushNamed(context, '/DetailSurat');
                              },
                            ),
                          ],
                        ),
                        title: const Text("Request Selesai"),
                        children: [
                          ListSparepartReturn(
                              dataJSONreturn: dataJSONreturn,
                              mediaQueryData: mediaQueryData),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
        if (dataJSON?[i]["id"] == 'NotFound') {
          return Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.inbox_rounded,
                  size: 70,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.02,
                ),
                Text(
                  "Tidak ada Request",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.02,
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
              bottom: mediaQueryData.size.height * 0.005,
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // elevation: 1.0,
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
                        width: mediaQueryData.size.height * 0.12,
                        height: mediaQueryData.size.height * 0.12,
                        color: Colors.green,
                        child: IconButton(
                          padding: EdgeInsets.only(
                            left: mediaQueryData.size.height * 0.012,
                            right: mediaQueryData.size.height * 0.012,
                            // bottom: mediaQueryData.size.height * 0.01,
                            // top:
                            //     mediaQueryData.size.height *
                            //         0.02,
                          ),
                          icon: const Icon(Icons.inbox_rounded),
                          color: Colors.white,
                          iconSize: 50.0,
                          onPressed: () {
                            // Navigator.pushNamed(context, '/DetailSurat');
                          },
                        ),
                      ),
                      SizedBox(
                        width: mediaQueryData.size.width * 0.01,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                dataJSON?[i]["sperpart"],
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  //fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: dataJSON?[i]["mesin"] != null
                                  ? Text(
                                      'Mesin : ' + dataJSON?[i]["mesin"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: dataJSON?[i]["tanggal"] != null
                                  ? Text(
                                      "Tanggal : " + dataJSON?[i]["tanggal"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  child: dataJSON?[i]["jumlah"] != null
                                      ? Text(
                                          'Jumlah : ' + dataJSON?[i]["jumlah"],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 5.0, bottom: 5.0),
                                  child: dataJSON?[i]["jam"] != null
                                      ? Text(
                                          'Jam : ' + dataJSON?[i]["jam"],
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
                                            // fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                ),
                              ],
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

class ListSparepartKeluar extends StatelessWidget {
  const ListSparepartKeluar({
    Key? key,
    required this.dataJSONkeluar,
    required this.mediaQueryData,
  }) : super(key: key);

  final List? dataJSONkeluar;
  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataJSONkeluar == null ? 0 : dataJSONkeluar?.length,
      itemBuilder: (BuildContext context, int i) {
        if (dataJSONkeluar?[i]["id"] == 'NotFound') {
          return Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.outbox_rounded,
                  size: 70,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.02,
                ),
                Text(
                  "Tidak ada Request",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.02,
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
              bottom: mediaQueryData.size.height * 0.005,
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // elevation: 1.0,
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
                        width: mediaQueryData.size.height * 0.12,
                        height: mediaQueryData.size.height * 0.12,
                        color: Colors.green,
                        child: IconButton(
                          padding: EdgeInsets.only(
                            left: mediaQueryData.size.height * 0.012,
                            right: mediaQueryData.size.height * 0.012,
                            // bottom: mediaQueryData.size.height * 0.01,
                            // top:
                            //     mediaQueryData.size.height *
                            //         0.02,
                          ),
                          icon: const Icon(Icons.outbox_rounded),
                          color: Colors.white,
                          iconSize: 50.0,
                          onPressed: () {
                            // Navigator.pushNamed(context, '/DetailSurat');
                          },
                        ),
                      ),
                      SizedBox(
                        width: mediaQueryData.size.width * 0.01,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                dataJSONkeluar?[i]["sperpart"],
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  //fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: dataJSONkeluar?[i]["mesin"] != null
                                  ? Text(
                                      'Mesin : ' + dataJSONkeluar?[i]["mesin"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.green,
                                        fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: dataJSONkeluar?[i]["tanggal"] != null
                                  ? Text(
                                      'Tanggal: ' +
                                          dataJSONkeluar?[i]["tanggal"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  child: dataJSONkeluar?[i]["jumlah"] != null
                                      ? Text(
                                          'Jumlah : ' +
                                              dataJSONkeluar?[i]["jumlah"],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 5.0, bottom: 5.0),
                                  child: dataJSONkeluar?[i]["jam"] != null
                                      ? Text(
                                          'Retur : ' +
                                              dataJSONkeluar?[i]["jam"],
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
                                            // fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                ),
                              ],
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

class ListSparepartReturn extends StatelessWidget {
  const ListSparepartReturn({
    Key? key,
    required this.dataJSONreturn,
    required this.mediaQueryData,
  }) : super(key: key);

  final List? dataJSONreturn;
  final MediaQueryData mediaQueryData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: dataJSONreturn == null ? 0 : dataJSONreturn?.length,
      itemBuilder: (BuildContext context, int i) {
        if (dataJSONreturn?[i]["id"] == "NotFound") {
          return Center(
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.settings_backup_restore_outlined,
                  size: 70,
                  color: Colors.grey[300],
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.02,
                ),
                Text(
                  "Tidak ada Request",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(
                  height: mediaQueryData.size.height * 0.02,
                ),
              ],
            ),
          );
        } else {
          return Container(
            padding: EdgeInsets.only(
              top: mediaQueryData.size.height * 0.01,
              left: mediaQueryData.size.height * 0.01,
              right: mediaQueryData.size.height * 0.01,
              bottom: mediaQueryData.size.height * 0.005,
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              // elevation: 1.0,
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
                        width: mediaQueryData.size.height * 0.12,
                        height: mediaQueryData.size.height * 0.12,
                        color: Colors.blue,
                        child: IconButton(
                          padding: EdgeInsets.only(
                            left: mediaQueryData.size.height * 0.012,
                            right: mediaQueryData.size.height * 0.012,
                            // bottom: mediaQueryData.size.height * 0.01,
                            // top:
                            //     mediaQueryData.size.height *
                            //         0.02,
                          ),
                          icon: const Icon(Icons.done),
                          color: Colors.white,
                          iconSize: 50.0,
                          onPressed: () {
                            // Navigator.pushNamed(context, '/DetailSurat');
                          },
                        ),
                      ),
                      SizedBox(
                        width: mediaQueryData.size.width * 0.01,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                dataJSONreturn?[i]["sperpart"],
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  //fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: dataJSONreturn?[i]["mesin"] != null
                                  ? Text(
                                      'Mesin : ' + dataJSONreturn?[i]["mesin"],
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
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: dataJSONreturn?[i]["tanggal"] != null
                                  ? Text(
                                      'Tanggal : ' +
                                          dataJSONreturn?[i]["tanggal"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        //fontWeight: FontWeight.normal,
                                      ),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  child: dataJSONreturn?[i]["jumlah"] != null
                                      ? Text(
                                          'Jumlah : ' +
                                              dataJSONreturn?[i]["jumlah"],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
                                            // fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 5.0, bottom: 5.0),
                                  child: dataJSONreturn?[i]["jam"] != null
                                      ? Text(
                                          'Jam : ' + dataJSONreturn?[i]["jam"],
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
                                            // fontWeight: FontWeight.bold,
                                            //fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                ),
                              ],
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

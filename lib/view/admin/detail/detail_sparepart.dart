import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';
import 'package:inventory_app/style/style.dart';
import 'package:inventory_app/view/admin/detail/detail_image.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DetailSparepart extends StatefulWidget {
  final String dId;

  const DetailSparepart({
    Key? key,
    required this.dId,
  }) : super(key: key);

  @override
  State<DetailSparepart> createState() => _DetailSparepartState();
}

class _DetailSparepartState extends State<DetailSparepart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var isloading = false;
  var isloadingpost = false;
  String kode = "";
  String nama = "";
  String foto = "";
  String stok = "";
  String retur = "";
  TextEditingController cStock = TextEditingController();
  TextEditingController cKeterangan = TextEditingController();

  Future<dynamic> getSparepart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/sperpartbyid';
    final res = await http.post(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "id": widget.dId,
      },
    );
    var sparepartJSON = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(
        () {
          pref.setString("nama", sparepartJSON['nama']);
          pref.setString("foto", sparepartJSON['foto']);
          pref.setString("kode", sparepartJSON['kode']);
          pref.setString("stok", sparepartJSON['stok']);
          pref.setString("retur", sparepartJSON['retur']);
          kode = pref.getString("kode")!;
          nama = pref.getString("nama")!;
          foto = pref.getString("foto")!;
          stok = pref.getString("stok")!;
          retur = pref.getString("retur")!;
        },
      );
      setState(() {
        isloading = false;
      });

      if (kDebugMode) {
        print(sparepartJSON);
        print("cek id user =");
        print(pref.getString("IdUser"));
      }
    }
    return sparepartJSON;
  }

  Future<dynamic> posStock() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isloadingpost = true;
    });
    String theUrl = getMyUrl.url + 'prosses/arusstoksperpart';
    Future.delayed(const Duration(seconds: 3), () async {
      final res = await http.post(
        Uri.parse(theUrl),
        headers: {
          "name": "invent",
          "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
        },
        body: {
          "sperpart": widget.dId,
          "arus": '1',
          "keterangan": cKeterangan.text,
          "userid": pref.getString("IdUser"),
          "jumlah": cStock.text,
        },
      );
      var jsonStock = json.decode(res.body);

      if (jsonStock['Status'] == 'Sukses') {
        setState(
          () {
            isloadingpost = false;
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 5),
          elevation: 6.0,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.check,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.01,
              ),
              const Text(
                'Input berhasil',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'SUKSES',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/ListLayanan');
              if (kDebugMode) {
                print('Berhasil');
              }
            },
          ),
        ));
        // ignore: deprecated_member_use
        // scaffoldKey.currentState!.showSnackBar(snackBar);
        cStock.clear();
        cKeterangan.clear();
        await Future.delayed(
          const Duration(seconds: 2),
          () {
            // Navigator.pushReplacementNamed(context, '/Proses');
            Navigator.pop(context);
          },
        );
        // Navigator.pushReplacementNamed(context, '/ListDokter');
      } else {
        setState(
          () {
            isloadingpost = false;
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.error,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.01,
              ),
              const Text(
                'Input gagal',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'ULANGI',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/ListLayanan');
              if (kDebugMode) {
                print('Berhasil');
              }
            },
          ),
        ));
        // ignore: deprecated_member_use
        // scaffoldKey.currentState!.showSnackBar(snackBar);
      }
      if (kDebugMode) {
        print("pos stock");
        print(jsonStock);
      }
      return jsonStock;
    });
  }

  Future<dynamic> posReturStock() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isloadingpost = true;
    });
    String theUrl = getMyUrl.url + 'prosses/arusstoksperpart';
    Future.delayed(const Duration(seconds: 3), () async {
      final res = await http.post(
        Uri.parse(theUrl),
        headers: {
          "name": "invent",
          "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
        },
        body: {
          "sperpart": widget.dId,
          "arus": '3',
          "keterangan": cKeterangan.text,
          "userid": pref.getString("IdUser"),
          "jumlah": cStock.text,
        },
      );
      var jsonStock = json.decode(res.body);

      if (jsonStock['Status'] == 'Sukses') {
        setState(
          () {
            isloadingpost = false;
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 5),
          elevation: 6.0,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.check,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.01,
              ),
              const Text(
                'Retur berhasil',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'SUKSES',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/ListLayanan');
              if (kDebugMode) {
                print('Berhasil');
              }
            },
          ),
        ));
        // ignore: deprecated_member_use
        // scaffoldKey.currentState!.showSnackBar(snackBar);
        cStock.clear();
        cKeterangan.clear();
        await Future.delayed(
          const Duration(seconds: 2),
          () {
            // Navigator.pushReplacementNamed(context, '/DetailSparepart');
            // Navigator.pop(context);
          },
        );
        // Navigator.pushReplacementNamed(context, '/ListDokter');
      } else {
        setState(
          () {
            isloadingpost = false;
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          elevation: 6.0,
          behavior: SnackBarBehavior.floating,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(
                Icons.error,
                size: 30,
                color: Colors.white,
              ),
              SizedBox(
                width: mediaQueryData.size.width * 0.01,
              ),
              const Text(
                'Retur gagal',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          backgroundColor: Colors.red,
          action: SnackBarAction(
            label: 'ULANGI',
            textColor: Colors.white,
            onPressed: () {
              // Navigator.pushReplacementNamed(context, '/ListLayanan');
              if (kDebugMode) {
                print('Berhasil');
              }
            },
          ),
        ));
        // ignore: deprecated_member_use
        // scaffoldKey.currentState!.showSnackBar(snackBar);
      }
      if (kDebugMode) {
        print("pos stock");
        print(jsonStock);
      }
      return jsonStock;
    });
  }

  Future<bool> _onWillPop() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nama");
    pref.remove("kode");
    pref.remove("foto");
    pref.remove("stock");
    pref.remove("retur");
    Navigator.pop(context);
    if (kDebugMode) {
      print("hapus id sparepart dll");
    }
    return true;
  }

  @override
  void initState() {
    getSparepart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          key: scaffoldKey,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: titleText, //change your color here
            ),
            title: const Text(
              // nama.toString(),
              'Detail Sparepart',
              style: TextStyle(
                color: titleText,
              ),
            ),
            elevation: 0,
          ),
          body: ModalProgressHUD(
              inAsyncCall: isloadingpost,
              color: primaryColor,
              opacity: 1,
              progressIndicator: Padding(
                padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.4),
                child: Column(
                  children: [
                    const SpinKitRotatingPlain(color: Colors.white),
                    SizedBox(height: mediaQueryData.size.height * 0.05),
                    const Text(
                      'Mengubah Stock...',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )
                  ],
                ),
              ),
              child: isloading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView(
                      children: <Widget>[
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                wHeader(),
                                _infosparepartcard(),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                              left: mediaQueryData.size.height * 0.01,
                              top: mediaQueryData.size.height * 0.02,
                              // bottom: mediaQueryData.size.height * 0.01,
                              right: mediaQueryData.size.height * 0.01,
                            ),
                            child: Column(children: <Widget>[
                              _inputStock(),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQueryData.size.height * 0.02),
                              ),
                              _inputDeskripsi(),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQueryData.size.height * 0.03),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _inputStockButton(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left:
                                            mediaQueryData.size.height * 0.01),
                                  ),
                                  _inputReturnButton(),
                                ],
                              ),
                            ])),
                      ],
                    ))),
    );
  }

  Widget _infosparepartcard() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: mediaQueryData.size.height * 0.01,
        top: mediaQueryData.size.height * 0.25,
        // bottom: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
      ),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      nama.toString(),
                      style: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const FaIcon(
                    FontAwesomeIcons.gear,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Chip(
            //       avatar: const CircleAvatar(
            //         backgroundColor: Colors.white,
            //         child: FaIcon(
            //           FontAwesomeIcons.gear,
            //           color: Colors.blue,
            //           size: 10,
            //         ),
            //       ),
            //       backgroundColor: Colors.blue[800],
            //       label: Text(
            //         nama.toString(),
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 12.0,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.barcode,
                            color: primaryColor,
                            size: 15,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        label: Text(
                          "Kode :",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        kode.toString(),
                        style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 0,
                    indent: 0,
                    // thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.boxArchive,
                            color: Colors.green,
                            size: 15,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        label: Text(
                          "Stock :",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        stok.toString(),
                        style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(
                    color: Colors.grey[300],
                    height: 0,
                    indent: 0,
                    // thickness: 1,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: FaIcon(
                            FontAwesomeIcons.arrowRotateRight,
                            color: Colors.grey,
                            size: 15,
                          ),
                        ),
                        backgroundColor: Colors.white,
                        label: Text(
                          "Retur :",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        retur.toString(),
                        style: const TextStyle(
                            fontSize: 15.0,
                            color: Colors.black87,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Chip(
            //   avatar: const CircleAvatar(
            //     backgroundColor: Colors.white,
            //     child: FaIcon(
            //       FontAwesomeIcons.barcode,
            //       color: primaryColor,
            //       size: 10,
            //     ),
            //   ),
            //   backgroundColor: primaryColor,
            //   label: Text(
            //     kode.toString(),
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontSize: 12.0,
            //     ),
            //   ),
            // ),
            // Row(
            //   children: [
            //     Chip(
            //       avatar: const CircleAvatar(
            //         backgroundColor: Colors.white,
            //         child: FaIcon(
            //           FontAwesomeIcons.boxArchive,
            //           color: Colors.green,
            //           size: 10,
            //         ),
            //       ),
            //       backgroundColor: Colors.green,
            //       label: Text(
            //         "Stock : " + stok.toString(),
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 12.0,
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding:
            //           EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
            //     ),
            //     Chip(
            //       avatar: const CircleAvatar(
            //         backgroundColor: Colors.white,
            //         child: FaIcon(
            //           FontAwesomeIcons.arrowRotateRight,
            //           color: Colors.grey,
            //           size: 10,
            //         ),
            //       ),
            //       backgroundColor: Colors.grey,
            //       label: Text(
            //         "Retur : " + retur.toString(),
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 12.0,
            //         ),
            //       ),
            //     ),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget _inputStockButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: mediaQueryData.size.width * 0.46,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton.icon(
        icon: const Icon(
          Icons.save,
          color: Colors.white,
          size: 30.0,
        ),
        label: const Text('SAVE'),
        onPressed: () async {
          // SharedPreferences pref = await SharedPreferences.getInstance();
          // if (kDebugMode) {
          //   print(widget.dId);
          //   // print(widget.dId);
          //   print(
          //     cKeterangan.text,
          //   );
          //   print(pref.getString("IdUser"));
          //   print(cStock.text);
          // }
          if (cStock.text.isEmpty || cStock.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  const Text(
                    ' Stock belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  if (kDebugMode) {
                    print('ULANGI');
                  }
                },
              ),
            ));
            // ignore: deprecated_member_use
            // scaffoldKey.currentState!.showSnackBar(snackBar);
          } else if (cKeterangan.text.isEmpty || cKeterangan.text == '') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: const Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  const Text(
                    ' Keterangan belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  if (kDebugMode) {
                    print('ULANGI');
                  }
                },
              ),
            ));
            // ignore: deprecated_member_use
            // scaffoldKey.currentState!.showSnackBar(snackBar);
          } else {
            posStock();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget _inputReturnButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    if (stok == '0') {
      return SizedBox(
        width: mediaQueryData.size.width * 0.46,
        height: mediaQueryData.size.height * 0.07,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.undo,
            color: Colors.white,
            size: 30.0,
          ),
          label: const Text('Retur'),
          onPressed: () async {
            Dialogs.materialDialog(
              msg: 'Isi stok sebelum mereturn sparepart',
              title: "Stock Masih Kosong",
              color: Colors.white,
              context: context,
              actions: [
                IconsButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  text: 'ULANGI',
                  iconData: Icons.replay_outlined,
                  color: Colors.red,
                  textStyle: const TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ],
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: mediaQueryData.size.width * 0.46,
        height: mediaQueryData.size.height * 0.07,
        child: ElevatedButton.icon(
          icon: const Icon(
            Icons.undo,
            color: Colors.white,
            size: 30.0,
          ),
          label: const Text('Retur'),
          onPressed: () async {
            posReturStock().then((value) => getSparepart());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
      );
    }
  }

  Widget _inputDeskripsi() {
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      alignment: Alignment.topLeft,
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        maxLines: null,
        // focusNode: _focusNode,
        keyboardType: TextInputType.multiline,
        controller: cKeterangan,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Deskripsi',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.library_books,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputStock() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.number,
        controller: cStock,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Input Stock',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.layers_rounded,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget wHeader() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ClipPath(
      // clipper: ArcClipper(),
      child: foto != ''
          ? GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailGaleri(
                      dGambar: foto,
                      dDesa: kode,
                      dJudul: nama,
                    ),
                  ),
                );
              },
              child: CachedNetworkImage(
                imageUrl: foto,
                // new NetworkImage(databerita[index]["kabar_gambar"]),
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
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height * 0.35,
                fit: BoxFit.fill,
              ),
            )
          : Image.asset(
              'assets/logo/22.png',
              // width: mediaQueryData.size.height * 0.7,
              // height: mediaQueryData.size.width * 0.7,
              fit: BoxFit.cover,
            ),
      // child: Image.network(
      //   '${widget.dGambar}',
      //   width: screenWidth,
      //   height: 230.0,
      //   fit: BoxFit.cover,
      // ),
    );
  }
}

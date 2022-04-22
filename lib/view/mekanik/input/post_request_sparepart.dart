import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_app/class/header.dart';
import 'package:inventory_app/style/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:inventory_app/service/service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostRequestSparepart extends StatefulWidget {
  const PostRequestSparepart({Key? key}) : super(key: key);

  @override
  State<PostRequestSparepart> createState() => _PostRequestSparepartState();
}

class _PostRequestSparepartState extends State<PostRequestSparepart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List allMesin = [];
  String? cMesin;
  var isloadingpost = false;
  var isloading = false;
  String id = "";
  String kode = "";
  TextEditingController cKeterangan = TextEditingController();

  Future cekRequestSparepart() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    // setState(() {
    //   isloading = true;
    // });
    String theUrl = getMyUrl.url + 'prosses/cekrequestbyuser';
    final res = await http.post(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "userid": pref.getString("IdUser"),
      },
    );
    var ceksparepartJSON = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(
        () {
          pref.setString("id", ceksparepartJSON[0]['id']);
          pref.setString("kode", ceksparepartJSON[0]['kode']);
          id = pref.getString("id")!;
          kode = pref.getString("kode")!;
        },
      );
      // setState(() {
      //   isloading = false;
      // });

      if (kDebugMode) {
        print(ceksparepartJSON);
        print(id);
        print(kode);
      }
    }
    // return ceksparepartJSON;
  }

  Future<bool> _onWillPop() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("id");
    pref.remove("kode");

    Navigator.pop(context);
    if (kDebugMode) {
      print("hapus id kode");
    }
    return true;
  }

  Future getListMesin() async {
    String theUrl = getMyUrl.url + 'prosses/mesin';
    var res = await http.get(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
    );
    var mesin = json.decode(res.body);
    if (kDebugMode) {
      print("list mesin =");
      print(mesin);
    }
    setState(
      () {
        allMesin = mesin;
      },
    );
  }

  Future<dynamic> postRequest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    setState(() {
      isloadingpost = true;
    });
    String theUrl = getMyUrl.url + 'prosses/request';
    Future.delayed(const Duration(seconds: 3), () async {
      final res = await http.post(
        Uri.parse(theUrl),
        headers: {
          "name": "invent",
          "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
        },
        body: {
          "userid": pref.getString("IdUser"),
          "mesin": cMesin,
          "keterangan": cKeterangan.text,
        },
      );
      var jsonRequest = json.decode(res.body);

      if (jsonRequest['Status'] == 'Sukses') {
        setState(
          () {
            isloadingpost = false;
          },
        );
        SnackBar snackBar = SnackBar(
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
                'Request berhasil',
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
        );
        // ignore: deprecated_member_use
        scaffoldKey.currentState!.showSnackBar(snackBar);
        await Future.delayed(
          const Duration(seconds: 2),
          () {
            Navigator.pushReplacementNamed(context, '/PostRequestSparepart');
          },
        );
      } else {
        setState(
          () {
            isloadingpost = false;
          },
        );
        SnackBar snackBar = SnackBar(
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
        );
        // ignore: deprecated_member_use
        scaffoldKey.currentState!.showSnackBar(snackBar);
      }
      if (kDebugMode) {
        print("pos sparepart");
        print(jsonRequest);
      }
      return jsonRequest;
    });
  }

  @override
  void initState() {
    cekRequestSparepart();
    getListMesin();
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
          elevation: 0,
          title: Text(
            'Mekanik',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(),
            ),
          ),
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
                    'Request Stock...',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )
                ],
              ),
            ),
            child: id == 'NotFound'
                ? Stack(
                    children: [
                      HeaderInputSparepart(mediaQueryData: mediaQueryData),
                      Container(
                        // padding: const EdgeInsets.all(defaultPadding),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.17),
                        decoration: BoxDecoration(
                          color: bgCOlor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: mediaQueryData.size.height * 0.02,
                            top: mediaQueryData.size.height * 0.03,
                            // bottom: mediaQueryData.size.height * 0.01,
                            right: mediaQueryData.size.height * 0.02,
                          ),
                          child: ListView(
                            children: <Widget>[
                              _inputMesin(),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQueryData.size.height * 0.03),
                              ),
                              _inputDeskripsi(),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQueryData.size.height * 0.03),
                              ),
                              _loginButton(),
                              //_daftar(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Stack(
                    children: [
                      HeaderInputSparepart(mediaQueryData: mediaQueryData),
                      Container(
                        // padding: const EdgeInsets.all(defaultPadding),
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: mediaQueryData.size.height * 0.17),
                        decoration: BoxDecoration(
                          color: bgCOlor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: mediaQueryData.size.height * 0.01,
                            top: mediaQueryData.size.height * 0.02,
                            // bottom: mediaQueryData.size.height * 0.01,
                            right: mediaQueryData.size.height * 0.01,
                          ),
                          child: ListView(
                            children: <Widget>[
                              SizedBox(
                                width: mediaQueryData.size.width,
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
                                        // Navigator.pushNamed(
                                        //     context, '/PostRequestSparepart');
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            const FaIcon(
                                              // ignore: deprecated_member_use
                                              FontAwesomeIcons.warning,
                                              color: Colors.white,
                                              size: 35,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top:
                                                    mediaQueryData.size.height *
                                                        0.02,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              // crossAxisAlignment: CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  kode, //IBADAH
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top:
                                                    mediaQueryData.size.height *
                                                        0.01,
                                              ),
                                            ),
                                            const Text(
                                              "Silahkan selesaikan request sebelumnya ",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                top:
                                                    mediaQueryData.size.height *
                                                        0.02,
                                              ),
                                            ),
                                            Text(
                                              "Lihat Request",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.white
                                                    .withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )),
      ),
    );
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

  Widget _inputMesin() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
          top: mediaQueryData.size.height * 0.005,
          left: mediaQueryData.size.height * 0.01,
          right: mediaQueryData.size.height * 0.02),
      height: mediaQueryData.size.height * 0.07,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey),
      ),
      child: DropdownButton<String>(
        underline: const SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            const Icon(
              Icons.build_circle_rounded,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Mesin",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: allMesin.map(
          (item) {
            return DropdownMenuItem(
              child: Text(item['nama']),
              value: item['id'].toString(),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              cMesin = newVal;
              if (kDebugMode) {
                print(cMesin);
              }
            },
          );
        },
        value: cMesin,
      ),
      //     DropdownButton<String>(
      //   hint: Text('Please choose a location'),
      //   value: _selectedLocation,
      //   onChanged: (newValue) {
      //     setState(() {
      //       _selectedLocation = newValue;
      //     });
      //   },
      //   items: _locations.map((location) {
      //     return DropdownMenuItem(
      //       child: new Text(location),
      //       value: location,
      //     );
      //   }).toList(),
      // ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton(
        onPressed: () async {
          // SharedPreferences pref = await SharedPreferences.getInstance();
          // if (kDebugMode) {
          //   print(pref.getString("IdUser"));
          //   print(cMesin);
          //   print(cKeterangan);
          // }
          if (cMesin!.isEmpty || cMesin! == '') {
            SnackBar snackBar = SnackBar(
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
                    ' Mesin belum diisi',
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
            );
            // ignore: deprecated_member_use
            scaffoldKey.currentState!.showSnackBar(snackBar);
          } else if (cKeterangan.text.isEmpty || cKeterangan.text == '') {
            SnackBar snackBar = SnackBar(
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
            );
            // ignore: deprecated_member_use
            scaffoldKey.currentState!.showSnackBar(snackBar);
          } else {
            postRequest();
          }
          // posStock();
        },
        child: const Text(
          'REQUEST',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: titleText,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

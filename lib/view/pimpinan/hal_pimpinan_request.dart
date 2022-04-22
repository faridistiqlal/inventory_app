import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';
import 'package:inventory_app/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HalRequestMekanikList extends StatefulWidget {
  const HalRequestMekanikList({Key? key}) : super(key: key);

  @override
  State<HalRequestMekanikList> createState() => _HalRequestMekanikListState();
}

class _HalRequestMekanikListState extends State<HalRequestMekanikList> {
  List? dataJSON;
  var isloading = false;
// ignore: unused_field
  bool _isLoggedIn = false;
  Future<dynamic> getRequest() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/listrequest';
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
    getRequest();
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
          'Request',
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
          ? shimmerinventory()
          : ListSparepart(dataJSON: dataJSON, mediaQueryData: mediaQueryData),
      // Stack(children: [
      //     HeaderPemimpin(mediaQueryData: mediaQueryData),
      //     Container(
      //         padding: const EdgeInsets.all(defaultPadding),
      //         width: MediaQuery.of(context).size.width,
      //         margin:
      //             EdgeInsets.only(top: mediaQueryData.size.height * 0.17),
      //         decoration: BoxDecoration(
      //           color: bgCOlor,
      //           borderRadius: BorderRadius.circular(15),
      //         ),
      //         child: Column(children: [
      //           ListSparepart(
      //               dataJSON: dataJSON, mediaQueryData: mediaQueryData),
      //         ]))
      //   ]
      // ),
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
          return Container(
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
                          child: dataJSON?[i]["status"] == 'Menunggu'
                              ? Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.green[800],
                                  child: Column(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.only(
                                          left: mediaQueryData.size.height *
                                              0.012,
                                          right: mediaQueryData.size.height *
                                              0.012,
                                          // bottom: mediaQueryData.size.height * 0.01,
                                          top:
                                              mediaQueryData.size.height * 0.02,
                                        ),
                                        icon: const Icon(
                                            Icons.watch_later_outlined),
                                        color: Colors.white,
                                        iconSize: 50.0,
                                        onPressed: () {
                                          // Navigator.pushNamed(context, '/DetailSurat');
                                        },
                                      ),
                                      Text(
                                        dataJSON?[i]["status"],
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          //fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Material(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.blue,
                                  child: Column(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.only(
                                          left: mediaQueryData.size.height *
                                              0.012,
                                          right: mediaQueryData.size.height *
                                              0.012,
                                          // bottom: mediaQueryData.size.height * 0.01,
                                          top:
                                              mediaQueryData.size.height * 0.02,
                                        ),
                                        icon: const Icon(Icons.done),
                                        color: Colors.white,
                                        iconSize: 50.0,
                                        onPressed: () {
                                          // Navigator.pushNamed(context, '/DetailSurat');
                                        },
                                      ),
                                      Text(
                                        dataJSON?[i]["status"],
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: Colors.white,
                                          // fontWeight: FontWeight.bold,
                                          //fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                      // SizedBox(
                      //   width: mediaQueryData.size.width * 0.02,
                      // ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                dataJSON?[i]["kode"],
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
                              child: dataJSON?[i]["keterangan"] != null
                                  ? Text(
                                      dataJSON?[i]["keterangan"],
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
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: dataJSON?[i]["mesin"] != null
                                  ? Text(
                                      'Mesin : ' + dataJSON?[i]["mesin"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: primaryColor,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  child: dataJSON?[i]["tanggal"] != null
                                      ? Text(
                                          'Tanggal : ' +
                                              dataJSON?[i]["tanggal"],
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
                                // Container(
                                //   margin: const EdgeInsets.only(
                                //       right: 5.0, bottom: 5.0),
                                //   child: dataJSON?[i]["retur"] != null
                                //       ? Text(
                                //           'Retur : ' + dataJSON?[i]["retur"],
                                //           style: const TextStyle(
                                //             fontSize: 13.0,
                                //             color: Colors.blue,
                                //             fontWeight: FontWeight.bold,
                                //             //fontWeight: FontWeight.normal,
                                //           ),
                                //         )
                                //       : const Text(
                                //           '-',
                                //           style: TextStyle(
                                //             fontSize: 13.0,
                                //             color: Colors.black,
                                //             // fontWeight: FontWeight.bold,
                                //             //fontWeight: FontWeight.normal,
                                //           ),
                                //         ),
                                // ),
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

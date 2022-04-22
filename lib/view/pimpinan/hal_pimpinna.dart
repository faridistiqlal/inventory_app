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

import '../../class/header.dart';

class HalMesinMekanik extends StatefulWidget {
  const HalMesinMekanik({Key? key}) : super(key: key);

  @override
  State<HalMesinMekanik> createState() => _HalMesinMekanikState();
}

class _HalMesinMekanikState extends State<HalMesinMekanik> {
  List? dataJSON;
  var isloading = false;
// ignore: unused_field
  bool _isLoggedIn = false;
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
    getSparepart();
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
          'Pimpinan',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(),
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          IconButton(
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
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
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
          ),
        ],
      ),
      body:
          // isloading
          //     ? shimmerinventory()
          //     :
          Stack(
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
            child: Column(
              children: [
                // ListSparepart(dataJSON: dataJSON, mediaQueryData: mediaQueryData),
                // ListView(
                //   children: <Widget>[
                Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: mediaQueryData.size.width * 0.475,
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
                                  Navigator.pushNamed(
                                      context, '/HalMesinMekanikList');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const FaIcon(
                                        FontAwesomeIcons.gears,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.02,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const <Widget>[
                                          Text(
                                            'List Sparepart', //IBADAH
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
                                          top:
                                              mediaQueryData.size.height * 0.01,
                                        ),
                                      ),
                                      // const Text(
                                      //   "Sparepart",
                                      //   style: TextStyle(
                                      //     fontSize: 15,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.01,
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
                        ),
                        SizedBox(
                          width: mediaQueryData.size.width * 0.475,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Material(
                              color: Colors.purple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, '/HalRequestMekanikList');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const FaIcon(
                                        FontAwesomeIcons.boxesStacked,
                                        color: Colors.white,
                                        size: 35,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.02,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const <Widget>[
                                          Text(
                                            'List Request', //IBADAH
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
                                          top:
                                              mediaQueryData.size.height * 0.01,
                                        ),
                                      ),
                                      // const Text(
                                      //   "List Request",
                                      //   style: TextStyle(
                                      //     fontSize: 15,
                                      //     color: Colors.white,
                                      //   ),
                                      // ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.01,
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
                        ),
                      ],
                    )
                  ],
                ),
                // Column(
                //   children: [
                //     Row(
                //       children: [
                //         SizedBox(
                //           width: mediaQueryData.size.width * 0.475,
                //           child: Card(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(15.0),
                //             ),
                //             child: Material(
                //               color: Colors.purple,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15.0),
                //               ),
                //               child: InkWell(
                //                 onTap: () {},
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(15),
                //                   ),
                //                   padding: const EdgeInsets.all(10.0),
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.start,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: <Widget>[
                //                       const FaIcon(
                //                         FontAwesomeIcons.handHoldingHand,
                //                         color: Colors.white,
                //                         size: 35,
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.only(
                //                           top:
                //                               mediaQueryData.size.height * 0.02,
                //                         ),
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         // crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: const <Widget>[
                //                           Text(
                //                             '45 Buah', //IBADAH
                //                             style: TextStyle(
                //                               fontSize: 17,
                //                               fontWeight: FontWeight.bold,
                //                               color: Colors.white,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.only(
                //                           top:
                //                               mediaQueryData.size.height * 0.01,
                //                         ),
                //                       ),
                //                       const Text(
                //                         "Request",
                //                         style: TextStyle(
                //                           fontSize: 15,
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.only(
                //                           top:
                //                               mediaQueryData.size.height * 0.02,
                //                         ),
                //                       ),
                //                       Text(
                //                         "Tap to view",
                //                         style: TextStyle(
                //                           fontSize: 11,
                //                           color: Colors.white.withOpacity(0.5),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //         SizedBox(
                //           width: mediaQueryData.size.width * 0.475,
                //           child: Card(
                //             shape: RoundedRectangleBorder(
                //               borderRadius: BorderRadius.circular(15.0),
                //             ),
                //             child: Material(
                //               color: Colors.purpleAccent,
                //               shape: RoundedRectangleBorder(
                //                 borderRadius: BorderRadius.circular(15.0),
                //               ),
                //               child: InkWell(
                //                 onTap: () {},
                //                 child: Container(
                //                   decoration: BoxDecoration(
                //                     borderRadius: BorderRadius.circular(15),
                //                   ),
                //                   padding: const EdgeInsets.all(10.0),
                //                   child: Column(
                //                     mainAxisAlignment: MainAxisAlignment.start,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: <Widget>[
                //                       const FaIcon(
                //                         FontAwesomeIcons.microchip,
                //                         color: Colors.white,
                //                         size: 35,
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.only(
                //                           top:
                //                               mediaQueryData.size.height * 0.02,
                //                         ),
                //                       ),
                //                       Row(
                //                         mainAxisAlignment:
                //                             MainAxisAlignment.spaceBetween,
                //                         // crossAxisAlignment: CrossAxisAlignment.start,
                //                         children: const <Widget>[
                //                           Text(
                //                             '25 Buah', //IBADAH
                //                             style: TextStyle(
                //                               fontSize: 17,
                //                               fontWeight: FontWeight.bold,
                //                               color: Colors.white,
                //                             ),
                //                           ),
                //                         ],
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.only(
                //                           top:
                //                               mediaQueryData.size.height * 0.01,
                //                         ),
                //                       ),
                //                       const Text(
                //                         "Mesin",
                //                         style: TextStyle(
                //                           fontSize: 15,
                //                           color: Colors.white,
                //                         ),
                //                       ),
                //                       Padding(
                //                         padding: EdgeInsets.only(
                //                           top:
                //                               mediaQueryData.size.height * 0.02,
                //                         ),
                //                       ),
                //                       Text(
                //                         "Tap to view",
                //                         style: TextStyle(
                //                           fontSize: 11,
                //                           color: Colors.white.withOpacity(0.5),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ],
                //     )
                //   ],
                // ),
              ],
            ),
            //   ],
            // ),
          )
        ],
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
                                // width: mediaQueryData.size.height * 0.7,
                                // height: mediaQueryData.size.width * 0.7,
                                fit: BoxFit.cover,
                              ),
                      ),
                      // SizedBox(
                      //   width: mediaQueryData.size.width * 0.02,
                      // ),
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
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: dataJSON?[i]["kode"] != null
                                  ? Text(
                                      'Kode : ' + dataJSON?[i]["kode"],
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

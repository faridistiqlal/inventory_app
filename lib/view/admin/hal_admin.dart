import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_app/style/style.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';
import '../../class/header.dart';
import 'dart:convert';
import 'detail/detail_sparepart.dart';

class HalAdmin extends StatefulWidget {
  const HalAdmin({Key? key}) : super(key: key);

  @override
  State<HalAdmin> createState() => _HalAdminState();
}

class _HalAdminState extends State<HalAdmin> {
  var isloading = false;
  List<dynamic> _allUsers = [];
  // ignore: unused_field
  bool _isLoggedIn = false;
  Future _cekLogout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_isLoggedIn") == null) {
      _isLoggedIn = false;
      Navigator.pushReplacementNamed(context, '/LoginPage');
    } else {
      _isLoggedIn = true;
    }
  }

  Future<dynamic> getSparepart() async {
    // setState(() {
    //   isloading = true;
    // });
    String theUrl = getMyUrl.url + 'prosses/sperpart';
    final res = await http.get(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      // body: {
      //   "id": '1',
      // },
    );
    if (res.statusCode == 200) {
      setState(
        () {
          _allUsers = json.decode(res.body);
        },
      );
      if (kDebugMode) {
        print(_allUsers);
      }
      // setState(() {
      //   isloading = false;
      // });
    }
    return _allUsers;
  }

  late List<dynamic> _foundUsers = [];
  @override
  initState() {
    getSparepart();
    // at the beginning, all users are shown
    _foundUsers = _allUsers;

    super.initState();
  }

// This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<dynamic> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allUsers;
    } else {
      results = _allUsers
          .where(
            (user) => user["kode"].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Admin',
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
      body: Stack(
        children: [
          HeaderAdmin(mediaQueryData: mediaQueryData),
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
                const SizedBox(
                  height: 20,
                ),
                // TextField(
                //   onChanged: (value) => _runFilter(value),
                //   decoration: const InputDecoration(
                //       labelText: 'Cari kode barang ',
                //       suffixIcon: Icon(Icons.search)),
                // ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[50],
                  ),
                  child: TextFormField(
                    onChanged: (value) => _runFilter(value),
                    // controller: cSpesialis,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: 'Cari kode barang',
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: _foundUsers.isNotEmpty
                      ? ListView.builder(
                          itemCount: _foundUsers.length,
                          itemBuilder: (context, index) => Container(
                            key: ValueKey(_foundUsers[index]["id"]),
                            padding: EdgeInsets.only(
                              top: mediaQueryData.size.height * 0.01,
                              // left: mediaQueryData.size.height * 0.01,
                              // right: mediaQueryData.size.height * 0.01,
                              // bottom: mediaQueryData.size.height * 0.02,
                            ),
                            child: Container(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              // elevation: 1.0,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailSparepart(
                                          dId: _foundUsers[index]["id"],
                                        ),
                                      ),
                                    ).then((value) => getSparepart());
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        margin:
                                            const EdgeInsets.only(right: 15.0),
                                        width:
                                            mediaQueryData.size.height * 0.15,
                                        height:
                                            mediaQueryData.size.height * 0.12,
                                        child: _foundUsers[index]['foto'] !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl: _foundUsers[index]
                                                    ['foto'],
                                                placeholder: (context, url) =>
                                                    Container(
                                                  decoration:
                                                      const BoxDecoration(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 5.0, bottom: 10.0),
                                              child: Text(
                                                _foundUsers[index]['nama'],
                                                style: const TextStyle(
                                                  fontSize: 15.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  //fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: _foundUsers[index]
                                                          ['subassembly'] !=
                                                      null
                                                  ? Text(
                                                      // 'Subasembly : ' +
                                                      _foundUsers[index]
                                                          ['subassembly'],
                                                      style: const TextStyle(
                                                        fontSize: 12.0,
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
                                              margin: const EdgeInsets.only(
                                                  bottom: 10.0),
                                              child: _foundUsers[index]
                                                          ['kode'] !=
                                                      null
                                                  ? Text(
                                                      'Kode : ' +
                                                          _foundUsers[index]
                                                              ['kode'],
                                                      style: const TextStyle(
                                                        fontSize: 13.0,
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                          ),
                          // ),
                        )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              FaIcon(
                                FontAwesomeIcons.gears,
                                color: Colors.grey[300],
                                size: 60,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: mediaQueryData.size.height * 0.02),
                              ),
                              Text(
                                "Sparepart",
                                style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.grey[300],
                                ),
                              )
                            ],
                          ),
                        ),
                ),
              ],
            ),

            // child: ListView(
            //   children: <Widget>[
            //     Column(
            //       children: [
            //         Row(
            //           children: [
            //             SizedBox(
            //               width: mediaQueryData.size.width * 0.475,
            //               child: Card(
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15.0),
            //                 ),
            //                 child: Material(
            //                   color: Colors.blue,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   child: InkWell(
            //                     onTap: () {
            //                       Navigator.pushNamed(context, '/HalSparepart');
            //                     },
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(15),
            //                       ),
            //                       padding: const EdgeInsets.all(10.0),
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           const FaIcon(
            //                             FontAwesomeIcons.gears,
            //                             color: Colors.white,
            //                             size: 35,
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             // crossAxisAlignment: CrossAxisAlignment.start,
            //                             children: const <Widget>[
            //                               Text(
            //                                 '265 Buah', //IBADAH
            //                                 style: TextStyle(
            //                                   fontSize: 17,
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.01,
            //                             ),
            //                           ),
            //                           const Text(
            //                             "Sparepart",
            //                             style: TextStyle(
            //                               fontSize: 15,
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Text(
            //                             "Tap to view",
            //                             style: TextStyle(
            //                               fontSize: 11,
            //                               color: Colors.white.withOpacity(0.5),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             SizedBox(
            //               width: mediaQueryData.size.width * 0.475,
            //               child: Card(
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15.0),
            //                 ),
            //                 child: Material(
            //                   color: Colors.orange,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   child: InkWell(
            //                     onTap: () {},
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(15),
            //                       ),
            //                       padding: const EdgeInsets.all(10.0),
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           const FaIcon(
            //                             FontAwesomeIcons.boxesStacked,
            //                             color: Colors.white,
            //                             size: 35,
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             // crossAxisAlignment: CrossAxisAlignment.start,
            //                             children: const <Widget>[
            //                               Text(
            //                                 '765 Buah', //IBADAH
            //                                 style: TextStyle(
            //                                   fontSize: 17,
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.01,
            //                             ),
            //                           ),
            //                           const Text(
            //                             "Stock Sparepart",
            //                             style: TextStyle(
            //                               fontSize: 15,
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Text(
            //                             "Tap to view",
            //                             style: TextStyle(
            //                               fontSize: 11,
            //                               color: Colors.white.withOpacity(0.5),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //     Column(
            //       children: [
            //         Row(
            //           children: [
            //             SizedBox(
            //               width: mediaQueryData.size.width * 0.475,
            //               child: Card(
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15.0),
            //                 ),
            //                 child: Material(
            //                   color: Colors.purple,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   child: InkWell(
            //                     onTap: () {},
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(15),
            //                       ),
            //                       padding: const EdgeInsets.all(10.0),
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           const FaIcon(
            //                             FontAwesomeIcons.handHoldingHand,
            //                             color: Colors.white,
            //                             size: 35,
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             // crossAxisAlignment: CrossAxisAlignment.start,
            //                             children: const <Widget>[
            //                               Text(
            //                                 '45 Buah', //IBADAH
            //                                 style: TextStyle(
            //                                   fontSize: 17,
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.01,
            //                             ),
            //                           ),
            //                           const Text(
            //                             "Request",
            //                             style: TextStyle(
            //                               fontSize: 15,
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Text(
            //                             "Tap to view",
            //                             style: TextStyle(
            //                               fontSize: 11,
            //                               color: Colors.white.withOpacity(0.5),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //             SizedBox(
            //               width: mediaQueryData.size.width * 0.475,
            //               child: Card(
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(15.0),
            //                 ),
            //                 child: Material(
            //                   color: Colors.purpleAccent,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(15.0),
            //                   ),
            //                   child: InkWell(
            //                     onTap: () {},
            //                     child: Container(
            //                       decoration: BoxDecoration(
            //                         borderRadius: BorderRadius.circular(15),
            //                       ),
            //                       padding: const EdgeInsets.all(10.0),
            //                       child: Column(
            //                         mainAxisAlignment: MainAxisAlignment.start,
            //                         crossAxisAlignment:
            //                             CrossAxisAlignment.start,
            //                         children: <Widget>[
            //                           const FaIcon(
            //                             FontAwesomeIcons.microchip,
            //                             color: Colors.white,
            //                             size: 35,
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Row(
            //                             mainAxisAlignment:
            //                                 MainAxisAlignment.spaceBetween,
            //                             // crossAxisAlignment: CrossAxisAlignment.start,
            //                             children: const <Widget>[
            //                               Text(
            //                                 '25 Buah', //IBADAH
            //                                 style: TextStyle(
            //                                   fontSize: 17,
            //                                   fontWeight: FontWeight.bold,
            //                                   color: Colors.white,
            //                                 ),
            //                               ),
            //                             ],
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.01,
            //                             ),
            //                           ),
            //                           const Text(
            //                             "Mesin",
            //                             style: TextStyle(
            //                               fontSize: 15,
            //                               color: Colors.white,
            //                             ),
            //                           ),
            //                           Padding(
            //                             padding: EdgeInsets.only(
            //                               top:
            //                                   mediaQueryData.size.height * 0.02,
            //                             ),
            //                           ),
            //                           Text(
            //                             "Tap to view",
            //                             style: TextStyle(
            //                               fontSize: 11,
            //                               color: Colors.white.withOpacity(0.5),
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         )
            //       ],
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}

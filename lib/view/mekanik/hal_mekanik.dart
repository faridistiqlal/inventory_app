import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_app/class/header.dart';
import 'package:inventory_app/style/style.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalMekanik extends StatefulWidget {
  const HalMekanik({Key? key}) : super(key: key);

  @override
  State<HalMekanik> createState() => _HalMekanikState();
}

class _HalMekanikState extends State<HalMekanik> {
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

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: bgMekanik,
          title: Text(
            'Mekanik',
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
        body: Stack(children: [
          HeaderMekanik(mediaQueryData: mediaQueryData),
          Container(
            padding: const EdgeInsets.all(defaultPadding),
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.17),
            decoration: BoxDecoration(
              color: bgCOlor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(
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
                                  Navigator.pushNamed(
                                      context, '/PostRequestSparepart');
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
                                        FontAwesomeIcons.cartArrowDown,
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
                                            '265 Buah', //IBADAH
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
                                      const Text(
                                        "Request",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.02,
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
                          width: mediaQueryData.size.width * 0.47,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Material(
                              color: Colors.orange,
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
                                            '765 Buah', //IBADAH
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
                                      const Text(
                                        "Stock Sparepart",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top:
                                              mediaQueryData.size.height * 0.02,
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
          ),
        ]));
  }
}

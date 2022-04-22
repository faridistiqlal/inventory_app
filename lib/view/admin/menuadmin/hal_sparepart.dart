import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';
import 'package:shimmer/shimmer.dart';

class HalSparepart extends StatefulWidget {
  const HalSparepart({Key? key}) : super(key: key);

  @override
  State<HalSparepart> createState() => _HalSparepartState();
}

class _HalSparepartState extends State<HalSparepart> {
  List? dataJSON;
  var isloading = false;

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

  @override
  void initState() {
    getSparepart();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/AddSparepart');
        },
      ),
      appBar: AppBar(
        title: const Text(
          'Sparepart',
          style: TextStyle(
              // color: titleText,
              ),
        ),
        elevation: 0,
      ),
      body: isloading
          ? shimmerinventory()
          : ListSparepart(dataJSON: dataJSON, mediaQueryData: mediaQueryData),
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

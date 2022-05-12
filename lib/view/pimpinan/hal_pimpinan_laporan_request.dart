import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:inventory_app/service/service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'model/model_laporan_request.dart';

class HalPimpinanLaporanRequest extends StatefulWidget {
  const HalPimpinanLaporanRequest({Key? key}) : super(key: key);

  @override
  State<HalPimpinanLaporanRequest> createState() =>
      _HalPimpinanLaporanRequestState();
}

class SalesData {
  SalesData(this.month, this.sales);

  final String month;
  final int sales;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['tanggal'].toString(),
      int.parse(parsedJson['jumlah']),
    );
  }
}

class _HalPimpinanLaporanRequestState extends State<HalPimpinanLaporanRequest> {
  var formatedTanggal = DateFormat('yyyy-dd-MM').format(DateTime.now());
  List? dataJSONkeluar;
  List? dataJSONreturn;
  List<ChartRequest> dataJSONchartrequest = [];
  List<SalesData> chartData = [];
  late TooltipBehavior _tooltipBehavior;
  final format = DateFormat("yyyy-MM-dd");
  var isloading = false;
// ignore: unused_field
  bool _isLoggedIn = false;
  String? barangmasuk;
  String? barangkeluar;
  int? barangreturn;
  int? reqproses;
  int? reqselesai;
  int? reqtotal;
  int? reqproses2;
  int? reqselesai2;
  int? reqtotal2;
  String? cStatus;
  TextEditingController cTglAwal = TextEditingController();
  TextEditingController cTglAkhir = TextEditingController();
  List? dataJSONlaporanrequest;
  final List _status = [
    {
      "id": '',
      "status": 'Semua',
    },
    {
      "id": '3',
      "status": 'Proses',
    },
    {
      "id": '4',
      "status": 'Selesai',
    },
  ];

  Future<dynamic> getLaporanrequest() async {
    // setState(() {
    //   isloading = true;
    // });
    String theUrl = getMyUrl.url + 'prosses/laporanrequest';
    final res = await http.post(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "tanggalawal": cTglAwal.text,
        "tanggalakhir": cTglAkhir.text,
        "status": cStatus.toString(),
      },
    );

    if (mounted) {
      setState(
        () {
          dataJSONreturn = json.decode(res.body);
        },
      );
    }
    if (kDebugMode) {
      print(dataJSONreturn);
      print("cek2");
    }
    return dataJSONreturn;
  }

  void laporanbyDate() async {
    // SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/laporanbydate';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      // "tanggal": formatedTanggal.toString(),
      "tanggalawal": '',
      "tanggakhir": '',
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

  Future laporanbyDateFuture() async {
    String theUrl =
        getMyUrl.url + 'prosses/laporanbydate'; //NOTE url laporan angka
    final res = await http.post(
      //NOTE post Laporan Get
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "tanggalawal": cTglAwal.text,
        "tanggalakhir": cTglAkhir.text,
      },
    );
    var laporanbydateJSON2 = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(
        () {
          reqproses2 = laporanbydateJSON2['reqproses'];
          reqselesai2 = laporanbydateJSON2['reqselesai'];
          reqtotal2 = laporanbydateJSON2['reqtotal'];
        },
      );
    }
    if (kDebugMode) {
      print(laporanbydateJSON2);
      print("ini future");
    }

    return laporanbydateJSON2;
  }

  Future laporanbyDateFuturechart() async {
    String theUrl =
        getMyUrl.url + 'prosses/grafiklaporanrequest'; //NOTE url laporan angka
    final res = await http.post(
      //NOTE post Laporan Get
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "tanggalawal": cTglAwal.text,
        "tanggalakhir": cTglAkhir.text,
      },
    );
    List<ChartRequest> jsondatachart = chartRequestFromJson(res.body);
    if (mounted) {
      setState(() {
        dataJSONchartrequest = jsondatachart;
      });
    }

    if (kDebugMode) {
      print("Chartttttt:");
      print(dataJSONchartrequest);
    }
    return dataJSONchartrequest;
  }

  List<charts.Series<ChartRequest, String>> chartRequest() {
    return [
      charts.Series<ChartRequest, String>(
        data: dataJSONchartrequest,
        id: 'Laporan Request',
        domainFn: (ChartRequest json, _) => json.tanggal.toString(),
        measureFn: (ChartRequest json, _) => int.tryParse(json.jumlah),
        labelAccessorFn: (ChartRequest json, _) => json.jumlah.toString(),
        seriesColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
    ];
  }

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

  Future loadSalesData() async {
    final String jsonString = await getJsonFromFirebase();
    final dynamic jsonResponse = json.decode(jsonString);
    for (Map<String, dynamic> i in jsonResponse) {
      chartData.add(SalesData.fromJson(i));
    }
  }

  Future<String> getJsonFromFirebase() async {
    String url =
        "http://inventory.akses-yt.id/api/prosses/grafiklaporanrequest";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "tanggalawal": cTglAwal.text,
        "tanggalakhir": cTglAkhir.text,
      },
    );
    if (kDebugMode) {
      print(response.body);
      print("firebase" + response.body);
    }
    return response.body;
  }

  @override
  void initState() {
    laporanbyDate();
    // loadSalesData();
    // getLaporanrequest();
    // getRequestkeluar();
    // getRequestreturn();
    // _tooltipBehavior = TooltipBehavior(enable: true);
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
          : Container(
              padding: EdgeInsets.only(
                top: mediaQueryData.size.height * 0.01,
                left: mediaQueryData.size.height * 0.01,
                right: mediaQueryData.size.height * 0.01,
                // bottom: mediaQueryData.size.height * 0.02,
              ),
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
              child: ListView(
                children: [
                  filter(),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: mediaQueryData.size.height * 0.01),
                  ),
                  cTglAkhir.text != null ||
                          cTglAwal.text != null ||
                          cStatus != null
                      ? Column(
                          children: [
                            FutureBuilder(
                              future: laporanbyDateFuture(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? cardStockfuture()
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                            FutureBuilder(
                              future: laporanbyDateFuturechart(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? chartrequestview()
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                            FutureBuilder(
                              future: getLaporanrequest(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) print(snapshot.error);
                                return snapshot.hasData
                                    ? listrequest()
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              },
                            ),
                            // FutureBuilder(
                            //   future: loadSalesData(),
                            //   builder: (context, snapshot) {
                            //     if (snapshot.hasError) print(snapshot.error);
                            //     return snapshot.hasData
                            //         ? const Center(
                            //             child: CircularProgressIndicator(),
                            //           )
                            //         : SfCartesianChart(
                            //             // legend: Legend(isVisible: true),
                            //             primaryXAxis: CategoryAxis(),
                            //             tooltipBehavior: _tooltipBehavior,
                            //             // Chart title
                            //             title: ChartTitle(
                            //                 text: 'Half yearly sales analysis'),
                            //             series: <
                            //                 ChartSeries<SalesData, String>>[
                            //               LineSeries<SalesData, String>(
                            //                   dataSource: chartData,
                            //                   xValueMapper:
                            //                       (SalesData sales, _) =>
                            //                           sales.month,
                            //                   yValueMapper:
                            //                       (SalesData sales, _) =>
                            //                           sales.sales,
                            //                   // Enable data label
                            //                   dataLabelSettings:
                            //                       const DataLabelSettings(
                            //                           isVisible: true))
                            //             ],
                            //           );
                            //   },
                            // ),
                          ],
                        )
                      : cardStockfuture(),
                  // _cobachart(),
                  //NOTE Expansion Disable
                  // ExpansionTile(
                  //   leading: Column(
                  //     children: [
                  //       IconButton(
                  //         padding: EdgeInsets.only(
                  //           left: mediaQueryData.size.height * 0.012,
                  //           right: mediaQueryData.size.height * 0.012,
                  //           // bottom: mediaQueryData.size.height * 0.01,
                  //           // top:
                  //           //     mediaQueryData.size.height *
                  //           //         0.02,
                  //         ),
                  //         icon: const Icon(Icons.wifi_protected_setup_sharp),
                  //         color: Colors.green,
                  //         iconSize: 40.0,
                  //         onPressed: () {
                  //           // Navigator.pushNamed(context, '/DetailSurat');
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  //   title: const Text("Request Proses"),
                  //   children: [
                  //     ListSparepartKeluar(
                  //         dataJSONkeluar: dataJSONkeluar,
                  //         mediaQueryData: mediaQueryData),
                  //   ],
                  // ),

                  // ExpansionTile(
                  //   leading: Column(
                  //     children: [
                  //       IconButton(
                  //         padding: EdgeInsets.only(
                  //           left: mediaQueryData.size.height * 0.012,
                  //           right: mediaQueryData.size.height * 0.012,
                  //           // bottom: mediaQueryData.size.height * 0.01,
                  //           // top:
                  //           //     mediaQueryData.size.height *
                  //           //         0.02,
                  //         ),
                  //         icon: const Icon(Icons.done),
                  //         color: Colors.blue,
                  //         iconSize: 40.0,
                  //         onPressed: () {
                  //           // Navigator.pushNamed(context, '/DetailSurat');
                  //         },
                  //       ),
                  //     ],
                  //   ),
                  //   title: const Text("Request Selesai"),
                  //   children: [
                  //     ListSparepartReturn(
                  //         dataJSONreturn: dataJSONreturn,
                  //         mediaQueryData: mediaQueryData),
                  //   ],
                  // ),
                ],
              ),
            ),
    );
  }

  Widget _cobachart() {
    return SizedBox(
      height: 500,
      child: FutureBuilder(
        future: getJsonFromFirebase(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return SfCartesianChart(
              // legend: Legend(isVisible: true),
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: _tooltipBehavior,
              // Chart title
              title: ChartTitle(text: 'Half yearly sales analysis'),
              series: <ChartSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                    dataSource: chartData,
                    xValueMapper: (SalesData sales, _) => sales.month,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ],
            );
          } else {
            return Card(
              elevation: 5.0,
              child: SizedBox(
                height: 100,
                width: 400,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text('Retriving Firebase data...',
                          style: TextStyle(fontSize: 20.0)),
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: CircularProgressIndicator(
                          semanticsLabel: 'Retriving Firebase data',
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent),
                          backgroundColor: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
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

                  // Row(
                ],
              ),
              // SizedBox(height: mediaQueryData.size.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  Widget listrequest() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
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
          var statuslaporan;
          if (dataJSONreturn?[i]["status"] == "Diterima") {
            statuslaporan = Container(
              margin: const EdgeInsets.only(right: 15.0),
              width: mediaQueryData.size.height * 0.12,
              height: mediaQueryData.size.height * 0.12,
              color: Colors.orange,
              child: Column(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.012,
                      right: mediaQueryData.size.height * 0.012,
                      // bottom: mediaQueryData.size.height * 0.01,
                      top: mediaQueryData.size.height * 0.02,
                    ),
                    icon: const Icon(Icons.done),
                    color: Colors.white,
                    iconSize: 50.0,
                    onPressed: () {
                      // Navigator.pushNamed(context, '/DetailSurat');
                    },
                  ),
                  Text(
                    dataJSONreturn?[i]["status"],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          } else if (dataJSONreturn?[i]["status"] == "Dikirim") {
            statuslaporan = Container(
              margin: const EdgeInsets.only(right: 15.0),
              width: mediaQueryData.size.height * 0.12,
              height: mediaQueryData.size.height * 0.12,
              color: Colors.blue,
              child: Column(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.012,
                      right: mediaQueryData.size.height * 0.012,
                      // bottom: mediaQueryData.size.height * 0.01,
                      top: mediaQueryData.size.height * 0.02,
                    ),
                    icon: const Icon(Icons.send),
                    color: Colors.white,
                    iconSize: 50.0,
                    onPressed: () {
                      // Navigator.pushNamed(context, '/DetailSurat');
                    },
                  ),
                  Text(
                    dataJSONreturn?[i]["status"],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          } else if (dataJSONreturn?[i]["status"] == "Selesai") {
            statuslaporan = Container(
              margin: const EdgeInsets.only(right: 15.0),
              width: mediaQueryData.size.height * 0.12,
              height: mediaQueryData.size.height * 0.12,
              color: Colors.green,
              child: Column(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.012,
                      right: mediaQueryData.size.height * 0.012,
                      // bottom: mediaQueryData.size.height * 0.01,
                      top: mediaQueryData.size.height * 0.02,
                    ),
                    icon: const Icon(Icons.done_all_outlined),
                    color: Colors.white,
                    iconSize: 50.0,
                    onPressed: () {
                      // Navigator.pushNamed(context, '/DetailSurat');
                    },
                  ),
                  Text(
                    dataJSONreturn?[i]["status"],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          } else if (dataJSONreturn?[i]["status"] == "Menunggu") {
            statuslaporan = Container(
              margin: const EdgeInsets.only(right: 15.0),
              width: mediaQueryData.size.height * 0.12,
              height: mediaQueryData.size.height * 0.12,
              color: Colors.grey,
              child: Column(
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.012,
                      right: mediaQueryData.size.height * 0.012,
                      // bottom: mediaQueryData.size.height * 0.01,
                      top: mediaQueryData.size.height * 0.02,
                    ),
                    icon: const Icon(Icons.access_time),
                    color: Colors.white,
                    iconSize: 50.0,
                    onPressed: () {
                      // Navigator.pushNamed(context, '/DetailSurat');
                    },
                  ),
                  Text(
                    dataJSONreturn?[i]["status"],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            );
          }
          return Container(
            padding: EdgeInsets.only(
              top: mediaQueryData.size.height * 0.01,
              left: mediaQueryData.size.height * 0.01,
              right: mediaQueryData.size.height * 0.01,
              // bottom: mediaQueryData.size.height * 0.005,
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
                      Column(
                        children: [
                          statuslaporan
                          // Container(
                          //   margin: const EdgeInsets.only(right: 15.0),
                          //   width: mediaQueryData.size.height * 0.12,
                          //   height: mediaQueryData.size.height * 0.12,
                          //   color: Colors.blue,
                          //   child: Column(
                          //     children: [
                          //       IconButton(
                          //         padding: EdgeInsets.only(
                          //           left: mediaQueryData.size.height * 0.012,
                          //           right: mediaQueryData.size.height * 0.012,
                          //           // bottom: mediaQueryData.size.height * 0.01,
                          //           top: mediaQueryData.size.height * 0.02,
                          //         ),
                          //         icon: const Icon(Icons.done),
                          //         color: Colors.white,
                          //         iconSize: 50.0,
                          //         onPressed: () {
                          //           // Navigator.pushNamed(context, '/DetailSurat');
                          //         },
                          //       ),
                          //       Text(
                          //         dataJSONreturn?[i]["status"],
                          //         style: const TextStyle(
                          //           fontSize: 12,
                          //           color: Colors.white,
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
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
                                          dataJSONreturn?[i]["tanggal"] +
                                          " " +
                                          dataJSONreturn?[i]["jam"],
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
                                  child: dataJSONreturn?[i]["kodereq"] != null
                                      ? Text(
                                          dataJSONreturn?[i]["kodereq"],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
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

  Widget chartrequestview() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Card(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: mediaQueryData.size.height * 0.02,
              right: mediaQueryData.size.height * 0.01,
              // bottom: mediaQueryData.size.height * 0.01,
              // top: mediaQueryData.size.height * 0.02,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Chart Laporan",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.brown[800],
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.admin_panel_settings_rounded),
                  color: Colors.yellow[800],
                  iconSize: 25.0,
                  onPressed: () {
                    // Navigator.pushNamed(context, '/DetailBapokting');
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: mediaQueryData.size.height * 0.4,
            child: charts.BarChart(
              // createChart(),
              chartRequest(),
              animate: true,
              // barGroupingType: charts.BarGroupingType.grouped,
              vertical: false,

              behaviors: [
                charts.SeriesLegend(
                  // desiredMaxRows: 2,
                  desiredMaxColumns: 3,
                )
              ],
              domainAxis: const charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(
                    // labelRotation: 60,
                    ),
              ),

              barRendererDecorator: charts.BarLabelDecorator<String>(),
            ),
          ),
        ],
      ),
    );
  }

  Widget filter() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      color: Colors.blue,
      child: ExpansionTile(
        title: const Text("Filter Sparepart",
            style: TextStyle(
              color: Colors.white,
            )),
        trailing: const Icon(
          Icons.search,
          color: Colors.white,
        ),
        children: [
          formfilter(),
        ],
      ),
    );
  }

  Widget cardStock() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      height: mediaQueryData.size.height * 0.1,
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
                          "$reqproses",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Proses',
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
                          "$reqselesai",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Selesai',
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
                          "$reqtotal",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Total',
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

  Widget cardStockfuture() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      height: mediaQueryData.size.height * 0.1,
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
                          "$reqproses2",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Proses',
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
                          "$reqselesai2",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Selesai',
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
                          "$reqtotal2",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 25.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          'Total',
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

  Widget formfilter() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: mediaQueryData.size.height * 0.01,
        right: mediaQueryData.size.height * 0.01,
        // bottom: mediaQueryData.size.height * 0.01,
        // top: mediaQueryData.size.height * 0.02,
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
                    Icons.info_outline,
                    color: Colors.grey,
                  ),
                  Text(
                    "    Pilih Status",
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              isExpanded: true,
              items: _status.map(
                (item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(item['status']),
                  );
                },
              ).toList(),
              onChanged: (newVal) {
                setState(
                  () {
                    cStatus = newVal;
                  },
                );
              },
              value: cStatus,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 60.0,
            child: DateTimeField(
              controller: cTglAwal,
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100),
                );
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                //contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.date_range,
                  color: Colors.grey[600],
                ),
                hintText: 'Tanggal Awal',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            height: 60.0,
            child: DateTimeField(
              controller: cTglAkhir,
              format: format,
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                  context: context,
                  firstDate: DateTime(1900),
                  initialDate: currentValue ?? DateTime.now(),
                  lastDate: DateTime(2100),
                );
              },
              decoration: InputDecoration(
                border: InputBorder.none,
                //contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.date_range,
                  color: Colors.grey[600],
                ),
                hintText: 'Tanggal Akhir',
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
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

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}

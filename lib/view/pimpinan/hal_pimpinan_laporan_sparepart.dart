import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:inventory_app/service/service.dart';
import 'package:inventory_app/view/pimpinan/detail/detail_filter_sparepart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HalPimpinanLaporanSparepart extends StatefulWidget {
  const HalPimpinanLaporanSparepart({Key? key}) : super(key: key);

  @override
  State<HalPimpinanLaporanSparepart> createState() =>
      _HalPimpinanLaporanSparepartState();
}

//CEK
class _HalPimpinanLaporanSparepartState
    extends State<HalPimpinanLaporanSparepart> {
  String? barangmasuk;
  String? barangkeluar;
  int? barangreturn;
  List<SalesData> chartData = [];
  List? laporansparepartJSON;
  late TooltipBehavior _tooltipBehavior;
  String? cStatus;
  TextEditingController cTglAwal = TextEditingController();
  TextEditingController cTglAkhir = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
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
  var isloading = false;
// ignore: unused_field
  bool _isLoggedIn = false;

//NOTE API Laporan Request
  Future<dynamic> laporanRequest() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/laporanrequest';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      "tanggalawal": '',
      "tanggalakhir": '',
      "status": ''
    });
    if (res.statusCode == 200) {
      setState(
        () {
          laporansparepartJSON = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print("Laporan Sparepart :");
      print(laporansparepartJSON);
    }
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
      "tanggalawal": '',
      "tanggalkhir": '',
    });
    var laporanbydateJSON = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(
        () {
          barangmasuk = laporanbydateJSON['barangmasuk'];
          barangkeluar = laporanbydateJSON['barangkeluar'];
          barangreturn = laporanbydateJSON['barangreturn'];
          isloading = false;
        },
      );
    }
    if (kDebugMode) {
      print("LaporanbyDate : ");
      print(laporanbydateJSON);
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
        "http://inventory.akses-yt.id/api/prosses/grafiklaporansperpart";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "tanggalawal": '',
        "tanggalakhir": '',
      },
    );
    if (kDebugMode) {
      print(response.body);
    }
    return response.body;
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
    laporanbyDate();
    loadSalesData();
    laporanRequest();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Laporan Sparepart',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(),
          ),
        ),
        elevation: 0,
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    filter(),
                    cardbydate(),
                    cardchart(),
                    cardlistsparepart(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _tombolsearch() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton(
        onPressed: () async {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPimpinanLaporanSparepart(
                dTglAwal: cTglAwal.text,
                dTglAkhir: cTglAkhir.text,
                dStatus: cStatus.toString(),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        child: Text(
          'FILTER',
          style: TextStyle(
            color: Colors.brown[800],
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget filter() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
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

  Widget cardchart() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      height: mediaQueryData.size.height * 0.5,
      child: FutureBuilder(
        future: getJsonFromFirebase(),
        builder: (context, snapShot) {
          if (snapShot.hasData) {
            return SfCartesianChart(
              legend: Legend(
                isVisible: true,
                position: LegendPosition.bottom,
              ),
              primaryXAxis: CategoryAxis(),
              tooltipBehavior: _tooltipBehavior,
              // Chart title
              title: ChartTitle(text: 'Laporan Sparepart'),
              series: <ChartSeries<SalesData, String>>[
                LineSeries<SalesData, String>(
                  name: "Masuk",
                  dataSource: chartData,
                  xValueMapper: (SalesData sales, _) => sales.tanggal,
                  yValueMapper: (SalesData sales, _) => sales.jumlah,
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget cardlistsparepart() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount:
          laporansparepartJSON == null ? 0 : laporansparepartJSON?.length,
      itemBuilder: (BuildContext context, int i) {
        if (laporansparepartJSON?[i]["id"] == 'NotFound') {
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
                  "Tidak ada Sparepart",
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
                      SizedBox(
                        // margin: const EdgeInsets.only(right: 15.0),
                        width: mediaQueryData.size.height * 0.15,
                        height: mediaQueryData.size.height * 0.12,
                        child: laporansparepartJSON?[i]["foto"] != null
                            ? CachedNetworkImage(
                                imageUrl: laporansparepartJSON?[i]["foto"],
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
                      SizedBox(
                        width: mediaQueryData.size.width * 0.02,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                laporansparepartJSON?[i]["sperpart"],
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
                              child: laporansparepartJSON?[i]["mesin"] != null
                                  ? Text(
                                      'Mesin : ' +
                                          laporansparepartJSON?[i]["mesin"],
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
                              child: laporansparepartJSON?[i]["tanggal"] != null
                                  ? Text(
                                      "Tanggal : " +
                                          laporansparepartJSON?[i]["tanggal"],
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
                                  child:
                                      laporansparepartJSON?[i]["jumlah"] != null
                                          ? Text(
                                              'Jumlah : ' +
                                                  laporansparepartJSON?[i]
                                                      ["jumlah"],
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
                                  child: laporansparepartJSON?[i]["jam"] != null
                                      ? Text(
                                          'Jam : ' +
                                              laporansparepartJSON?[i]["jam"],
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
          _tombolsearch(),
          Padding(
            padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.01),
          ),
        ],
      ),
    );
  }

  Widget cardbydate() {
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
                        barangmasuk == null
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            : Text(
                                "$barangmasuk",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                        const SizedBox(width: 8.0),
                        barangmasuk == null
                            ? const Text(
                                'Memuat..',
                                style: TextStyle(
                                  color: Color(0xFF2e2e2e),
                                  fontSize: 13.0,
                                ),
                              )
                            : const Text(
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
                        barangkeluar == null
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            : Text(
                                "$barangkeluar",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                        const SizedBox(width: 8.0),
                        barangkeluar == null
                            ? const Text(
                                'Memuat..',
                                style: TextStyle(
                                  color: Color(0xFF2e2e2e),
                                  fontSize: 13.0,
                                ),
                              )
                            : const Text(
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
                        barangreturn == null
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            : Text(
                                "$barangreturn",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                        const SizedBox(width: 8.0),
                        barangreturn == null
                            ? const Text(
                                'Memuat..',
                                style: TextStyle(
                                  color: Color(0xFF2e2e2e),
                                  fontSize: 13.0,
                                ),
                              )
                            : const Text(
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
}

class SalesData {
  SalesData(
    this.tanggal,
    this.jumlah,
  );

  final String tanggal;
  final int jumlah;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['tanggal'].toString(),
      int.parse(parsedJson['jumlah']),
    );
  }
}

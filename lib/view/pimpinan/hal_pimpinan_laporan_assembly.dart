import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:inventory_app/service/service.dart';
import 'package:inventory_app/style/style.dart';
import 'package:inventory_app/view/pimpinan/detail/detail_filter_assembly.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HalPimpinanLaporanAssembly extends StatefulWidget {
  const HalPimpinanLaporanAssembly({Key? key}) : super(key: key);

  @override
  State<HalPimpinanLaporanAssembly> createState() =>
      _HalPimpinanLaporanAssemblyState();
}

class _HalPimpinanLaporanAssemblyState
    extends State<HalPimpinanLaporanAssembly> {
  int? reqproses;
  int? reqselesai;
  int? reqtotal;
  List<SalesData> chartData = [];
  List? laporanmesinJSON;
  late TooltipBehavior _tooltipBehavior;
  String? cMesin;
  TextEditingController cTglAwal = TextEditingController();
  TextEditingController cTglAkhir = TextEditingController();
  final format = DateFormat("yyyy-MM-dd");
  List? listmesin = [];
  var isloading = false;
// ignore: unused_field
  bool _isLoggedIn = false;

  Future<dynamic> laporanMesin() async {
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/laporanmesin';
    final res = await http.post(Uri.parse(theUrl), headers: {
      "name": "invent",
      "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
    }, body: {
      "tanggalawal": '',
      "tanggalakhir": '',
      "mesin": ''
    });
    if (res.statusCode == 200) {
      setState(
        () {
          laporanmesinJSON = json.decode(res.body);
        },
      );
      setState(() {
        isloading = false;
      });
    }
    if (kDebugMode) {
      print("Laporan Sparepart :");
      print(laporanmesinJSON);
    }
  }

  Future getMesin() async {
    String theUrl = getMyUrl.url + 'prosses/mesin';
    var res = await http.get(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
    );

    setState(
      () {
        listmesin = json.decode(res.body);
      },
    );
    if (kDebugMode) {
      print(listmesin);
    }
  }

  void laporanbyDate() async {
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
          reqproses = laporanbydateJSON['reqproses'];
          reqselesai = laporanbydateJSON['reqselesai'];
          reqtotal = laporanbydateJSON['reqtotal'];
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
        "https://dwianugrahsentosa.phdcorp.id/api/prosses/grafiklaporanmesin";
    http.Response response = await http.post(
      Uri.parse(url),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "tanggalawal": '',
        "tanggalakhir": '',
        "mesin": '',
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
    laporanMesin();
    getMesin();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgPimpinan,
        title: Text(
          'Laporan Assembly',
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
                    // cardbydate(),
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
              builder: (context) => FilterPimpinanLaporanAssembly(
                dTglAwal: cTglAwal.text,
                dTglAkhir: cTglAkhir.text,
                dMesin: cMesin.toString(),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
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
        title: const Text("Filter Assembly",
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
              primaryXAxis: CategoryAxis(
                  // arrangeByIndex: true,
                  ),
              tooltipBehavior: _tooltipBehavior,
              // Chart title
              title: ChartTitle(text: 'Laporan Assembly'),
              series: <ChartSeries<SalesData, String>>[
                ColumnSeries<SalesData, String>(
                  name: "Masuk",
                  dataSource: chartData,
                  xValueMapper: (SalesData sales, _) => sales.tanggal,
                  yValueMapper: (SalesData sales, _) => sales.jumlah,
                  dataLabelMapper: (SalesData sales, _) => sales.nama,
                  // Enable data label
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelAlignment: ChartDataLabelAlignment.middle,
                    angle: 270,
                  ),
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
      itemCount: laporanmesinJSON == null ? 0 : laporanmesinJSON?.length,
      itemBuilder: (BuildContext context, int i) {
        if (laporanmesinJSON?[i]["id"] == 'NotFound') {
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
                  "Tidak ada Data",
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
          // ignore: prefer_typing_uninitialized_variables
          var status;
          if (laporanmesinJSON?[i]["status"] == "Selesai") {
            status = Material(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.green[800],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.012,
                      right: mediaQueryData.size.height * 0.012,
                      // bottom: mediaQueryData.size.height * 0.01,
                      // top: mediaQueryData.size.height * 0.02,
                    ),
                    icon: const Icon(Icons.done),
                    color: Colors.white,
                    iconSize: 50.0,
                    onPressed: () {},
                  ),
                  Text(
                    laporanmesinJSON?[i]["status"],
                    style: const TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      //fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          } else {
            status = Material(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.orange,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.012,
                      right: mediaQueryData.size.height * 0.012,
                      // bottom: mediaQueryData.size.height * 0.01,
                      // top: mediaQueryData.size.height * 0.02,
                    ),
                    icon: const Icon(Icons.lan_outlined),
                    color: Colors.white,
                    iconSize: 50.0,
                    onPressed: () {
                      // Navigator.pushNamed(context, '/DetailSurat');
                    },
                  ),
                ],
              ),
            );
          }
          return Container(
            padding: EdgeInsets.only(
              top: mediaQueryData.size.height * 0.01,
              left: mediaQueryData.size.height * 0.01,
              right: mediaQueryData.size.height * 0.01,
            ),
            child: Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
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
                        width: mediaQueryData.size.height * 0.12,
                        height: mediaQueryData.size.height * 0.15,
                        child: status,
                      ),
                      SizedBox(
                        width: mediaQueryData.size.width * 0.02,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                top: mediaQueryData.size.height * 0.005,
                                left: mediaQueryData.size.height * 0.005,
                                right: mediaQueryData.size.height * 0.005,
                                bottom: mediaQueryData.size.height * 0.005,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green[600],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(5.0)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.numbers,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: mediaQueryData.size.height * 0.01,
                                  ),
                                  Text(
                                    laporanmesinJSON?[i]["kodereq"],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin:
                                  const EdgeInsets.only(top: 5.0, bottom: 5.0),
                              child: Text(
                                laporanmesinJSON?[i]["sperpart"],
                                style: const TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  //fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 5.0),
                              child: laporanmesinJSON?[i]["mesin"] != null
                                  ? Text(
                                      'Mesin : ' +
                                          laporanmesinJSON?[i]["mesin"],
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
                              child: laporanmesinJSON?[i]["tanggal"] != null
                                  ? Text(
                                      "Tanggal : " +
                                          laporanmesinJSON?[i]["tanggal"] +
                                          " " +
                                          laporanmesinJSON?[i]["jam"],
                                      style: const TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text(
                                      '-',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 5.0),
                                  child: laporanmesinJSON?[i]["jumlah"] != null
                                      ? Text(
                                          'Jumlah : ' +
                                              laporanmesinJSON?[i]["jumlah"],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      right: 5.0, bottom: 5.0),
                                  child: laporanmesinJSON?[i]["kodesperpart"] !=
                                          null
                                      ? Text(
                                          'Kode : ' +
                                              laporanmesinJSON?[i]
                                                  ["kodesperpart"],
                                          style: const TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : const Text(
                                          '-',
                                          style: TextStyle(
                                            fontSize: 13.0,
                                            color: Colors.black,
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
                  Icon(
                    Icons.grid_view_sharp,
                    color: Colors.grey[600],
                  ),
                  Text(
                    "    Pilih Mesin",
                    style: TextStyle(
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              isExpanded: true,
              items: listmesin?.map(
                (item) {
                  return DropdownMenuItem<String>(
                    value: item['id'].toString(),
                    child: Text(item['nama']),
                  );
                },
              ).toList(),
              onChanged: (newVal) {
                setState(
                  () {
                    cMesin = newVal;
                  },
                );
              },
              value: cMesin,
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
                        reqproses == null
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            : Text(
                                "$reqproses",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                        const SizedBox(width: 8.0),
                        reqproses == null
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
                        reqselesai == null
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            : Text(
                                "$reqselesai",
                                style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                        const SizedBox(width: 8.0),
                        reqselesai == null
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
                        reqtotal == null
                            ? const Text(
                                "0",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              )
                            : Text(
                                "$reqtotal",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25.0,
                                ),
                              ),
                        const SizedBox(width: 8.0),
                        reqtotal == null
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
    this.nama,
  );

  final String tanggal;
  final int jumlah;
  final String nama;

  factory SalesData.fromJson(Map<String, dynamic> parsedJson) {
    return SalesData(
      parsedJson['tanggal'].toString(),
      int.parse(parsedJson['jumlah']),
      parsedJson['nama'].toString(),
    );
  }
}

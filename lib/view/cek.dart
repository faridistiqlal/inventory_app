import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<SalesData> chartData = [];
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    loadSalesData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
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
        "tanggalawal": '',
        "tanggalakhir": '',
      },
    );
    if (kDebugMode) {
      print(response.body);
    }
    return response.body;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter chart'),
      ),
      body: Center(
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
                      dataLabelSettings:
                          const DataLabelSettings(isVisible: true))
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
      ),
    );
  }
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

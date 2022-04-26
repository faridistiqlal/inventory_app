import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inventory_app/style/style.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';

class DetailListSparepart extends StatefulWidget {
  final String dKode;

  const DetailListSparepart({
    Key? key,
    required this.dKode,
  }) : super(key: key);

  @override
  State<DetailListSparepart> createState() => _DetailListSparepartState();
}

class _DetailListSparepartState extends State<DetailListSparepart> {
  var isloading = false;
  String kode = "";
  String nama = "";
  String credential = "";
  String jumlah = "";
  String kembali = "";
  String status = "";
  Future<dynamic> getRequestbyKode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });
    String theUrl = getMyUrl.url + 'prosses/sperpartbyid';
    final res = await http.post(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
      body: {
        "id": widget.dKode,
      },
    );
    var requestdetailJSON = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(
        () {
          pref.setString("nama", requestdetailJSON['nama']);
          pref.setString("credential", requestdetailJSON['credential']);
          pref.setString("kode", requestdetailJSON['kode']);
          pref.setString("jumlah", requestdetailJSON['jumlah']);
          pref.setString("status", requestdetailJSON['status']);
          pref.setString("kembali", requestdetailJSON['kembali']);
          nama = pref.getString("nama")!;
          credential = pref.getString("credential")!;
          kode = pref.getString("kode")!;
          jumlah = pref.getString("jumlah")!;
          status = pref.getString("status")!;
          kembali = pref.getString("kembali")!;
        },
      );
      setState(() {
        isloading = false;
      });

      if (kDebugMode) {
        print(requestdetailJSON);
        print("cek id user =");
        print(pref.getString("IdUser"));
      }
    }
    return requestdetailJSON;
  }

  Future<bool> _onWillPop() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove("nama");
    pref.remove("kode");
    pref.remove("credential");
    pref.remove("jumlah");
    pref.remove("status");
    pref.remove("kembali");
    Navigator.pop(context);
    if (kDebugMode) {
      print("hapus id  dll");
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: titleText, //change your color here
          ),
          title: Text(
            widget.dKode,
            style: const TextStyle(
              color: titleText,
            ),
          ),
          elevation: 0,
        ),
        // body: ,
      ),
    );
  }
}

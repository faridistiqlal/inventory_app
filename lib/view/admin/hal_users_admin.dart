import 'package:flutter/material.dart';
import 'dart:convert';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inventory_app/service/service.dart';
// import 'package:shimmer/shimmer.dart';

class HalUsersAdmin extends StatefulWidget {
  const HalUsersAdmin({Key? key}) : super(key: key);

  @override
  _HalUsersAdminState createState() => _HalUsersAdminState();
}

class _HalUsersAdminState extends State<HalUsersAdmin> {
  var isloading = false;
  List<dynamic> _allUsers = [];
  // This holds a list of fiction users
  // You can use data fetched from a database or a server as well
  // final List<Map<String, dynamic>> _allUsers = [],
  //   {"id": 1, "name": "Andy", "age": 29},
  //   {"id": 2, "name": "Aragon", "age": 40},
  //   {"id": 3, "name": "Bob", "age": 5},
  //   {"id": 4, "name": "Barbara", "age": 35},
  //   {"id": 5, "name": "Candy", "age": 21},
  //   {"id": 6, "name": "Colin", "age": 55},
  //   {"id": 7, "name": "Audra", "age": 30},
  //   {"id": 8, "name": "Banana", "age": 14},
  //   {"id": 9, "name": "Caversky", "age": 100},
  //   {"id": 10, "name": "Becky", "age": 32},
  // ];

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

  // This list holds the data for the list view
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
            (user) => user["nama"].toLowerCase().contains(
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
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Kindacode.com'),
          ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Cari kode barang ',
                  suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _foundUsers.length,
                      itemBuilder: (context, index) => Card(
                        key: ValueKey(_foundUsers[index]["id"]),
                        color: Colors.amberAccent,
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          leading: Text(
                            _foundUsers[index]["id"].toString(),
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(_foundUsers[index]['nama']),
                          subtitle: Text(
                              '${_foundUsers[index]["kode"].toString()} years old'),
                        ),
                      ),
                    )
                  : const Text(
                      'No results found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

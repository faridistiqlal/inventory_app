// import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:inventory_app/class/header.dart';
import 'package:inventory_app/style/style.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inventory_app/service/service.dart';

class AddSparepart extends StatefulWidget {
  const AddSparepart({Key? key}) : super(key: key);

  @override
  _AddSparepartState createState() => _AddSparepartState();
}

class _AddSparepartState extends State<AddSparepart> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  // List<String>? allMesin = [];
  List allMesin = [];
  bool _loading = false;
  bool _inProcess = false;

  TextEditingController cMesin = TextEditingController();
  String? cLayanan;
  TextEditingController cSpesialis = TextEditingController();
  TextEditingController cMoto = TextEditingController();
  TextEditingController cKarir = TextEditingController();
  TextEditingController cPetugas = TextEditingController();
  File? _selectedFile;

  @override
  void initState() {
    getListMesin();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future getListMesin() async {
    String theUrl = getMyUrl.url + 'prosses/mesin';
    var res = await http.get(
      Uri.parse(theUrl),
      headers: {
        "name": "invent",
        "key": "THplZ0lQcGh1N0FKN2FWdlgzY21FQT09",
      },
    );
    var mesin = json.decode(res.body);
    if (kDebugMode) {
      print("list mesin =");
      print(mesin);
    }
    setState(
      () {
        allMesin = mesin;
      },
    );
  }

  getImage(ImageSource source) async {
    setState(
      () {
        _inProcess = true;
      },
    );

    XFile? image = await ImagePicker().pickImage(source: source);

    if (image != null) {
      File? cropped = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.5, ratioY: 1),
        compressQuality: 100,
        maxWidth: 720,
        maxHeight: 480,
        cropStyle: CropStyle.rectangle,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.black,
          toolbarTitle: "Crop",
          statusBarColor: Colors.black,
          backgroundColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          hideBottomControls: true,
        ),
      );

      setState(
        () {
          _selectedFile = cropped;
          _inProcess = false;
        },
      );
    } else {
      setState(
        () {
          _inProcess = false;
        },
      );
    }
  }

  void clearimage() {
    setState(
      () {
        _selectedFile = null;
      },
    );
  }

  Future upload(File _selectedFile) async {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      const Duration(seconds: 3),
      () async {
        var stream = http.ByteStream(
          // ignore: deprecated_member_use
          DelegatingStream.typed(
            _selectedFile.openRead(),
          ),
        );
        var length = await _selectedFile.length();
        // var uri = Uri.parse(
        //     "http://192.168.43.118/klinikapp/webservice/Dokter/InputData");
        var uri = Uri.parse(
            "http://klinik.antrianpasien.id/webservice/Dokter/InputData");
        var request = http.MultipartRequest("POST", uri);
        var multipartFile = http.MultipartFile(
          "foto",
          stream,
          length,
          filename: basename(_selectedFile.path),
        );
        request.fields['nama'] = cMesin.text;
        request.fields['spesialis'] = cSpesialis.text;
        request.fields['moto'] = cMoto.text;
        request.fields['karir'] = cKarir.text;
        request.fields['petugas'] = pref.getString('IdUser').toString();
        request.files.add(multipartFile);
        var response = await request.send();
        if (response.statusCode == 200) {
          if (kDebugMode) {
            print("Image Uploaded");
          }
          setState(
            () {
              _loading = false;
            },
          );
          SnackBar snackBar = SnackBar(
            duration: const Duration(seconds: 5),
            elevation: 6.0,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.01,
                ),
                const Text(
                  'Dokter Berhasil di Tambah',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'LIHAT',
              textColor: Colors.white,
              onPressed: () {
                Navigator.pushReplacementNamed(this.context, '/ListDokter');
                if (kDebugMode) {
                  print('Berhasil');
                }
              },
            ),
          );
          // ignore: deprecated_member_use
          scaffoldKey.currentState?.showSnackBar(snackBar);
          cMesin.clear();
          cSpesialis.clear();
          cMoto.clear();
          cKarir.clear();
          clearimage();
        } else {
          setState(
            () {
              _loading = false;
            },
          );
          SnackBar snackBar = SnackBar(
            duration: const Duration(seconds: 5),
            elevation: 6.0,
            behavior: SnackBarBehavior.floating,
            content: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Icon(
                  Icons.error,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  width: mediaQueryData.size.width * 0.01,
                ),
                const Text(
                  'Tambah dokter gagal',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'GAGAL',
              textColor: Colors.white,
              onPressed: () {
                if (kDebugMode) {
                  print('Gagal');
                }
              },
            ),
          );
          // ignore: deprecated_member_use
          scaffoldKey.currentState?.showSnackBar(snackBar);
          if (kDebugMode) {
            print("Upload Failed");
          }
        }
        response.stream.transform(utf8.decoder).listen(
          (value) {
            if (kDebugMode) {
              print(value);
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: primaryColor,
        opacity: 0.5,
        progressIndicator: const SpinKitWave(
          color: Colors.white,
          size: 50,
        ),
        child: Stack(
          children: <Widget>[
            HeaderAddSparepart(mediaQueryData: mediaQueryData),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: mediaQueryData.size.height * 0.02,
                  right: mediaQueryData.size.height * 0.02,
                  // bottom: mediaQueryData.size.height * 0.02,
                  // top: mediaQueryData.size.height * 0.001,
                ),
                child: ListView(
                  children: <Widget>[
                    _inputMesin(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputSpesialis(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputMoto(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _inputKarir(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getImageWidget(),
                        Column(
                          children: [
                            _cameraButton(),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: mediaQueryData.size.height * 0.01),
                            ),
                            _galeryButton(),
                          ],
                        ),
                        (_inProcess)
                            ? Container(
                                color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.95,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const Center()
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.03),
                    ),
                    _loginButton(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: mediaQueryData.size.height * 0.08),
                    ),
                    //_daftar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageWidget() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    if (_selectedFile != null) {
      return Image.file(
        _selectedFile!,
        width: mediaQueryData.size.width * 0.3,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        "assets/logo/22.png",
        width: mediaQueryData.size.width * 0.3,
      );
    }
  }

  Widget _inputMesin() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);

    return Container(
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
      child:
          // DropdownSearch<String>(
          //     mode: Mode.MENU,
          //     showSelectedItems: true,
          //     showSearchBox: true,
          //     items: allMesin,
          //     hint: "Pilih Mesin",
          //     onChanged: (val) {
          //       if (kDebugMode) {
          //         print(val);
          //       }
          //     },
          //     selectedItem: selectedItem),
          DropdownButton(
        underline: const SizedBox(),
        hint: Row(
          children: <Widget>[
            SizedBox(
              width: mediaQueryData.size.width * 0.01,
            ),
            const Icon(
              Icons.build_circle_rounded,
              color: Colors.grey,
            ),
            Text(
              "    Pilih Mesin",
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
          ],
        ),
        isExpanded: true,
        items: allMesin.map(
          (item) {
            return DropdownMenuItem(
              child: Text(item['nama']),
              value: item['Id'].toString(),
            );
          },
        ).toList(),
        onChanged: (newVal) {
          setState(
            () {
              cLayanan = newVal as String;
            },
          );
        },
        value: cLayanan,
      ),
    );
  }

  Widget _inputSpesialis() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cSpesialis,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Spesialis',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.stars,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputMoto() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cMoto,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Moto',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.textsms,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputKarir() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        controller: cKarir,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Karir',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(
            Icons.recent_actors,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return SizedBox(
      width: mediaQueryData.size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton(
        onPressed: () async {
          if (cMesin.text.isEmpty || cMesin.text == '') {
            SnackBar snackBar = SnackBar(
              duration: const Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  const Text(
                    ' Nama belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  if (kDebugMode) {
                    print('ULANGI');
                  }
                },
              ),
            );
            // ignore: deprecated_member_use
            scaffoldKey.currentState!.showSnackBar(snackBar);
          } else if (cSpesialis.text.isEmpty || cSpesialis.text == '') {
            SnackBar snackBar = SnackBar(
              duration: const Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  const Text(
                    ' Spesialis belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  if (kDebugMode) {
                    print('ULANGI');
                  }
                },
              ),
            );
            // ignore: deprecated_member_use
            scaffoldKey.currentState!.showSnackBar(snackBar);
          } else if (cMoto.text.isEmpty || cMoto.text == '') {
            SnackBar snackBar = SnackBar(
              duration: const Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  const Text(
                    ' Moto belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  if (kDebugMode) {
                    print('ULANGI');
                  }
                },
              ),
            );
            // ignore: deprecated_member_use
            scaffoldKey.currentState!.showSnackBar(snackBar);
          } else if (cKarir.text.isEmpty || cKarir.text == '') {
            SnackBar snackBar = SnackBar(
              duration: const Duration(seconds: 5),
              elevation: 6.0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning,
                    size: 20,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: mediaQueryData.size.width * 0.01,
                  ),
                  const Text(
                    ' Karir belum diisi',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.orange,
              action: SnackBarAction(
                label: 'ULANGI',
                textColor: Colors.white,
                onPressed: () {
                  if (kDebugMode) {
                    print('ULANGI');
                  }
                },
              ),
            );
            // ignore: deprecated_member_use
            scaffoldKey.currentState!.showSnackBar(snackBar);
          } else {
            upload(_selectedFile!);
          }
        },
        child: const Text(
          'TAMBAH',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: titleText,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _cameraButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return SizedBox(
      width: mediaQueryData.size.height * 0.15,
      height: mediaQueryData.size.height * 0.05,
      child: ElevatedButton(
        onPressed: () {
          getImage(ImageSource.camera);
        },
        child: Row(
          children: [
            const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
            ),
            const Text(
              'Kamera',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.orange,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _galeryButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(this.context);
    return SizedBox(
      width: mediaQueryData.size.height * 0.15,
      height: mediaQueryData.size.height * 0.05,
      child: ElevatedButton(
        onPressed: () {
          getImage(ImageSource.gallery);
        },
        child: Row(
          children: [
            const Icon(
              Icons.photo,
              color: Colors.white,
            ),
            Padding(
              padding: EdgeInsets.only(left: mediaQueryData.size.height * 0.01),
            ),
            const Text(
              'Galeri',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

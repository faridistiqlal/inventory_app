import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_app/style/style.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http; //* package untuk akses http
import 'dart:convert'; //* package untuk convert API
import 'package:inventory_app/service/service.dart';
import '../class/header.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //NOTE Globalkey
  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

//NOTE Boolean

  // ignore: unused_field
  late bool _sudahlogin = false;
  // ignore: unused_field
  late bool _loading = false;
  bool _obscureText = true;

  void _toggle() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

//REVIEW Cek Login
  Future _cekLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("_sudahlogin") == true) {
      _sudahlogin = true;
      setState(
        () {
          _loading = true;
        },
      );
      if (pref.getString('Level') == '1') {
        Navigator.pushReplacementNamed(context, '/HalAdmin');
        //  Navigator.pushReplacementNamed(context, '/HalTabAdmin');
      } else if (pref.getString('Level') == '2') {
        Navigator.pushReplacementNamed(context, '/HalMekanik');
      } else if (pref.getString('Level') == '3') {
        Navigator.pushReplacementNamed(context, '/HalMesinMekanik');
      } else {
        if (kDebugMode) {
          print("cek hal_login");
        }
      }
    } else {
      _sudahlogin = false;
    }
  }

//NOTE Controller
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  void _login() async {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    setState(
      () {
        _loading = true;
      },
    );
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        String theUrl = getMyUrl.url + 'login/verify';
        var res = await http.post(
          Uri.parse(theUrl),
          headers: {"Accept": "application/json"},
          body: {
            "username": username.text,
            "password": password.text,
          },
        );
        var loginuser = json.decode(res.body);
        // print(loginuser);
        if (kDebugMode) {
          print(loginuser);
        }
        if (loginuser['Notif'] == 'Username tidak ditemukan.') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_sudahlogin", false);
          setState(
            () {
              _loading = false;
              if (kDebugMode) {
                print(loginuser);
                print("username salah");
              }
            },
          );
          SnackBar snackBar = SnackBar(
            duration: const Duration(seconds: 5),
            elevation: 6.0,
            // behavior: SnackBarBehavior.floating,
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
                  ' Username Salah',
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
          scaffoldKey.currentState?.showSnackBar(snackBar);
        } else if (loginuser['Notif'] == 'Password salah') {
          SharedPreferences pref = await SharedPreferences.getInstance();
          pref.setBool("_sudahlogin", false);
          setState(
            () {
              _loading = false;
              if (kDebugMode) {
                print(loginuser);
                print("password salah");
              }
            },
          );
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
                  ' Password salah',
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
          scaffoldKey.currentState?.showSnackBar(snackBar);
        } else {
          if (loginuser['Notif'] == 'Login berhasil') {
            if (loginuser['Data']['Level'] == "1") {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setBool("_sudahlogin", true);
              setState(() {
                pref.setString('IdUser', loginuser['Data']['IdUser']);
                pref.setString('NamaUser', loginuser['Data']['NamaUser']);
                pref.setString('Username', loginuser['Data']['Username']);
                pref.setString('Level', loginuser['Data']['Level']);
                pref.setString('LevelName', loginuser['Data']['LevelName']);
              });
              setState(
                () {
                  _loading = false;
                  if (kDebugMode) {
                    print("Login Admin 1");
                  }
                },
              );
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/HalAdmin',
                ModalRoute.withName('/HalAdmin'),
              );
            } else if (loginuser['Data']['Level'] == "2") {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setBool("_sudahlogin", true);
              setState(() {
                pref.setString('IdUser', loginuser['Data']['IdUser']);
                pref.setString('NamaUser', loginuser['Data']['NamaUser']);
                pref.setString('Username', loginuser['Data']['Username']);
                pref.setString('Level', loginuser['Data']['Level']);
                pref.setString('LevelName', loginuser['Data']['LevelName']);
              });
              setState(
                () {
                  _loading = false;
                  if (kDebugMode) {
                    print("Login Admin 2");
                  }
                },
              );
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/HalMekanik',
                ModalRoute.withName('/HalMekanik'),
              );
            } else if (loginuser['Data']['Level'] == "3") {
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.setBool("_sudahlogin", true);
              setState(() {
                pref.setString('IdUser', loginuser['Data']['IdUser']);
                pref.setString('NamaUser', loginuser['Data']['NamaUser']);
                pref.setString('Username', loginuser['Data']['Username']);
                pref.setString('Level', loginuser['Data']['Level']);
                pref.setString('LevelName', loginuser['Data']['LevelName']);
              });
              setState(
                () {
                  _loading = false;
                  if (kDebugMode) {
                    print("Login Admin 2");
                  }
                },
              );
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/HalMesinMekanik',
                ModalRoute.withName('/HalMesinMekanik'),
              );
            }
          }
        }
      },
    );
  }

//NOTE Inistate
  @override
  void initState() {
    super.initState();
    _cekLogin();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: Text(
      //     'Selamat datang',
      //     style: GoogleFonts.lato(
      //       textStyle: const TextStyle(),
      //     ),
      //   ),
      //   elevation: 0,
      //   actions: <Widget>[
      //     Consumer<ThemeNotifier>(
      //       builder: (context, notifier, child) => IconButton(
      //         icon: Icon(notifier.darkTheme ? Icons.sunny : Icons.dark_mode),
      //         onPressed: () {
      //           notifier.toggleTheme();
      //         },
      //       ),
      //     )
      //   ],
      // ),
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: _loading,
        color: Colors.amber,
        opacity: 1,
        progressIndicator: Padding(
          padding: EdgeInsets.only(top: mediaQueryData.size.height * 0.4),
          child: Column(
            children: [
              const SpinKitRotatingPlain(color: Colors.white),
              SizedBox(height: mediaQueryData.size.height * 0.05),
              const Text(
                'Mohon Tunggu..',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              )
            ],
          ),
        ),
        child: Stack(
          children: [
            HeaderLogin(mediaQueryData: mediaQueryData),
            loginForm(mediaQueryData)
          ],
        ),
      ),
    );
  }

  Widget loginForm(MediaQueryData mediaQueryData) {
    return SizedBox(
        child:
            // Consumer<ThemeNotifier>(
            //   builder: (context, notifier, child) => notifier.darkTheme
            //       ?
            Container(
                padding: const EdgeInsets.only(top: defaultPadding * 2),
                width: MediaQuery.of(context).size.width,
                // height: MediaQuery.of(context).size.width * 0.5,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.25),
                decoration: BoxDecoration(
                  color: bgCOlor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.02,
                      // bottom: mediaQueryData.size.height * 0.03,
                      // top: mediaQueryData.size.height * 0.01,
                    ),
                    child: ListView(children: <Widget>[
                      // _title(),
                      // const Padding(
                      //   padding: EdgeInsets.only(top: defaultPadding * 2),
                      // ),
                      _inputNIK(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 2),
                      ),
                      _inputPassword(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 3),
                      ),
                      _loginButton(),
                    ])))
        // : Container(
        //     padding: const EdgeInsets.only(top: defaultPadding * 2),
        //     width: MediaQuery.of(context).size.width,
        //     margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(15),
        //       color: Colors.white,
        //     ),
        //     child: Container(
        //         padding: EdgeInsets.only(
        //           left: mediaQueryData.size.height * 0.02,
        //           right: mediaQueryData.size.height * 0.02,
        //           // bottom: mediaQueryData.size.height * 0.03,
        //           // top: mediaQueryData.size.height * 0.01,
        //         ),
        //         child: ListView(children: <Widget>[
        //           _title(),
        //           const Padding(
        //             padding: EdgeInsets.only(top: defaultPadding * 2),
        //           ),
        //           _inputNIK(),
        //           const Padding(
        //             padding: EdgeInsets.only(top: defaultPadding * 2),
        //           ),
        //           _inputPassword(),
        //           const Padding(
        //             padding: EdgeInsets.only(top: defaultPadding * 2),
        //           ),
        //           _loginButton(),
        //         ]))),
        // ),
        );
  }

  // Widget _title() {
  //   return Text(
  //     "Login",
  //     style: Theme.of(context).textTheme.headline5?.copyWith(
  //         color: titleText, fontWeight: FontWeight.w700, fontSize: 30),
  //   );
  // }

  Widget _inputNIK() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          LengthLimitingTextInputFormatter(100),
        ],
        controller: username,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Username',
          hintStyle: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            Icons.person_outline,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputPassword() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[50],
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(100),
        ],
        controller: password,
        obscureText: _obscureText,
        style: const TextStyle(
          color: Colors.black,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(_obscureText
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined),
            color: Colors.grey,
            iconSize: 20.0,
            onPressed: _toggle,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Password',
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _loginButton() {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: mediaQueryData.size.height * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        onPressed: () async {
          if (username.text.isEmpty || username.text == '') {
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
                    'Username kosong',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
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
            scaffoldKey.currentState?.showSnackBar(snackBar);
          } else if (password.text.isEmpty || password.text == '') {
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
                    'Password kosong',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
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
            scaffoldKey.currentState?.showSnackBar(snackBar);
          } else {
            _login();
          }
        },
        child: const Text(
          'LOGIN',
          style: TextStyle(
            color: titleText,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

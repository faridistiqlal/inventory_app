import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inventory_app/style/style.dart';
import 'package:provider/provider.dart';

import '../class/header_login.dart';
import '../style/theme_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  void _toggle() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Selamat datang',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(),
          ),
        ),
        elevation: 0,
        actions: <Widget>[
          Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => IconButton(
              icon: Icon(notifier.darkTheme ? Icons.sunny : Icons.dark_mode),
              onPressed: () {
                notifier.toggleTheme();
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          HeaderLogin(mediaQueryData: mediaQueryData),
          loginForm(mediaQueryData)
        ],
      ),
    );
  }

  Widget loginForm(MediaQueryData mediaQueryData) {
    return SizedBox(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => notifier.darkTheme
            ? Container(
                padding: const EdgeInsets.only(top: defaultPadding * 2),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 44, 43, 43),
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
                      _title(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 2),
                      ),
                      _inputNIK(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 2),
                      ),
                      _inputPassword(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 2),
                      ),
                      _loginButton(),
                    ])))
            : Container(
                padding: const EdgeInsets.only(top: defaultPadding * 2),
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: mediaQueryData.size.height * 0.2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Container(
                    padding: EdgeInsets.only(
                      left: mediaQueryData.size.height * 0.02,
                      right: mediaQueryData.size.height * 0.02,
                      // bottom: mediaQueryData.size.height * 0.03,
                      // top: mediaQueryData.size.height * 0.01,
                    ),
                    child: ListView(children: <Widget>[
                      _title(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 2),
                      ),
                      _inputNIK(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 2),
                      ),
                      _inputPassword(),
                      const Padding(
                        padding: EdgeInsets.only(top: defaultPadding * 2),
                      ),
                      _loginButton(),
                    ]))),
      ),
    );
  }

  Widget _title() {
    return Text(
      "Login",
      style: Theme.of(context).textTheme.headline5?.copyWith(
          // color: ,
          fontWeight: FontWeight.w700,
          fontSize: 30),
    );
  }

  Widget _inputNIK() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.grey[50],
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        inputFormatters: [
          LengthLimitingTextInputFormatter(100),
        ],
        // controller: username,
        style: const TextStyle(
            // color: Colors.black,
            ),
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Username',
          hintStyle: TextStyle(
            fontSize: 14,
            // color: Colors.grey[400],
          ),
          prefixIcon: Icon(
            Icons.person_outline,
            // color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _inputPassword() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Colors.grey[50],
      ),
      child: TextFormField(
        inputFormatters: [
          LengthLimitingTextInputFormatter(100),
        ],
        // controller: password,
        obscureText: _obscureText,
        style: const TextStyle(
            // color: Colors.black,
            ),
        decoration: InputDecoration(
          prefixIcon: const Icon(
            Icons.lock,
            // color: Colors.grey,
          ),
          suffixIcon: IconButton(
            icon: Icon(_obscureText
                ? Icons.remove_red_eye
                : Icons.remove_red_eye_outlined),
            // color: Colors.grey,
            iconSize: 20.0,
            onPressed: _toggle,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: 'Passowrd',
          hintStyle: const TextStyle(
            fontSize: 14,
            // color: Colors.grey[400],
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // <-- Radius
          ),
        ),
        onPressed: () async {
          // if (cTahun == null || cTahun == '') {
          //   SnackBar snackBar = SnackBar(
          //     duration: Duration(seconds: 5),
          //     elevation: 6.0,
          //     content: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Icon(
          //           Icons.warning,
          //           size: 20,
          //           color: Colors.white,
          //         ),
          //         SizedBox(
          //           width: mediaQueryData.size.width * 0.01,
          //         ),
          //         Text(
          //           ' Pilih tahun',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ],
          //     ),
          //     backgroundColor: Colors.orange,
          //     action: SnackBarAction(
          //       label: 'ULANGI',
          //       textColor: Colors.white,
          //       onPressed: () {
          //         print('ULANGI');
          //       },
          //     ),
          //   );
          //   scaffoldKey.currentState.showSnackBar(snackBar);
          // } else {
          //   _login();
          // }
        },
        child: const Text(
          'LOGIN',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

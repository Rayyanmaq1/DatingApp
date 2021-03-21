import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/AuthPage/LoginPage.dart';
import 'package:livu/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:livu/View/CustomNavigation/CustomNavigation.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool login = false;
  void initState() {
    _getData();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              login == true ? CustomNavigation() : LoginPage(),
        ),
      ),
    );
    super.initState();
  }

  _getData() async {
    login = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      print(login);
      login = prefs.getBool('Login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      body: Center(
        child: Text(
          'KIM LIVE',
          style: GoogleFonts.getFont('Bubblegum Sans',
              fontWeight: FontWeight.w700,
              fontSize: SizeConfig.textMultiplier * 8,
              color: Colors.white),
        ),
      ),
    );
  }
}

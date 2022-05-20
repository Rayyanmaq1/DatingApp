import 'dart:async';

import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/AuthPage/LoginPage.dart';
import 'package:livu/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:livu/View/CustomNavigation/CustomNavigation.dart';
import 'package:easy_localization/easy_localization.dart';

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
          builder: (BuildContext context) => login == true
              ? CustomNavigation(
                  showPopUps: false,
                )
              : LoginPage(),
        ),
      ),
    );
    super.initState();
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      login = prefs.getBool('Login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.purpleColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Logo.png',
              width: SizeConfig.widthMultiplier * 80,
              height: SizeConfig.widthMultiplier * 80,
            ),
          ],
        ),
      ),
    );
  }
}

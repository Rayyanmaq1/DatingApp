import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/AuthPage/PhoneAuth/GetPhoneNumber.dart';
import 'package:livu/theme.dart';
import 'package:livu/Services/FaceBookAuthentication.dart';
import 'package:livu/View/CustomNavigation/CustomNavigation.dart';
import 'package:livu/Services/GoogleAuth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:particles_flutter/particles_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: Stack(
                  children: [
                    CircularParticle(
                        key: UniqueKey(),
                        awayRadius: 8,
                        numberOfParticles: 35,
                        speedOfParticles: 0.5,
                        height: SizeConfig.heightMultiplier * 60,
                        width: MediaQuery.of(context).size.width,
                        onTapAnimation: true,
                        particleColor: Colors.grey,
                        awayAnimationDuration: Duration(milliseconds: 600),
                        maxParticleSize: 4,
                        isRandSize: false,
                        isRandomColor: false,
                        awayAnimationCurve: Curves.easeInOutBack,
                        enableHover: false,
                        hoverColor: Colors.white,
                        hoverRadius: 90,
                        connectDots: true),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/Logo.png',
                            height: SizeConfig.heightMultiplier * 20,
                          ),
                          Text(
                            'app_name',
                            style: GoogleFonts.getFont('Bubblegum Sans',
                                fontWeight: FontWeight.w700,
                                fontSize: SizeConfig.textMultiplier * 8,
                                color: Colors.white),
                          ).tr(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'By using LuiV, you agree to the ',
                        style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: SizeConfig.textMultiplier * 1.5),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Term of Service',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('tapped');
                              },
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.textMultiplier * 1.5,
                                decoration: TextDecoration.underline),
                            children: [],
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: '\nPrivacy Policy',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('23');
                              },
                            style: TextStyle(
                                fontSize: SizeConfig.textMultiplier * 1.5,
                                color: Colors.white,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PhysicalModel(
                    elevation: 4,
                    color: Color.fromRGBO(66, 103, 178, 1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: RawMaterialButton(
                      splashColor: Colors.blue[700],
                      onPressed: () {
                        FaceBookAuthentcation().signInWithFacebook();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: FaIcon(
                                FontAwesomeIcons.facebookF,
                                color: Colors.white,
                                size: SizeConfig.heightMultiplier * 2.5,
                              ),
                            ),
                            Container(
                              child: Text(
                                'facebook_button',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ).tr(),
                            ),
                            Container(),
                          ],
                        ),
                        height: SizeConfig.heightMultiplier * 6.5,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                    ),
                  ),
                  PhysicalModel(
                    elevation: 4,
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      onPressed: () {
                        GmailAuthentication().registerWithGmail();
                      },
                      splashColor: Colors.black,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: FaIcon(
                                FontAwesomeIcons.google,
                                color: Colors.white,
                                size: SizeConfig.heightMultiplier * 3,
                              ),
                            ),
                            Container(
                              child: Text(
                                'google_button',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ).tr(),
                            ),
                            Container(),
                          ],
                        ),
                        height: SizeConfig.heightMultiplier * 6.5,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                    ),
                  ),
                  PhysicalModel(
                    elevation: 4,
                    color: purpleColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    child: RawMaterialButton(
                      onPressed: () {
                        Get.to(() => GetPhoneNumber());
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      splashColor: Colors.deepPurple[600],
                      child: Container(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: FaIcon(
                                FontAwesomeIcons.mobileAlt,
                                color: Colors.white,
                                size: SizeConfig.heightMultiplier * 3,
                              ),
                              //  width: 40,
                            ),
                            Container(
                              //width: SizeConfig.widthMultiplier * 60,
                              child: Text(
                                'phone_Button',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ).tr(),
                            ),
                            Container(),
                          ],
                        ),
                        height: SizeConfig.heightMultiplier * 6.5,
                        width: MediaQuery.of(context).size.width * 0.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

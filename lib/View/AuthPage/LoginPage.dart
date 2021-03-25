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

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: purpleColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Icon(Icons.question_answer),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/Logo.png',
                      height: SizeConfig.heightMultiplier * 20,
                    ),
                    Text(
                      'KIM LIVE',
                      style: GoogleFonts.getFont('Bubblegum Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: SizeConfig.textMultiplier * 8,
                          color: Colors.white),
                    ),
                    Text(
                      '542,342,322',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.textMultiplier * 3,
                      ),
                    ),
                    Text(
                      'Matches',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontWeight: FontWeight.w200,
                        fontSize: SizeConfig.textMultiplier * 2,
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
                                'Connect with Facebook',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
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
                                'Connect with Google',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
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
                                'Connect with Phone Number',
                                style: TextStyle(
                                    fontSize: SizeConfig.textMultiplier * 1.9,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
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

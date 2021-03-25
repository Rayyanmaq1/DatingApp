import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:livu/SizedConfig.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:livu/View/CustomNavigation/CustomNavigation.dart';
import 'package:livu/View/UserData/Userdata.dart';
import 'package:livu/Services/PhoneAuth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:easy_localization/easy_localization.dart';

class OptScreen extends StatelessWidget {
  OptScreen({this.phoneNumber, this.code, this.verId});
  String phoneNumber;
  String code;
  String verId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  height: SizeConfig.heightMultiplier * 2,
                ),
                Text(
                  'verfication_code',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig.textMultiplier * 3.5),
                ).tr(),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'sub_title_verification_code'.tr() + " " + code + phoneNumber,
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.normal,
                      fontSize: SizeConfig.textMultiplier * 2),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: PinCodeTextField(
                    backgroundColor: Colors.black,
                    onCompleted: (value) {
                      print(value);
                      AuthService().signInWithOTP(value);
                    },
                    keyboardType: TextInputType.number,
                    enableActiveFill: true,
                    textStyle: TextStyle(color: Colors.white),
                    pinTheme: PinTheme(
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.grey[700],
                      inactiveFillColor: Colors.black,
                      selectedFillColor: Colors.black,
                      shape: PinCodeFieldShape.box,
                      fieldHeight: 50,
                      fieldWidth: 50,
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey[800],
                      activeFillColor: Colors.black,
                    ),
                    animationType: AnimationType.fade,
                    appContext: context,
                    onChanged: (value) {},
                    length: 6,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                // Text(
                //   'I didnt get the Code',
                //   style: TextStyle(
                //       color: Colors.grey,
                //       fontSize: SizeConfig.textMultiplier * 3),
                // ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  padding: EdgeInsets.all(8),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'By counting , you are including that you accept our ',
                      style: TextStyle(color: Colors.grey[600]),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Term of Service',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('tapped');
                            },
                          style: TextStyle(
                              color: Colors.grey[200],
                              decoration: TextDecoration.underline),
                          children: [],
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              print('23');
                            },
                          style: TextStyle(
                              color: Colors.grey[200],
                              decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

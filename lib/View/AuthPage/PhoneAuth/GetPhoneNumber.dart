import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'OTPscreen.dart';
import 'package:get/route_manager.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/Services/PhoneAuth.dart';
import 'package:livu/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class GetPhoneNumber extends StatelessWidget {
  @override
  String phoneNumber = '';
  String code = '+92';
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'login_with',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 3.2,
                          fontWeight: FontWeight.bold),
                    ).tr(),
                  ),
                  Theme(
                    data: ThemeData(primaryColor: Colors.grey[800]),
                    child: TextField(
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        phoneNumber = value;
                      },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'enter_number'.tr(),
                        hintStyle: TextStyle(color: Colors.white),
                        prefixIcon: CountryCodePicker(
                          onChanged: (value) {
                            code = value.toString();
                          },
                          padding: EdgeInsets.all(20),
                          initialSelection: '+92',
                          favorite: ['+92', 'PK'],
                          textStyle: TextStyle(color: Colors.white),
                          showFlag: true,
                        ),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey[700], width: 00),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            PhysicalModel(
              elevation: 4,
              color: purpleColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              child: RawMaterialButton(
                onPressed: () {
                  AuthService().verifyPhone(code + phoneNumber);
                  Get.to(() => OptScreen(phoneNumber: phoneNumber, code: code));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                splashColor: Colors.deepPurple[600],
                child: Container(
                  child: Center(
                    child: Container(
                      child: Text(
                        'next_button',
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 1.9,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      ).tr(),
                    ),
                  ),
                  height: SizeConfig.heightMultiplier * 5.5,
                  width: MediaQuery.of(context).size.width * 0.9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

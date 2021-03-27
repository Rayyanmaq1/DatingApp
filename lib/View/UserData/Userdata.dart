import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/Services/UserDataServices.dart';
import 'package:livu/View/CustomNavigation/CustomNavigation.dart';
import 'package:livu/theme.dart';
import 'package:easy_localization/easy_localization.dart';

class UserData extends StatefulWidget {
  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String dateTime = 'select_birth'.tr();
  int _groupValue = 0;

  TextEditingController _nameController = TextEditingController();

  TextEditingController _birthdayController = TextEditingController();
  TextEditingController _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("dateTime".tr());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: purpleColor,
        elevation: 0,
        title: Text('sign_up_title').tr(),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.grey[800]),
                child: TextField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.sentences,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'nick_name'.tr(),
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[700], width: 00),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
              ),
              Theme(
                data: ThemeData(primaryColor: Colors.grey[800]),
                child: TextField(
                  controller: _birthdayController,
                  onTap: () async {
                    await showDatePicker(
                            context: context,
                            initialDate: new DateTime(2001),
                            firstDate: new DateTime(1900),
                            lastDate: new DateTime(2100))
                        .then((value) {
                      setState(() {
                        dateTime = value.toString().substring(0, 10);
                      });
                    });
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: dateTime,
                    hintStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey[700], width: 00),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                  ),
                ),
              ),
              Divider(color: Colors.grey[800]),
              SizedBox(
                height: SizeConfig.heightMultiplier * 3,
              ),
              Text(
                'select_gender',
                style: TextStyle(color: Colors.white),
              ).tr(),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/Male_User.png'),
                            ),
                          ),
                        ),
                        RadioListTile(
                          value: 0,
                          groupValue: _groupValue,
                          title: Text(
                            "male_gender",
                            style: TextStyle(color: Colors.white),
                          ).tr(),
                          onChanged: (newValue) =>
                              setState(() => _groupValue = newValue),
                          activeColor: Colors.white,
                          selected: false,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Female_User.png',
                          width: 100,
                          height: 100,
                        ),
                        RadioListTile(
                          value: 1,
                          groupValue: _groupValue,
                          title: Text(
                            "female_gender",
                            style: TextStyle(color: Colors.white),
                          ).tr(),
                          onChanged: (newValue) =>
                              setState(() => _groupValue = newValue),
                          activeColor: Colors.white,
                          selected: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Gender_Select_title',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white),
                ).tr(),
              ),
              Center(
                child: GestureDetector(
                  onTap: () {},
                  child: PhysicalModel(
                    color: purpleColor,
                    elevation: 4,
                    borderRadius: BorderRadius.circular(6),
                    child: RawMaterialButton(
                      onPressed: () {
                        if (_genderController.text.isNotEmpty &&
                            _nameController.text.isNotEmpty) {
                          Get.snackbar('Invaild Input', 'Enter all fields');
                        } else {
                          _groupValue == 0
                              ? _genderController.text = 'Male'
                              : _genderController.text = 'Female';

                          UserDataServices().setUserData(dateTime,
                              _genderController.text, _nameController.text);
                          Get.offAll(() => CustomNavigation(
                                showPopUps: true,
                              ));
                        }
                      },
                      child: Container(
                        child: Center(
                            child: Text(
                          'submit_button',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.textMultiplier * 2.2),
                        ).tr()),
                        height: SizeConfig.heightMultiplier * 6,
                        width: SizeConfig.widthMultiplier * 35,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

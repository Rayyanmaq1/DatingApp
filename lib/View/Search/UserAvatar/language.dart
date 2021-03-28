import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/Services/UserDataServices.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  bool checkBoxValue = true;
  List<int> selectedValue = [];
  List<Language> languageData = Language().languageData();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.heightMultiplier * 3,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: MediaQuery.of(context).size.height - 150,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                  itemCount: languageData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 80,
                              child: Text(
                                languageData[index].languageName,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedValue.length >= 3) {
                                      if (languageData[index].checkValue ==
                                          false) {
                                        Get.snackbar('Attention'.tr(),
                                            'LanguageSubTitle'.tr(),
                                            snackPosition:
                                                SnackPosition.BOTTOM);
                                      } else {
                                        languageData[index].checkValue =
                                            !languageData[index].checkValue;
                                        selectedValue.remove(index);
                                      }
                                    } else {
                                      languageData[index].checkValue =
                                          !languageData[index].checkValue;
                                      selectedValue.contains(index)
                                          ? selectedValue.remove(index)
                                          : selectedValue.add(index);
                                    }
                                  });
                                },
                                child: CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.transparent,
                                  child: languageData[index].checkValue == true
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Color(0xff5351b2),
                                        )
                                      : Icon(
                                          CupertinoIcons.circle,
                                          color: Color(0xff5351b2),
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          GestureDetector(
            onTap: () {
              UserDataServices().setLanguages(selectedValue);
              Get.back();
            },
            child: Container(
              color: Color(0xff5351b2),
              width: MediaQuery.of(context).size.width * 0.6,
              height: SizeConfig.heightMultiplier * 6,
              child: Center(
                child: Text(
                  "Save ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Language {
  String languageName;
  bool checkValue;
  Language({this.languageName, this.checkValue});

  List<Language> languageData() {
    return [
      Language(checkValue: false, languageName: "English"),
      Language(checkValue: false, languageName: "अरबिया"),
      Language(checkValue: false, languageName: "العربية"),
      Language(checkValue: false, languageName: "Turk dili"),
      Language(checkValue: false, languageName: "Frāncai"),
      Language(checkValue: false, languageName: "അറേബ്യ"),
      Language(checkValue: false, languageName: "Punjabi"),
    ];
  }
}

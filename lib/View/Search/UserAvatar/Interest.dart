import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Services/UserDataServices.dart';
import 'package:easy_localization/easy_localization.dart';

class Interest extends StatefulWidget {
  @override
  _InterestState createState() => _InterestState();
}

class _InterestState extends State<Interest> {
  // bool checkBoxValue = true;
  final userdataCtr = Get.put(UserDataController());
  List<dynamic> selectedValue = [];
  List<Interested> interestData = Interested().interestData();
  Widget build(BuildContext context) {
    //  selectedValue = userdataCtr.userModel.value.interest;
    print(userdataCtr.userModel.value.interest);
    return Scaffold(
      backgroundColor: AppColors.greyColor,
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
                  itemCount: interestData.length,
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
                                interestData[index].interest,
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  print(interestData[index].checkValue);
                                  if (selectedValue.length >= 5) {
                                    if (interestData[index].checkValue ==
                                        false) {
                                      Get.snackbar('Attention'.tr(),
                                          'InterestSubTitle'.tr(),
                                          snackPosition: SnackPosition.BOTTOM);
                                    } else {
                                      interestData[index].checkValue =
                                          !interestData[index].checkValue;
                                      selectedValue.remove(index);
                                    }
                                  } else {
                                    interestData[index].checkValue =
                                        !interestData[index].checkValue;
                                    selectedValue.contains(index)
                                        ? selectedValue.remove(index)
                                        : selectedValue.add(index);
                                  }
                                });
                              },
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.transparent,
                                child: interestData[index].checkValue
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Color(0xff5351b2),
                                      )
                                    : Icon(
                                        CupertinoIcons.circle,
                                        color: Color(0xff5351b2),
                                      ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          GestureDetector(
            onTap: () {
              UserDataServices().setinterest(selectedValue);
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

class Interested {
  String interest;
  bool checkValue;
  Interested({this.interest, this.checkValue});

  List<Interested> interestData() {
    return [
      Interested(checkValue: false, interest: "Dancing"),
      Interested(checkValue: false, interest: "Reading"),
      Interested(checkValue: false, interest: "Writing"),
      Interested(checkValue: false, interest: "Cooking"),
      Interested(checkValue: false, interest: "Gaming"),
      Interested(checkValue: false, interest: "Enjoying"),
      Interested(checkValue: false, interest: "Travel"),
    ];
  }
}

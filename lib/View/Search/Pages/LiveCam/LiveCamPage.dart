import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:livu/SizedConfig.dart';
import 'ConnectLiveCam.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/Services/LiveCamSearching.dart';
import 'package:easy_localization/easy_localization.dart';

class LiveCamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (Get.find<UserDataController>().userModel.value.coins >= 20) {
            Get.to(() => ConnectLiveCam());
            // .then((value) {
            //   _buildCustomDialog(context);
            // });
          } else {
            Get.to(() => BuyCoins());
            Get.snackbar('buy_coins'.tr(), 'NoEnoughCoinSubTitle'.tr());
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                AppColors.redColor,
                AppColors.pinkColor,
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: SizeConfig.heightMultiplier * 7,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/userAvatar.png'),
                  ),
                  CircleAvatar(
                    radius: SizeConfig.heightMultiplier * 7,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/Female_User.png'),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Live_Cam_Title',
                style: TextStyle(
                    fontSize: SizeConfig.heightMultiplier * 2,
                    color: Colors.white),
              ).tr(),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Live_Cam_Description',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2,
                      color: Colors.white),
                ).tr(),
              )
            ],
          ),
        ),
      ),
    );
  }

  _buildCustomDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.greyColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: SizeConfig.heightMultiplier * 28,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Are you sure you want to cancel matching',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 2,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Get.off(() => ConnectLiveCam()).then((value) {
                                LiveCamService().deleteUserFromSearch();
                              });
                            },
                            color: AppColors.greyColor,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: AppColors.purpleColor,
                                  fontSize: SizeConfig.textMultiplier * 2),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              LiveCamService().deleteUserFromSearch();
                              Get.back();
                            },
                            color: AppColors.greyColor,
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                  color: AppColors.purpleColor,
                                  fontSize: SizeConfig.textMultiplier * 2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: -SizeConfig.heightMultiplier * 5,
                  child: Image.asset(
                    'assets/Logo.png',
                    width: SizeConfig.widthMultiplier * 30,
                    height: SizeConfig.widthMultiplier * 30,
                  )),
            ],
          ),
        );
      },
    );
  }
}

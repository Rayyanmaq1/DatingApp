import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' hide Trans;
import 'package:lottie/lottie.dart';
import 'SeeUserProfile.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Controller/HistoryController.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:livu/Model/HistoryModel.dart';
import 'package:livu/Services/HistoryService.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/Services/ReportService.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/Dial.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';

class TheyMissed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GetX<HistoryController>(builder: (controller) {
          return controller.theyMissedhistoryController.length != 0
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.9 / 1.25,
                      mainAxisSpacing: 8),
                  shrinkWrap: true,
                  itemCount: controller.theyMissedhistoryController.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => Get.to(() => SeeUserProfile(
                            uid: controller
                                .theyMissedhistoryController[index].uid,
                          )),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(controller
                                    .theyMissedhistoryController[index]
                                    .imageUrl),
                                fit: BoxFit.fill,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            child: Container(
                              width: SizeConfig.widthMultiplier * 8,
                              height: SizeConfig.heightMultiplier * 4,
                              child: Center(
                                child: Icon(Icons.favorite,
                                    size: 20,
                                    color: Colors.white.withOpacity(0.4)),
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            child: Container(
                              width: SizeConfig.widthMultiplier * 18,
                              height: SizeConfig.heightMultiplier * 4,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () => _buildSecurityDialog(
                                        context,
                                        controller.theyMissedhistoryController[
                                            index]),
                                    child: Icon(Icons.security,
                                        size: 20,
                                        color: Colors.white.withOpacity(0.4)),
                                  ),
                                  GestureDetector(
                                    onTap: () => _buildDeleteDialog(
                                        context,
                                        controller
                                            .theyMissedhistoryController[index]
                                            .uid),
                                    child: Icon(Icons.delete,
                                        size: 20,
                                        color: Colors.white.withOpacity(0.4)),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 80,
                            left: 10,
                            child: Text(
                              controller
                                  .theyMissedhistoryController[index].name,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.textMultiplier * 1.8),
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            left: 10,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  controller.theyMissedhistoryController[index]
                                      .location,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                              bottom: 20,
                              left: 10,
                              child: Row(
                                children: [
                                  Icon(Icons.thumb_up_outlined,
                                      size: 12, color: Colors.white),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    controller
                                        .theyMissedhistoryController[index]
                                        .likes
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    controller
                                        .theyMissedhistoryController[index]
                                        .date,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                ],
                              )),
                          Positioned(
                            bottom: 20,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                if (Get.find<UserDataController>()
                                        .userModel
                                        .value
                                        .coins >=
                                    20) {
                                  _call(
                                      false,
                                      controller
                                          .theyMissedhistoryController[index],
                                      context);
                                } else {
                                  Get.to(() => BuyCoins());
                                  Get.snackbar('buy_coins'.tr(),
                                      'NoEnoughCoinSubTitle'.tr());
                                }
                              },
                              child: Container(
                                width: SizeConfig.widthMultiplier * 9,
                                height: SizeConfig.widthMultiplier * 9,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: orangeColor),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.phone,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Container(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset('assets/lotiesAnimation/missed.json'),
                    Text(
                      'No Match history yet, out there and connect',
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: SizeConfig.widthMultiplier * 40,
                        height: SizeConfig.heightMultiplier * 6,
                        child: Center(
                          child: Text(
                            'Start a Match',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.textMultiplier * 2),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(24)),
                      ),
                    )
                  ],
                ));
        }),
      ),
    );
  }

  _buildSecurityDialog(context, HistoryModel theyMissed) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: greyColor,
          title: Text(
            'Report_User',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
          ).tr(),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.42,
            child: Column(
              children: [
                _buildCustomTile('Sexual_Context'.tr(), theyMissed),
                _buildCustomTile('Not_Matched'.tr(), theyMissed),
                _buildCustomTile('Scam'.tr(), theyMissed),
                _buildCustomTile('Abusive_Language'.tr(), theyMissed),
                _buildCustomTile('UnderAge'.tr(), theyMissed),
                _buildCustomTile('Illegel_Activities'.tr(), theyMissed),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildCustomTile(title, HistoryModel theyMissed) {
    return ListTile(
      onTap: () {
        ReportService().reportUser(title, theyMissed.uid, theyMissed.name);
        Get.back();
        Get.snackbar('Reported', 'User have Been Reported');
      },
      title: Text(
        title,
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  _call(bool videoCall, HistoryModel model, context) {
    UserCallModel from = UserCallModel(
        name: Get.find<UserDataController>().userModel.value.name,
        imageUrl: Get.find<UserDataController>().userModel.value.imageUrl,
        uid: Get.find<UserDataController>().userModel.value.id);
    UserCallModel to = UserCallModel(
        name: model.name, imageUrl: model.imageUrl, uid: model.uid);
    CallUtils.dial(from: from, to: to, context: context, videoCall: videoCall);
  }

  _buildDeleteDialog(context, uid) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: greyColor,
          content: Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Column(
              children: [
                Text('Delete Dialog',
                    style: TextStyle(
                      color: Colors.white,
                    )).tr()
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                HistoryService().deleteVideoCallHistory('TheyMissed', uid);
                Navigator.pop(context);
              },
              child: Text(
                'Delete_Action_Button',
                style: TextStyle(color: greenColor),
              ).tr(),
            )
          ],
        );
      },
    );
  }
}

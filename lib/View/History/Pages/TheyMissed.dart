import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'SeeUserProfile.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Controller/HistoryController.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:livu/Model/HistoryModel.dart';
import 'package:livu/Services/HistoryService.dart';
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
                                    onTap: () => _buildSecurityDialog(context),
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
                                  Get.snackbar('Buy Coins',
                                      'You Donnt Have Enough Coins');
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
                  children: [
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 10,
                    ),
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
                        width: SizeConfig.widthMultiplier * 30,
                        height: SizeConfig.heightMultiplier * 6,
                        child: Center(
                          child: Text(
                            'Start a Match',
                            style: TextStyle(color: Colors.white),
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

  _buildSecurityDialog(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: greyColor,
          title: Text(
            'Report User',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.42,
            child: Column(
              children: [
                _buildCustomTile('Sexual content'),
                _buildCustomTile('Genter Did not match profile'),
                _buildCustomTile('Scam'),
                _buildCustomTile('Abusive Language'),
                _buildCustomTile('Underage use'),
                _buildCustomTile('Illegel acivities'),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildCustomTile(title) {
    return ListTile(
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
            height: MediaQuery.of(context).size.height * 0.046,
            child: Column(
              children: [
                Text('Are you sure you want to delete this record?',
                    style: TextStyle(
                      color: Colors.white,
                    ))
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
                'Continue',
                style: TextStyle(color: greenColor),
              ),
            )
          ],
        );
      },
    );
  }
}
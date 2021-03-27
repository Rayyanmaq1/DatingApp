import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Controller/HistoryController.dart';
import 'package:livu/View/Chat/Message_Screen/ChatScreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'SeeUserProfile.dart';
import 'package:livu/Services/HistoryService.dart';

class Imissed extends StatefulWidget {
  @override
  _ImissedState createState() => _ImissedState();
}

class _ImissedState extends State<Imissed> {
//  List<UserModel> getData = getRawdata();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: GetX<HistoryController>(builder: (controller) {
          return controller.iMissedhistoryController.length != 0
              ? GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.9 / 1.25,
                      mainAxisSpacing: 8),
                  shrinkWrap: true,
                  itemCount: controller.iMissedhistoryController.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => SeeUserProfile(
                            uid: controller.iMissedhistoryController[index].uid,
                          ),
                        );
                      },
                      child: Stack(
                        children: [
                          GestureDetector(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(controller
                                      .iMissedhistoryController[index]
                                      .imageUrl),
                                  fit: BoxFit.fill,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(4),
                                ),
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
                                    onTap: () => _buildSecurityDialog(),
                                    child: Icon(Icons.security,
                                        size: 20,
                                        color: Colors.white.withOpacity(0.4)),
                                  ),
                                  GestureDetector(
                                    onTap: () => _buildDeleteDialog(controller
                                        .iMissedhistoryController[index].uid),
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
                              controller.iMissedhistoryController[index].name,
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
                                  controller
                                      .iMissedhistoryController[index].location,
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
                                        .iMissedhistoryController[index].likes
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    controller
                                        .iMissedhistoryController[index].date,
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
                                LastMessage model =
                                    LastMessage.fromHistoryModel(controller
                                        .iMissedhistoryController[index]);
                                Get.to(() => ChatScreen(
                                    lastMessage: model, friendRequest: false));
                              },
                              child: Container(
                                width: SizeConfig.widthMultiplier * 9,
                                height: SizeConfig.widthMultiplier * 9,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: purpleColor),
                                child: Center(
                                  child: FaIcon(
                                    FontAwesomeIcons.solidCommentDots,
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
                  ),
                );
        }),
      ),
    );
  }

  _buildSecurityDialog() {
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
                _buildCustomTile('Sexual_Context'.tr()),
                _buildCustomTile('Not_Matched'.tr()),
                _buildCustomTile('Scam'.tr()),
                _buildCustomTile('Abusive_Language'.tr()),
                _buildCustomTile('UnderAge'.tr()),
                _buildCustomTile('Illegel_Activities'.tr()),
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

  _buildDeleteDialog(uid) {
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
                HistoryService().deleteVideoCallHistory('IMissed', uid);
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

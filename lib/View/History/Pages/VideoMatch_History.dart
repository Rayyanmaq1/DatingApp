import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/View/Chat/Message_Screen/ChatScreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livu/Services/HistoryService.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Model/HistoryModel.dart';
import 'package:livu/Controller/HistoryController.dart';
import 'SeeUserProfile.dart';
import 'package:livu/Services/PrivateVideoCall.dart';

// ignore: must_be_immutable
class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _seletedIndex = 0;
  PageController pageController = PageController();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyColor,
      appBar: AppBar(
        backgroundColor: greyColor,
        title: Text(
          "History",
          style: TextStyle(
            color: Colors.white,
          ),
        ).tr(),
      ),
      body: GetX<HistoryController>(builder: (controller) {
        return Column(
          children: [
            Container(
              height: SizeConfig.heightMultiplier * 9,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.videoCallhistoryController.length,
                itemBuilder: (context, index) {
                  return _buildCircularContainer(
                      controller.videoCallhistoryController[index], index);
                },
              ),
            ),
            SizedBox(
              height: SizeConfig.heightMultiplier * 3,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.horizontal,
                itemCount: controller.videoCallhistoryController.length,
                onPageChanged: (value) {
                  setState(() {
                    _seletedIndex = value;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildUserContainer(
                      controller.videoCallhistoryController[index]);
                },
              ),
            )
          ],
        );
      }),
    );
  }

  Widget _buildCircularContainer(HistoryModel controller, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        // onTap: () {
        //   setState(() {
        //     _seletedIndex = index;
        //   });
        // },
        child: Container(
          height: SizeConfig.heightMultiplier * 7.5,
          width: SizeConfig.heightMultiplier * 7.5,
          decoration: BoxDecoration(
            // color: greyColor,
            border: Border.all(
              color: _seletedIndex == index ? Colors.blue : Colors.transparent,
              width: 2,
              style: BorderStyle.solid,
            ),
            shape: BoxShape.circle,
          ),
          child: Container(
            height: SizeConfig.heightMultiplier * 7,
            width: SizeConfig.heightMultiplier * 7,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                height: SizeConfig.heightMultiplier * 6.5,
                width: SizeConfig.heightMultiplier * 6.5,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      controller.imageUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserContainer(HistoryModel historyModel) {
    return GestureDetector(
      onTap: () {
        Get.to(
          () => SeeUserProfile(
            uid: historyModel.uid,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 1,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    spreadRadius: 6,
                    offset: Offset(3, 7),
                    color: Colors.black38.withOpacity(0.4),
                  ),
                ],
                image: DecorationImage(
                    image: NetworkImage(historyModel.imageUrl),
                    fit: BoxFit.fill),
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: GestureDetector(
                onTap: () => _buildDeleteDialog(historyModel.uid),
                child: Container(
                  width: SizeConfig.widthMultiplier * 12,
                  height: SizeConfig.heightMultiplier * 6,
                  child: Center(
                    child: Icon(Icons.delete,
                        size: SizeConfig.imageSizeMultiplier * 8,
                        color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              top: 12,
              child: GestureDetector(
                onTap: () => _buildSecurityDialog(),
                child: Container(
                  width: SizeConfig.widthMultiplier * 12,
                  height: SizeConfig.heightMultiplier * 6,
                  child: Center(
                    child: Icon(Icons.report,
                        size: SizeConfig.imageSizeMultiplier * 8,
                        color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 70,
              top: 12,
              child: GestureDetector(
                onTap: () {
                  Get.snackbar('Send'.tr(), 'FriendRequestSend'.tr(),
                      snackPosition: SnackPosition.BOTTOM);
                  PrivateCallService().sendAddFriendRequest(historyModel.uid);
                },
                child: Container(
                  width: SizeConfig.widthMultiplier * 12,
                  height: SizeConfig.heightMultiplier * 6,
                  child: Center(
                    child: Icon(Icons.person,
                        size: SizeConfig.imageSizeMultiplier * 8,
                        color: Colors.white),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 200,
              child: Container(
                width: SizeConfig.widthMultiplier * 12,
                height: SizeConfig.heightMultiplier * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: SizeConfig.imageSizeMultiplier * 4,
                        color: Colors.white),
                    Text(
                      historyModel.likes.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 1.5),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 160,
              child: Container(
                width: SizeConfig.widthMultiplier * 24,
                height: SizeConfig.heightMultiplier * 3,
                child: Text(
                  historyModel.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 3,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 120,
              child: Container(
                width: SizeConfig.widthMultiplier * 24,
                height: SizeConfig.heightMultiplier * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.location_on,
                        size: SizeConfig.imageSizeMultiplier * 4,
                        color: Colors.white),
                    Container(
                      width: SizeConfig.widthMultiplier * 15,
                      child: Text(
                        historyModel.location,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 1.5),
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Colors.blue.withOpacity(1),
                ),
              ),
            ),
            Positioned(
              left: 120,
              bottom: 120,
              child: Container(
                width: SizeConfig.widthMultiplier * 24,
                height: SizeConfig.heightMultiplier * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.date_range,
                        size: SizeConfig.imageSizeMultiplier * 4,
                        color: Colors.white),
                    Text(
                      historyModel.date,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 1.5),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Positioned(
              left: 12,
              bottom: 90,
              child: Container(
                width: SizeConfig.widthMultiplier * 24,
                height: SizeConfig.heightMultiplier * 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.video_call,
                        size: SizeConfig.imageSizeMultiplier * 4,
                        color: Colors.white),
                    Text(
                      'from Video',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 1.5),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            Positioned(
              right: 20,
              left: 20,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  LastMessage lastMessage =
                      LastMessage.fromHistoryModel(historyModel);
                  Get.to(() => ChatScreen(
                        lastMessage: lastMessage,
                        friendRequest: false,
                      ));
                },
                child: Container(
                  width: SizeConfig.widthMultiplier * 80,
                  height: SizeConfig.heightMultiplier * 6,
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.commentDots,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 4,
                      ),
                      Text(
                        'Send a message',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
            height: SizeConfig.heightMultiplier * 30,
            child: SingleChildScrollView(
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
            height: MediaQuery.of(context).size.height * 0.078,
            child: Column(
              children: [
                Text('Delete Dialog',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.textMultiplier * 2,
                    )).tr()
              ],
            ),
          ),
          actions: [
            FlatButton(
              onPressed: () {
                print(uid);
                HistoryService()
                    .deleteVideoCallHistory('VideoCallHistory', uid);
                Navigator.pop(context);
              },
              child: Text(
                'Delete_Action_Button',
                style: TextStyle(
                  color: greenColor,
                  fontSize: SizeConfig.textMultiplier * 2,
                ),
              ).tr(),
            )
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/route_manager.dart';
import 'package:livu/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/call.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Services/PrivateVideoCall.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:livu/Services/LiveCamSearching.dart';
import 'package:livu/Services/CoinsDeduction.dart';
import 'package:livu/settings.dart';

String message;

// ignore: must_be_immutable
class VideoCall extends StatefulWidget {
  String id;
  CameraController cameraController;
  final String channelName;
  Map<String, dynamic> matchedInfo;

  final String image;
  final time;

  /// Creates a call page with given channel name.
  VideoCall({
    Key key,
    this.channelName,
    this.time,
    this.image,
    this.cameraController,
    this.matchedInfo,
    this.id,
  }) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  @override
  UserModel userModel = Get.find<UserDataController>().userModel.value;

  bool runOnce = true;
  bool likeOnce = false;

  void initState() {
    super.initState();
    CoinsDeduction().setCoins(
        userModel.coins,
        Select_Gender == 'Both'
            ? 0
            : Select_Gender == 'Male'
                ? 9
                : 12);
    // print(userModel.coins.toString() + " Coins");
    LiveCamService().history('VideoCallHistory', widget.matchedInfo);
    // _getData();
    // print('here');
  }

  Widget build(BuildContext context) {
    // print('Document Id' + widget.id);
    // _getData();
    // print(matchedInfo.docs.first.id);
    return Scaffold(
        backgroundColor: greyColor,
        body: Stack(
          children: [
            CallPage(
              channelName: widget.matchedInfo['ChannelId'],
              documentId: widget.id,
              // documentId: widget.matchedInfo.,
            ),
            _buildUserInfoContainer(context),
            _buildReportContainer(context),
            _buildaddFriendContainer(context),
            _buildLikeContainer(context),
            _buildChatContainer(context),
            //_buildExitContainer(context),
            _buildGiftContainer(context),
          ],
        )
        // : Container(
        //     child: Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   ),
        );
  }

  _buildGiftContainer(context) {
    return Positioned(
      bottom: 80,
      right: 5,
      child: Container(
        child: Center(
          child: FaIcon(
            FontAwesomeIcons.gift,
            color: Colors.white,
            size: SizeConfig.heightMultiplier * 2.5,
          ),
        ),
        width: SizeConfig.heightMultiplier * 5,
        height: SizeConfig.heightMultiplier * 5,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  _buildExitContainer(context) {
    return Positioned(
      bottom: 20,
      right: 5,
      child: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          child: Icon(
            Icons.login_outlined,
            color: Colors.white,
            size: SizeConfig.heightMultiplier * 2.5,
          ),
          width: SizeConfig.heightMultiplier * 5,
          height: SizeConfig.heightMultiplier * 5,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  _buildChatContainer(context) {
    return Positioned(
      bottom: 20,
      left: 5,
      child: GestureDetector(
        onTap: () {
          _buildBottomModelForMessaging(context);
        },
        child: Container(
          child: Icon(
            Icons.chat_bubble_outline_outlined,
            color: Colors.white,
            size: SizeConfig.heightMultiplier * 2.5,
          ),
          width: SizeConfig.heightMultiplier * 5,
          height: SizeConfig.heightMultiplier * 5,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  _buildLikeContainer(context) {
    return Positioned(
      top: 250,
      right: 5,
      child: GestureDetector(
        onTap: likeOnce
            ? () {}
            : () {
                setState(() {
                  likeOnce = true;
                });
                PrivateCallService().giveLike(
                  widget.matchedInfo['SenderUid'] == userModel.id
                      ? widget.matchedInfo['ReciverUid']
                      : widget.matchedInfo['SenderUid'],
                  widget.matchedInfo['SenderUid'] == userModel.id
                      ? widget.matchedInfo['ReciverLikes']
                      : widget.matchedInfo['SenderLikes'],
                );
              },
        child: Container(
          child: Icon(
            Icons.thumb_up_outlined,
            color: likeOnce ? Colors.yellow : Colors.black,
            size: SizeConfig.heightMultiplier * 4,
          ),
          width: SizeConfig.heightMultiplier * 7,
          height: SizeConfig.heightMultiplier * 7,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  _buildaddFriendContainer(context) {
    return Positioned(
      top: 200,
      left: 5,
      child: GestureDetector(
        onTap: () {
          print('tapped');
          PrivateCallService().sendAddFriendRequest(
            widget.matchedInfo['SenderUid'] == userModel.id
                ? widget.matchedInfo['ReciverUid']
                : widget.matchedInfo['SenderUid'],
          );
        },
        child: Container(
          child: Icon(
            Icons.person_outline_outlined,
            color: Colors.white,
            size: SizeConfig.heightMultiplier * 4,
          ),
          width: SizeConfig.heightMultiplier * 6,
          height: SizeConfig.heightMultiplier * 6,
          decoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  _buildReportContainer(context) {
    return Positioned(
      top: 120,
      left: 5,
      child: GestureDetector(
        onTap: () {
          _buildSecurityDialog(context);
        },
        child: Container(
          child: Icon(
            Icons.report_outlined,
            color: Colors.black,
            size: SizeConfig.heightMultiplier * 4,
          ),
          width: SizeConfig.heightMultiplier * 7,
          height: SizeConfig.heightMultiplier * 7,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        ),
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

  _buildUserInfoContainer(context) {
    return Positioned(
      top: 40,
      left: 5,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 33,
              backgroundColor: Colors.grey[850],
              backgroundImage: NetworkImage(
                widget.matchedInfo['SenderUid'] == userModel.id
                    ? widget.matchedInfo['ReciverImageUrl']
                    : widget.matchedInfo['SenderImageUrl'],
              ),
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: SizeConfig.heightMultiplier * 2,
                    width: SizeConfig.widthMultiplier * 30,
                    child: Center(
                      child: Text(
                        widget.matchedInfo['SenderUid'] == userModel.id
                            ? widget.matchedInfo['ReciverName']
                            : widget.matchedInfo['SenderName'],
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.thumb_up,
                        size: SizeConfig.imageSizeMultiplier * 4,
                        color: Colors.white,
                      ),
                      Container(
                        width: SizeConfig.widthMultiplier * 4,
                        child: Text(
                          widget.matchedInfo['SenderUid'] == userModel.id
                              ? widget.matchedInfo['ReciverLikes'].toString()
                              : widget.matchedInfo['SenderLikes'].toString(),
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Icon(
                        Icons.location_on,
                        size: SizeConfig.imageSizeMultiplier * 4,
                        color: Colors.white,
                      ),
                      Container(
                        width: SizeConfig.widthMultiplier * 18,
                        child: Text(
                          widget.matchedInfo['SenderUid'] == userModel.id
                              ? widget.matchedInfo['ReciverLocation']
                              : widget.matchedInfo['SenderLocation'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: SizeConfig.textMultiplier * 2),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: SizeConfig.widthMultiplier * 8,
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.08,
        width: MediaQuery.of(context).size.width * 0.60,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }

  _buildBottomModelForMessaging(context) {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 40, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter message',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Container(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              message = value;
                            },
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: 'Message',
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();

                      PrivateCallService().sendMessage(
                        messageText: message,
                        imageUrl: null,
                        tosendImage:
                            widget.matchedInfo['SenderUid'] == userModel.id
                                ? widget.matchedInfo['ReciverImageUrl']
                                : widget.matchedInfo['SenderImageUrl'],
                        tosendName:
                            widget.matchedInfo['SenderUid'] == userModel.id
                                ? widget.matchedInfo['ReciverName']
                                : widget.matchedInfo['SenderName'],
                        tosendUid:
                            widget.matchedInfo['SenderUid'] == userModel.id
                                ? widget.matchedInfo['ReciverUid']
                                : widget.matchedInfo['SenderUid'],
                      );
                      message = '';
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Center(
                        child: Text(
                          'Sent',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

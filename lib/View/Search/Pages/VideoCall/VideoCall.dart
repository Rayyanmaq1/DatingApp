import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/route_manager.dart';
import 'package:livu/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Model/UserModel.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/call.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Services/PrivateVideoCall.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:livu/Services/LiveCamSearching.dart';
import 'package:livu/Services/CoinsDeduction.dart';
import 'package:livu/settings.dart';
import 'package:livu/Services/ReportService.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:livu/View/Chat/Message_Screen/GiftsList.dart';

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
  final pageController = PageController(viewportFraction: 0.8);
  List<Gifts> getGifts = getGiftsList();
  List<Gifts> getData = getlist();
  bool showGifts = false;

  void initState() {
    super.initState();
    CoinsDeduction().setCoins(
        userModel.coins,
        Seleted_Genter_value == 1
            ? 0
            : Seleted_Genter_value == 2
                ? 9
                : 12);
    LiveCamService().history('VideoCallHistory', widget.matchedInfo);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: greyColor,
        body: GestureDetector(
          onTap: () {
            setState(() {
              showGifts = !showGifts;
            });
          },
          child: Stack(
            children: [
              CallPage(
                channelName: widget.matchedInfo['ChannelID'],
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
              showGiftPicker(),
            ],
          ),
        )
        // : Container(
        //     child: Center(
        //       child: CircularProgressIndicator(),
        //     ),
        //   ),
        );
  }

  Widget showGiftPicker() {
    return Positioned(
      bottom: 0,
      child: AnimatedContainer(
        // color: Colors.black,
        duration: Duration(milliseconds: 500),
        height: showGifts ? SizeConfig.heightMultiplier * 42 : 0,
        width: MediaQuery.of(context).size.width,
        child: PageView(
          // controller: pageController,
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1 / 1.45,
              ),
              itemCount: getGifts.length,
              itemBuilder: (context, index) {
                // print(getData[index].imageUrl);
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      showGifts = false;
                    });

                    if (Get.find<UserDataController>().userModel.value.coins >=
                        getGifts[index].coins) {
                      CoinsDeduction().setCoins(
                          Get.find<UserDataController>().userModel.value.coins,
                          getGifts[index].coins);
                      PrivateCallService().sendMessage(
                        messageText: 'Gift'.tr(),
                        imageUrl: getGifts[index].imageUrl,
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
                    } else {
                      Get.snackbar(
                          'NoEnoughCoin'.tr(), 'NoEnoughCoinSubTitle'.tr());
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CachedNetworkImage(
                        imageUrl: getGifts[index].imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: SizeConfig.widthMultiplier * 18,
                          height: SizeConfig.heightMultiplier * 12,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/Coin.png',
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            getGifts[index].coins.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 1 / 1.5,
              ),
              itemCount: getData.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      showGifts = false;
                    });
                    if (Get.find<UserDataController>().userModel.value.coins >=
                        getData[index].coins) {
                      CoinsDeduction().setCoins(
                          Get.find<UserDataController>().userModel.value.coins,
                          getData[index].coins);
                      PrivateCallService().sendMessage(
                        messageText: 'Gift'.tr(),
                        imageUrl: getGifts[index].imageUrl,
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
                    } else {
                      Get.snackbar(
                          'NoEnoughCoin'.tr(), 'NoEnoughCoinSubTitle'.tr());
                    }
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CachedNetworkImage(
                        imageUrl: getData[index].imageUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          width: SizeConfig.widthMultiplier * 18,
                          height: SizeConfig.heightMultiplier * 12,
                          decoration: BoxDecoration(
                            image: DecorationImage(image: imageProvider),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/Coin.png',
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            getData[index].coins.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildGiftContainer(context) {
    return Positioned(
      bottom: 20,
      right: 5,
      child: GestureDetector(
        onTap: () {
          print(showGifts);
          setState(() {
            showGifts = !showGifts;
          });
        },
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
      right: 10,
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
      left: 10,
      child: GestureDetector(
        onTap: () {
          Get.snackbar('Send'.tr(), 'FriendRequestSend'.tr(),
              snackPosition: SnackPosition.BOTTOM);
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
          width: SizeConfig.heightMultiplier * 7,
          height: SizeConfig.heightMultiplier * 7,
          decoration: BoxDecoration(
            color: purpleColor,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  _buildReportContainer(context) {
    return Positioned(
      top: 120,
      left: 10,
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
            'Report_User',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
          ).tr(),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.46,
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
      onTap: () {
        ReportService().reportUser(
          title,
          widget.matchedInfo['SenderUid'] == userModel.id
              ? widget.matchedInfo['ReciverUid']
              : widget.matchedInfo['SenderUid'],
          widget.matchedInfo['SenderName'] == userModel.id
              ? widget.matchedInfo['ReciverName']
              : widget.matchedInfo['SenderName'],
        );
        Get.back();
        Get.snackbar('Reported', 'User have Been Reported');
      },
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
                      SizedBox(
                        width: SizeConfig.widthMultiplier * 1,
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
                        'Send a message'.tr(),
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
                              hintText: 'Message'.tr(),
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
                          'Send'.tr(),
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

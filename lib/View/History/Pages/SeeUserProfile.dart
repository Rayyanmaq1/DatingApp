import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/get.dart' hide Trans;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livu/theme.dart';
import 'package:livu/View/Chat/Message_Screen/ChatScreen.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/Dial.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class SeeUserProfile extends StatefulWidget {
  String uid;
  SeeUserProfile({this.uid});

  @override
  _SeeUserProfileState createState() => _SeeUserProfileState();
}

class _SeeUserProfileState extends State<SeeUserProfile> {
  PageController pageController = new PageController();
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(widget.uid)
        .get();
    setState(() {
      userModel = UserModel.fromDocumentSnapshot(userData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Color(0xff191919),
        body: userModel != null
            ? Column(
                children: [
                  Stack(
                    children: [
                      Container(
                          height: SizeConfig.heightMultiplier * 50,
                          child: userModel.imageList.length != 0
                              ? PageView.builder(
                                  controller: pageController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: userModel.imageList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            SizeConfig.heightMultiplier * 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              userModel.imageList[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : Container(
                                  child: Center(
                                    child: Text(
                                      'No Image to show'.tr(),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                    ],
                  ),
                  userModel.imageList.length != 0
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SmoothPageIndicator(
                            controller: pageController, // PageController
                            count: userModel.imageList.length,
                            effect: WormEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              dotColor: Colors.grey[200],
                              activeDotColor: Colors.grey[800],
                            ), // your preferred effect
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel.name,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.all_inclusive_sharp,
                                          color: Colors.blue,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            userModel.age.length != 0
                                                ? userModel.age
                                                : 'Not Given',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    userModel.location.length != 0
                                        ? userModel.location
                                        : 'Not seleted',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  userModel.likes.toString(),
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 10,
                  ),
                  Container(
                    height: SizeConfig.heightMultiplier * 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _customContainer(
                            Icon(
                              Icons.call,
                              size: SizeConfig.imageSizeMultiplier * 10,
                              color: orangeColor,
                            ), () {
                          if (Get.find<UserDataController>()
                                  .userModel
                                  .value
                                  .coins >=
                              40) {
                            _call(false);
                          } else {
                            Get.to(() => BuyCoins());
                            Get.snackbar(
                                'buy_coins'.tr(), 'NoEnoughCoinSubTitle'.tr());
                          }
                        }),
                        _customContainer(
                            FaIcon(
                              FontAwesomeIcons.solidCommentDots,
                              size: SizeConfig.imageSizeMultiplier * 10,
                              color: purpleColor,
                            ), () {
                          LastMessage model = LastMessage.userModel(userModel);
                          Get.to(() => ChatScreen(
                                lastMessage: model,
                                friendRequest: false,
                              ));
                        }),
                        _customContainer(
                            Icon(
                              Icons.videocam,
                              size: SizeConfig.imageSizeMultiplier * 10,
                              color: redColor,
                            ), () {
                          if (Get.find<UserDataController>()
                                  .userModel
                                  .value
                                  .coins >=
                              80) {
                            _call(true);
                          } else {
                            Get.to(() => BuyCoins());
                            Get.snackbar(
                                'buy_coins'.tr(), 'NoEnoughCoinSubTitle'.tr());
                          }
                        }),
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }

  _call(bool videoCall) {
    UserCallModel from = UserCallModel(
        name: Get.find<UserDataController>().userModel.value.name,
        imageUrl: Get.find<UserDataController>().userModel.value.imageUrl,
        uid: Get.find<UserDataController>().userModel.value.id);
    UserCallModel to = UserCallModel(
        name: userModel.name, imageUrl: userModel.imageUrl, uid: userModel.id);
    CallUtils.dial(from: from, to: to, context: context, videoCall: videoCall);
  }

  _customContainer(icon, Function onpressed) {
    return RawMaterialButton(
      onPressed: onpressed,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: Container(
        height: SizeConfig.heightMultiplier * 12,
        width: SizeConfig.widthMultiplier * 24,
        child: Center(
          child: icon,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              spreadRadius: 8,
              blurRadius: 12,
              offset: Offset(4, 6),
              color: Colors.black,
            ),
          ],
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/Chat/Widgets/CustomerServiceChatScreen.dart';
import 'package:livu/View/Search/UserAvatar/setting_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:share/share.dart';
import 'edit_profile.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Services/UserDataServices.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class ProfileScreen extends StatelessWidget {
  final userdataCtrl = Get.find<UserDataController>();
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.cancel,
              color: Colors.grey[300],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => Get.to(() => SettingScreen()),
                child: Icon(
                  Icons.settings,
                  color: Colors.grey[300],
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 55,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GetX<UserDataController>(
                          builder: (controller) {
                            return GestureDetector(
                              onTap: () => UserDataServices().setImage(),
                              child: CircleAvatar(
                                backgroundImage:
                                    controller.userModel.value.imageUrl != null
                                        ? NetworkImage(
                                            controller.userModel.value.imageUrl)
                                        : AssetImage('assets/userAvatar.png'),
                                radius: 60,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GetX<UserDataController>(
                          builder: (controller) {
                            return Text(
                              controller.userModel.value.name != null
                                  ? '${controller.userModel.value.name}'
                                  : '',
                              style: TextStyle(color: Colors.white),
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(EditProfile());
                        },
                        child: Icon(
                          Icons.edit,
                          color: Colors.amber,
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 8, left: 10, right: 10),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.mars,
                              color: Colors.grey[300],
                            ),
                            GetX<UserDataController>(builder: (controller) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  controller.userModel.value.age.toString(),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.3),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GetX<UserDataController>(
                          builder: (controller) {
                            return Text(
                              controller.userModel.value.name != null
                                  ? '${controller.userData.bio}'
                                  : '',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.textMultiplier * 1.5),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                child: Image(
                                  image: AssetImage("assets/Coin.png"),
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                Get.find<UserDataController>()
                                    .userModel
                                    .value
                                    .coins
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 8, left: 10),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.transparent,
                                child: Image(
                                  image: AssetImage("assets/thumbsUp.png"),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                Get.find<UserDataController>()
                                    .userModel
                                    .value
                                    .likes
                                    .toString(),
                                style: TextStyle(color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
              listBar(
                  title: "buy_coins".tr(),
                  image: "assets/Coin.png",
                  ontap: () => Get.to(() => BuyCoins())),
              // listBar(
              //     title: "Link_Account".tr(),
              //     image: "assets/conntectAccounts.png"),
              listBar(
                  title: "FAQ".tr(),
                  image: "assets/FAQs.png",
                  ontap: () {
                    Get.to(() => ChatScreen());
                  }),
              listBar(
                  title: "Share".tr(),
                  image: "assets/Share.png",
                  ontap: () {
                    Share.share('check out my website https://example.com');
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget listBar({String title, image, Function ontap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10),
      child: ListTile(
        onTap: ontap,
        leading: CircleAvatar(
          radius: SizeConfig.heightMultiplier * 2.5,
          backgroundColor: Colors.transparent,
          child: Image(
            image: AssetImage(image),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
              color: Colors.grey[300], fontSize: SizeConfig.textMultiplier * 2),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey[300],
          size: 15,
        ),
      ),
    );
  }
}

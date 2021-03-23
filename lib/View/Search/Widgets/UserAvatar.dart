import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/Search/UserAvatar/profile_screen.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';

class UserAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: SizeConfig.widthMultiplier * 6,
      top: SizeConfig.heightMultiplier * 8,
      child: GestureDetector(
        onTap: () {
          Get.to(() => ProfileScreen());
        },
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withOpacity(0.4),
            image: DecorationImage(
              image: NetworkImage(Get.find<UserDataController>()
                          .userModel
                          .value
                          .imageUrl !=
                      null
                  ? Get.find<UserDataController>().userModel.value.imageUrl
                  : 'https://firebasestorage.googleapis.com/v0/b/kimapp-d73b4.appspot.com/o/userAvatar.png?alt=media&token=5e874cf1-866c-41b4-924b-b75f690c24c8'),
              fit: BoxFit.contain,
            ),
          ),
          width: SizeConfig.heightMultiplier * 5,
          height: SizeConfig.heightMultiplier * 5,
        ),
      ),
    );
  }
}

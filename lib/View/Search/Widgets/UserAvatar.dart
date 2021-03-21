import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/Search/UserAvatar/profile_screen.dart';

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
            color: Colors.grey.withOpacity(0.2),
            image: DecorationImage(
              image: AssetImage('assets/userAvatar.png'),
              fit: BoxFit.fill,
            ),
          ),
          width: SizeConfig.heightMultiplier * 5,
          height: SizeConfig.heightMultiplier * 5,
        ),
      ),
    );
  }
}

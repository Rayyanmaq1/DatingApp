import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/Chat/Widgets/CustomerServiceChatScreen.dart';
import 'package:livu/theme.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';

class CustomerService extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Get.to(() => ChatScreen());
      },
      leading: Container(
        width: 65,
        height: 65,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppColors.redColor, AppColors.orangeColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/CustomerService.png'),
          ),
        ),
      ),
      title: Text(
        'Customer Service',
        style: TextStyle(
            color: AppColors.redColor,
            fontSize: SizeConfig.textMultiplier * 2.3),
      ),
    );
  }
}

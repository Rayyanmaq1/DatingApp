import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:livu/SizedConfig.dart';
import 'ConnectLiveCam.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';

class LiveCamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          if (Get.find<UserDataController>().userModel.value.coins >= 20) {
            Get.to(() => ConnectLiveCam());
          } else {
            Get.to(() => BuyCoins());
            Get.snackbar(
                'Buy Coins', 'You Dont have enough coin for video call');
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          width: MediaQuery.of(context).size.width * 1,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                redColor,
                pinkColor,
              ])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: SizeConfig.heightMultiplier * 7,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/userAvatar.png'),
                  ),
                  CircleAvatar(
                    radius: SizeConfig.heightMultiplier * 7,
                    backgroundColor: Colors.transparent,
                    backgroundImage: AssetImage('assets/Female_User.png'),
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Find connections with first impressions',
                style: TextStyle(
                    fontSize: SizeConfig.heightMultiplier * 2,
                    color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'You will have 10 second to decide if its a match if about the person speaks your interest , tap the heart to connect ',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                      fontSize: SizeConfig.heightMultiplier * 2,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

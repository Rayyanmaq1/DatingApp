import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'ConnectVideoCall.dart';
import 'package:livu/theme.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';

class VideocallPage extends StatelessWidget {
  int seleted;
  CameraController cameraController;
  VideocallPage({this.cameraController, this.seleted});
  // final userData = Get.find<UserDataController>().userModel.value;
  @override
  Widget build(BuildContext context) {
    final deviceRatio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    var scale = MediaQuery.of(context).size.aspectRatio *
        cameraController.value.aspectRatio *
        1.5;

    print(seleted);
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (Get.find<UserDataController>().userModel.value.coins >= 20) {
            Get.to(() => VideoCallScreen(
                  seletedIndex: seleted,
                  cameraController: cameraController,
                ));
          } else {
            Get.to(() => BuyCoins());
            Get.snackbar(
                'Buy Coins', 'You Dont have enough coin for video call');
          }
        },
        child: Transform.scale(
          scale: scale,
          child: Center(
            child: CameraPreview(cameraController),
          ),
        ),
      ),
    );
  }
}

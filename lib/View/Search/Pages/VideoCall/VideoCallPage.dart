import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'ConnectVideoCall.dart';
import 'package:livu/theme.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/Services/VideoCallSearching.dart';

class VideocallPage extends StatelessWidget {
  int seleted;
  CameraController cameraController;
  VideocallPage({this.cameraController, this.seleted});
  // final userData = Get.find<UserDataController>().userModel.value;

  @override
  Widget build(BuildContext context) {
    var scale = MediaQuery.of(context).size.aspectRatio *
        cameraController.value.aspectRatio *
        1.5;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (Get.find<UserDataController>().userModel.value.coins >= 20) {
            Get.to(() => VideoCallScreen(
                  seletedIndex: seleted,
                  cameraController: cameraController,
                ));
            //     .then((value) {
            //   _buildCustomDialog(context);
            // });
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

  _buildCustomDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: greyColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Stack(
            overflow: Overflow.visible,
            alignment: Alignment.topCenter,
            children: [
              Container(
                height: SizeConfig.heightMultiplier * 28,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Are you sure you want to cancel matching',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 2,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FlatButton(
                            onPressed: () {
                              Get.off(() => VideoCallScreen()).then((value) {
                                VideoCallService().deleteUserFromSearch();
                              });
                            },
                            color: greyColor,
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  color: purpleColor,
                                  fontSize: SizeConfig.textMultiplier * 2),
                            ),
                          ),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              VideoCallService().deleteUserFromSearch();
                              Get.back();
                            },
                            color: greyColor,
                            child: Text(
                              'Accept',
                              style: TextStyle(
                                  color: purpleColor,
                                  fontSize: SizeConfig.textMultiplier * 2),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                  top: -SizeConfig.heightMultiplier * 5,
                  child: Image.asset(
                    'assets/Logo.png',
                    width: SizeConfig.widthMultiplier * 30,
                    height: SizeConfig.widthMultiplier * 30,
                  )),
            ],
          ),
        );
      },
    );
  }
}

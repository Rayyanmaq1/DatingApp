import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
// import 'package:video_player/video_player.dart';
import 'Widgets/AppBar.dart';
import 'package:livu/Model/VideoModel.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/VideoController.dart';
import 'package:livu/View/Search/UserAvatar/Interest.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/Model/VideoCallModel.dart';

import 'package:livu/View/Chat/Message_Screen/VideoCall/Dial.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  bool showGrid = true;
  int currentIndex;
  bool firstTime = true;
  final List<VideoModel> videoList = Get.find<AllVideoController>().videoLinks;

  Widget build(BuildContext context) {
    //  List<UserModel> getData = getRawdata();
    //print(getData.length);
    return PickupLayout(
      scaffold: Scaffold(
          backgroundColor: greyColor,
          body: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              return VideoPlayerItem(
                videoUrl: videoList[index].videoLink,
                name: videoList[index].userName,
                location: videoList[index].location,
                uid: videoList[index].uid,
                interest: videoList[index].interest,
                size: MediaQuery.of(context).size,
              );
            },
          )),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  String location;
  List<dynamic> interest;
  String uid;

  VideoPlayerItem(
      {Key key,
      @required this.size,
      this.name,
      this.interest,
      this.location,
      this.uid,
      this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VlcPlayerController _videoPlayerController;
  bool isShowPlaying = false;
  List<Interested> interestData = Interested().interestData();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.videoUrl);
    _videoPlayerController = VlcPlayerController.network(widget.videoUrl)
      ..initialize().then((value) {
        _videoPlayerController.play();
        setState(() {
          isShowPlaying = false;
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _videoPlayerController.dispose();
  }

  // Widget isPlaying() {
  //   return _videoPlayerController.value.isPlaying && !isShowPlaying
  //       ? Container()
  //       : Icon(
  //           Icons.play_arrow,
  //           size: 80,
  //           color: Colors.white.withOpacity(0.5),
  //         );
  // }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 0,
      child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: Colors.black),
                child: VlcPlayer(
                  controller: _videoPlayerController,
                  aspectRatio: 0.1 / 0.1,
                  placeholder: Center(child: CircularProgressIndicator()),
                ),
              ),
              Positioned(
                bottom: 280,
                left: 40,
                child: Text(
                  widget.name,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
              Positioned(
                bottom: 250,
                left: 40,
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.white),
                    Text(
                      widget.location,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 180,
                child: Container(
                  // width: MediaQuery.of(context).size.width,
                  height: SizeConfig.heightMultiplier * 5,
                  child: widget.interest.length != 0
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: widget.interest.length,
                          itemBuilder: (context, index) {
                            return _buildhobbyContaier(
                              interestData[widget.interest[index]].interest,
                            );
                          },
                        )
                      : Container(),
                ),
              ),
              Positioned(
                bottom: 110,
                left: 40,
                child: PhysicalModel(
                  color: purpleColor,
                  borderRadius: BorderRadius.circular(24),
                  elevation: 5,
                  child: RawMaterialButton(
                    onPressed: () {
                      if (Get.find<UserDataController>()
                              .userModel
                              .value
                              .coins >=
                          80) {
                        _call(true);
                      } else {
                        Get.to(() => BuyCoins());
                        Get.snackbar('Buy Coins',
                            'You Dont have enough coin for video call');
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: SizeConfig.heightMultiplier * 6,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Video Call Now',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/Coin.png',
                                  width: 18,
                                  height: 18,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  '80 Coins/ min',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  _call(bool videoCall) {
    UserCallModel from = UserCallModel(
        name: Get.find<UserDataController>().userModel.value.name,
        imageUrl: Get.find<UserDataController>().userModel.value.imageUrl,
        uid: Get.find<UserDataController>().userModel.value.id);
    UserCallModel to = UserCallModel(
        name: widget.name,
        // imageUrl: widget.i,
        uid: widget.uid);
    CallUtils.dial(from: from, to: to, context: context, videoCall: videoCall);
  }

// ignore: unused_element
  _buildhobbyContaier(hobby) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: SizeConfig.widthMultiplier * 16,
        height: SizeConfig.heightMultiplier * 3,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Center(
            child: Text(
          hobby,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: TextStyle(color: Colors.white, fontSize: 13),
        )),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:camera/camera.dart';
import 'package:get/route_manager.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/View/Search/UserAvatar/Interest.dart';
import 'package:livu/Services/LiveCamSearching.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:agora_rtc_engine/rtc_engine.dart' hide Color;
import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/settings.dart';
import 'package:livu/View/Search/Pages/LiveCam/ConnectLiveCam.dart';
import 'package:livu/Services/CoinsDeduction.dart';

// ignore: must_be_immutable
class LiveCam extends StatefulWidget {
  CameraController cameraController;
  String id;

  Map<String, dynamic> matchedData;

  LiveCam({
    this.cameraController,
    this.matchedData,
    this.id,
  });
  @override
  _LiveCamState createState() => _LiveCamState();
}

class _LiveCamState extends State<LiveCam> {
  UserModel userModel = Get.find<UserDataController>().userModel.value;
  List<Interested> interestData = Interested().interestData();
  bool runOnce = false;
  Color heartColors = Colors.white;
  bool seacondHeartColor = false;
  final _users = <int>[];
  // bool connected;
  ClientRole _role = ClientRole.Broadcaster;

  final _infoStrings = <String>[];
  bool muted = false;
  bool runGetBack = true;
  RtcEngine _engine;
  @override
  void initState() {
    super.initState();
    CoinsDeduction().setCoins(userModel.coins, 30);
    _getBack();
    _getData();
    initialize();
  }

  @override
  void dispose() {
    // clear users
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }

    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    await _engine.enableWebSdkInteroperability(true);
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = VideoDimensions(1920, 1080);
    await _engine.setVideoEncoderConfiguration(configuration);
    await _engine.joinChannel('', widget.matchedData['ChannelId'], null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(_role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(error: (code) {
      setState(() {
        final info = 'onError: $code';
        _infoStrings.add(info);
      });
    }, joinChannelSuccess: (channel, uid, elapsed) {
      setState(() {
        final info = 'onJoinChannel: $channel, uid: $uid';
        _infoStrings.add(info);
      });
    }, leaveChannel: (stats) {
      setState(() {
        _infoStrings.add('onLeaveChannel');
        _users.clear();
      });
    }, userJoined: (uid, elapsed) {
      setState(() {
        final info = 'userJoined: $uid';
        _infoStrings.add(info);
        _users.add(uid);
      });
    }, userOffline: (uid, elapsed) {
      setState(() {
        final info = 'userOffline: $uid';
        _infoStrings.add(info);
        _users.remove(uid);
      });
    }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
      setState(() {
        final info = 'firstRemoteVideo: $uid ${width}x $height';
        _infoStrings.add(info);
      });
    }));
  }

  /// Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    if (_role == ClientRole.Broadcaster) {
      list.add(RtcLocalView.SurfaceView());
    }
    _users.forEach((int uid) => list.add(RtcRemoteView.SurfaceView(uid: uid)));
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();

    return Container(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  Widget _positionedVideoRow(List<Widget> views) {
    views.map<Widget>(_videoView);

    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Positioned(
      height: 200,
      width: 120,
      right: 0.0,
      top: 0.0,
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  /// Video layout wrapper

  _getData() {
    FirebaseFirestore.instance
        .collection('ConnectedLiveCam')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.get('ReciverUid') == userModel.id ||
            element.get('SenderUid') == userModel.id) {
          element.get('ReciverUid') == userModel.id
              ? setState(() {
                  seacondHeartColor = element.get('ReciverLike');
                })
              : setState(() {
                  seacondHeartColor = element.get('SenderLike');
                });
        }
      });
    });
    if (seacondHeartColor && runOnce) {
      LiveCamService().deleteVideoCall(widget.id);
      Get.back();
      Get.snackbar('Contragulation'.tr(), 'NowYouAreFriends'.tr());
      LiveCamService().addFriend(widget.matchedData);
    }
  }

  _getBack() {
    Future.delayed(Duration(seconds: 20), () async {
      if (seacondHeartColor) {
        LiveCamService().history('IMissed', widget.matchedData);
      }
      if (runOnce) {
        LiveCamService().history('TheyMissed', widget.matchedData);
      }
      print("here");
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('ConnectedLiveCam')
          .doc(widget.id)
          .get();
      if (snapshot.exists) {
        _onCallEnd(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print('thiss');
    final views = _getRenderViews();

    Future.delayed(Duration(seconds: 1), () {
      _getData();
    });
    return Scaffold(
      backgroundColor: greyColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              dispose();
              Get.back();
              // Get.back();
            },
            child: Icon(Icons.arrow_back)),
        backgroundColor: Colors.transparent,
      ),
      body: views.length == 2
          ? Stack(
              children: [
                Positioned(
                  child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                widget.matchedData['SenderUid'] == userModel.id
                                    ? widget.matchedData['ReciverImageUrl']
                                    : widget.matchedData['SenderImageUrl']),
                            fit: BoxFit.fill)),
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: _expandedVideoRow([views[1]]),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                  ),
                                  width: SizeConfig.widthMultiplier * 30,
                                  height: SizeConfig.heightMultiplier * 25,
                                ),
                                Container(
                                  width: SizeConfig.widthMultiplier * 27,
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        right: 0,
                                        child: GestureDetector(
                                          onTap: runOnce
                                              ? () {}
                                              : () {
                                                  setState(() {
                                                    heartColors = Colors.red;
                                                    runOnce = true;
                                                  });
                                                  LiveCamService().giveHeart(
                                                      widget.id,
                                                      widget.matchedData[
                                                                  'SenderUid'] ==
                                                              userModel.id
                                                          ? 'ReciverLike'
                                                          : 'SenderLike');
                                                },
                                          child: Icon(
                                            Icons.favorite,
                                            size:
                                                SizeConfig.imageSizeMultiplier *
                                                    20,
                                            color: heartColors,
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: runOnce
                                            ? () {}
                                            : () {
                                                setState(() {
                                                  heartColors = Colors.red;
                                                  runOnce = true;
                                                });
                                                LiveCamService().giveHeart(
                                                    widget.id,
                                                    widget.matchedData[
                                                                'SenderUid'] ==
                                                            userModel.id
                                                        ? 'ReciverLike'
                                                        : 'SenderLike');
                                              },
                                        child: Icon(
                                          Icons.favorite,
                                          size: SizeConfig.imageSizeMultiplier *
                                              20,
                                          color: seacondHeartColor
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: _positionedVideoRow([views[0]]),
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    border: Border.all(
                                        color: Colors.white, width: 3),
                                  ),
                                  width: SizeConfig.widthMultiplier * 30,
                                  height: SizeConfig.heightMultiplier * 25,
                                ),
                              ],
                            ),
                          ),
                          Container(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: SizeConfig.heightMultiplier * 35,
                  left: 40,
                  child: Container(
                    child: Text(
                      widget.matchedData['SenderUid'] == userModel.id
                          ? widget.matchedData['ReciverName']
                          : widget.matchedData['SenderName'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 3),
                    ),
                  ),
                ),
                Positioned(
                  bottom: SizeConfig.heightMultiplier * 30,
                  left: 40,
                  child: Container(
                    child: Text(
                      widget.matchedData['SenderUid'] == userModel.id
                          ? widget.matchedData['ReciverLocation']
                          : widget.matchedData['SenderLocation'],
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 2),
                    ),
                  ),
                ),
                Positioned(
                  bottom: SizeConfig.heightMultiplier * 24,
                  left: 40,
                  child: Row(
                    children: [
                      Container(
                        height: SizeConfig.heightMultiplier * 4,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.matchedData['SenderUid'] !=
                                    userModel.id
                                ? widget.matchedData['SenderInterest'].length
                                : widget.matchedData['ReciverInterest'].length,
                            itemBuilder: (context, index) {
                              // print('Interest: ' +
                              //     widget.matchedData['SenderInterest'][index]);
                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 4, right: 4),
                                child: Container(
                                  height: SizeConfig.heightMultiplier * 2,
                                  width: SizeConfig.widthMultiplier * 22,
                                  decoration: BoxDecoration(
                                    color: purpleColor.withOpacity(0.6),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                  padding: EdgeInsets.all(6),
                                  child: Center(
                                    child: widget.matchedData['SenderUid'] !=
                                            userModel.id
                                        ? Text(
                                            interestData[widget.matchedData[
                                                    'SenderInterest'][index]]
                                                .interest,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    SizeConfig.textMultiplier *
                                                        1.3),
                                          )
                                        : Text(
                                            interestData[widget.matchedData[
                                                    'ReciverInterest'][index]]
                                                .interest,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  SizeConfig.textMultiplier *
                                                      1.3,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 80,
                  left: 0,
                  child: LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width,
                    animation: true,
                    lineHeight: 8.0,
                    animationDuration: 20000,
                    percent: 1,
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: purpleColor,
                  ),
                ),
                Positioned(
                  bottom: 40,
                  left: MediaQuery.of(context).size.width * 0.45,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        Get.back();
                        LiveCamService().deleteVideoCall(widget.id);
                        Get.to(() => ConnectLiveCam());
                        runGetBack = false;
                      });
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            )
          : Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: SizeConfig.heightMultiplier * 20,
                    ),
                    Text(
                      'Connecting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.textMultiplier * 2,
                      ),
                    ).tr(),
                  ],
                ),
              ),
            ),
    );
  }

  void _onCallEnd(BuildContext context) {
    LiveCamService().deleteVideoCall(widget.id);
    Get.back();
    // Future.delayed(Duration.zero, () {
    //   Get.off(() => ConnectLiveCam());
    // });
    _users.clear();
    // destroy sdk
    _engine.leaveChannel();
    _engine.destroy();
  }
}

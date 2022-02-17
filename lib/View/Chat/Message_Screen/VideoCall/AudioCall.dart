import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Services/PrivateVideoCall.dart';
import 'package:livu/theme.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Services/CoinsDeduction.dart';

class AudioCallPage extends StatefulWidget {
  final Call call;

  /// non-modifiable client role of the page

  /// Creates a call page with given channel name.
  const AudioCallPage({
    this.call,
    Key key,
  }) : super(key: key);

  @override
  _AudioCallPageState createState() => _AudioCallPageState();
}

class _AudioCallPageState extends State<AudioCallPage> {
  bool _joined = false;
  int _remoteUid = null;
  bool _switch = false;
  final userData = Get.find<UserDataController>().userModel.value;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  RtcEngine engine;

  @override
  void dispose() {
    // clear users
    // destroy
    print(engine);
    engine.leaveChannel();
    engine.destroy();
    super.dispose();
  }

  // Initialize the app
  Future<void> initPlatformState() async {
    // Get microphone permission
    // await PermissionHandler().requestPermissions(
    //   [PermissionGroup.microphone],
    // );

    // Create RTC client instance
    await RtcEngine.create(APP_ID).then((value) {
      setState(() {
        print(value);
        engine = value;
      });
    });

    // Define event handler
    engine.setEventHandler(RtcEngineEventHandler(
        joinChannelSuccess: (String channel, int uid, int elapsed) {
      print('joinChannelSuccess ${widget.call.channelId} ${uid}');
      setState(() {
        _joined = true;
      });
    }, userJoined: (int uid, int elapsed) {
      print('userJoined ${uid}');
      setState(() {
        _remoteUid = uid;
      });
    }, userOffline: (int uid, UserOfflineReason reason) {
      print('userOffline ${uid}');
      setState(() {
        _remoteUid = null;
      });
    }));
    // Join channel 123
    await engine.joinChannel('', widget.call.channelId, null, 0);
  }

  bool runOnce = true;

  _getData() {
    runOnce
        ? widget.call.callerId ==
                Get.find<UserDataController>().userModel.value.id
            ? CoinsDeduction().setCoins(
                Get.find<UserDataController>().userModel.value.coins, 40)
            : null
        : null;
    setState(() {
      runOnce = false;
    });
    Future.delayed(Duration(seconds: 3), () {
      PrivateCallService().checkCallifExist(widget.call.callerId).then((value) {
        if (value == false) {
          if (mounted) {
            Get.back();
            Get.snackbar('Disconnected'.tr(), 'Call has been Disconnected'.tr(),
                snackPosition: SnackPosition.BOTTOM);
          }
        }
      });
      setState(() {});
    });
  }

  // Create a simple chat UI
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
      backgroundColor: greyColor,
      appBar: AppBar(
        title: Text(
          'Voice Call'.tr(),
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: greyColor,
      ),
      body: Stack(
        children: [
          Center(
            child: Container(
              height: SizeConfig.heightMultiplier * 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(userData.id == widget.call.callerId
                          ? widget.call.receiverPic
                          : widget.call.callerPic),
                      fit: BoxFit.fill)),
            ),
          ),
          Center(
            child: _toolbar(),
          ),
        ],
      ),
    );
  }

  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: () => _onCallEnd(context),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
        ],
      ),
    );
  }

  void _onCallEnd(BuildContext context) {
    PrivateCallService().deleteCall(widget.call.callerId);

    Future.delayed(Duration.zero, () {
      Get.back();
    });
  }
}

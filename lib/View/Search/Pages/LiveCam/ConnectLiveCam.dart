import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/route_manager.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'dart:async';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Services/LiveCamSearching.dart';
import 'package:livu/Model/LiveCamModel.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class ConnectLiveCam extends StatefulWidget {
  CameraController cameraController;
  int seletedIndex;
  ConnectLiveCam({this.cameraController, this.seletedIndex});
  @override
  _ConnectLiveCamState createState() => _ConnectLiveCamState();
}

class _ConnectLiveCamState extends State<ConnectLiveCam> {
  @override
  void initState() {
    _searchLiveCam();
    super.initState();
  }

  bool searching = true;
  bool end = false;

  List quotes = [
    'Quote1'.tr(),
    'Quote2'.tr(),
    'Quote3'.tr(),
    'Quote4'.tr(),
    'Quote5'.tr(),
    'Quote6'.tr(),
    'Quote7'.tr(),
    'Quote8'.tr(),
  ];
  int seleteQuote = 5;
  int randomUser;
  bool callConnected = false;
  final userData = Get.put(UserDataController());
  RxList<LiveCamModel> getSearchs = List<LiveCamModel>().obs;
  LiveCamModel connectedCall;

  _searchUser() async {
    await LiveCamService().checkIfIGotMatched(widget.cameraController);
    getSearchs.bindStream(LiveCamService().getAllsearches());
    if (getSearchs.length != 0) {
      randomUser = Random().nextInt(getSearchs.length);
      if (getSearchs[randomUser].uid != userData.userModel.value.id) {
        setState(() {
          connectedCall = getSearchs[randomUser];
          callConnected = true;
        });
      }
    }
  }

  _connectCall() {
    LiveCamService()
        .connectCall(getSearchs[randomUser], widget.cameraController);
  }

  @override
  void dispose() {
    super.dispose();
    print('this');
    LiveCamService().deleteUserFromSearch();
  }

  @override
  Widget build(BuildContext context) {
    print(connectedCall);
    Future.delayed(Duration(seconds: 5), () {
      callConnected == false
          ? _searchUser()
          : Future.delayed(Duration(seconds: 1), () {
              _connectCall();
            });
      callConnected
          ? Future.delayed(Duration(seconds: 1), () {
              LiveCamService().checkIfIGotMatched(widget.cameraController);
            })
          : null;
      if (mounted) {
        setState(() {
          seleteQuote = Random().nextInt(8);
        });
      }
    });

    final random = Random();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
            onTap: () => Get.back(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        elevation: 0,
      ),
      body: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(seconds: 3),
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            color: Color.fromRGBO(random.nextInt(256), random.nextInt(256),
                random.nextInt(256), 1),
          ),
          Positioned(
            top: 120,
            left: MediaQuery.of(context).size.width * 0.35,
            child: Stack(
              children: [
                callConnected == false
                    ? Image.asset(
                        'assets/Female_User.png',
                        width: SizeConfig.widthMultiplier * 30,
                        height: SizeConfig.widthMultiplier * 30,
                      )
                    : connectedCall.imageUrl != ''
                        ? Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      connectedCall.imageUrl,
                                    ))),
                            width: SizeConfig.widthMultiplier * 30,
                            height: SizeConfig.widthMultiplier * 30,
                          )
                        : Image.asset(
                            'assets/Female_User.png',
                            width: SizeConfig.widthMultiplier * 30,
                            height: SizeConfig.widthMultiplier * 30,
                          ),
                Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                  width: SizeConfig.widthMultiplier * 30,
                  height: SizeConfig.widthMultiplier * 30,
                ),
              ],
            ),
          ),
          callConnected == true
              ? Stack(
                  children: [
                    Positioned(
                      top: 260,
                      left: MediaQuery.of(context).size.width * 0.42,
                      child: Text(
                        connectedCall.name,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      top: 280,
                      left: MediaQuery.of(context).size.width * 0.25,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: purpleColor.withOpacity(0.7),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Age',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: SizeConfig.widthMultiplier * 2,
                              ),
                              Text(
                                connectedCall.age.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 280,
                      left: MediaQuery.of(context).size.width * 0.5,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: SizeConfig.widthMultiplier * 2,
                            ),
                            Text(
                              connectedCall.location,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          callConnected == false
              ? Positioned(
                  top: MediaQuery.of(context).size.height * 0.5,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width * 1,
                    height: SizeConfig.heightMultiplier * 20,
                    child: Text(
                      quotes[seleteQuote],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 2),
                    ),
                  ),
                )
              : Container(),
          callConnected == true
              ? Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.15,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width * 1,
                    height: 80,
                    child: Text(
                      'Connecting',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 2),
                    ).tr(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void _searchLiveCam() {
    LiveCamService().searchLiveCam();
  }
}

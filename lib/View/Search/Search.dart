import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'Widgets/FilterWidget.dart';
import 'Widgets/UserAvatar.dart';
import 'Pages/LiveCam/LiveCamPage.dart';
import 'Pages/VideoCall/VideoCallPage.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/History/History.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/View/History/Pages/VideoMatch_History.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class Search extends StatefulWidget {
  bool showPopUps = false;

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  int _seleted = 0;
  PageController controller = PageController();
  List<Widget> pageList = List<Widget>();
  List<CameraDescription> camera;
  int selectedRadio = 1;
  bool getInfo = false;

  CameraController cameraController;
  void initState() {
    // print(friendRequest.friendRequestModel.value.otherUserUid);
    getCamera();
    _setData();

    pageList.add(Container(
      color: Colors.black,
    ));
    super.initState();
  }

  _setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('Login', true);
  }

  getCamera() async {
    camera = await availableCameras();
    cameraController = new CameraController(camera[1], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      pageList.removeLast();
      pageList.add(VideocallPage(
          cameraController: cameraController, seleted: selectedRadio));
      pageList.add(LiveCamPage());
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        //backgroundColor: Colors.red,
        body: Stack(
          children: [
            pageList[_seleted],
            UserAvatar(),
            _seleted == 0 ? FilterWidget(seleted: selectedRadio) : Container(),
            Positioned(
              left: SizeConfig.widthMultiplier * 7,
              top: SizeConfig.heightMultiplier * 17,
              child: GestureDetector(
                onTap: () => Get.to(() => BuyCoins()),
                child: Container(
                  // child: Icon(Icons.money),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/Coin.png'),
                    ),
                  ),
                  width: SizeConfig.heightMultiplier * 4,
                  height: SizeConfig.heightMultiplier * 4,
                ),
              ),
            ),
            _seleted == 0
                ? Positioned(
                    bottom: SizeConfig.heightMultiplier * 25,
                    left: MediaQuery.of(context).size.width * 0.3,
                    child: Container(
                      child: Text(
                        'Click_to_Start',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.heightMultiplier * 2),
                      ).tr(),
                    ),
                  )
                : Container(),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.85,
              top: SizeConfig.heightMultiplier * 9,
              child: Container(
                child: GestureDetector(
                  onTap: () {
                    _seleted == 1
                        ? Get.to(() => History())
                        : Get.to(() => HistoryScreen());
                  },
                  child: Icon(
                    Icons.history,
                    color: Colors.white,
                  ),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.5)),
                width: SizeConfig.heightMultiplier * 4,
                height: SizeConfig.heightMultiplier * 4,
              ),
            ),
            BottomContainer(),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  BottomContainer() {
    return Padding(
      padding: EdgeInsets.only(bottom: SizeConfig.heightMultiplier * 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    _seleted = 0;
                  });
                },
                child: Container(
                  width: 100,
                  height: 120,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          decoration: BoxDecoration(
                              color: purpleColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          width: 100,
                          height: _seleted != 0 ? 80 : 100,
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 5,
                        child: Text(
                          'Video_Match',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ).tr(),
                      ),
                      _seleted == 0
                          ? Positioned(
                              left: 40,
                              child: Container(
                                child: Icon(
                                  Icons.videocam,
                                  color: purpleColor,
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                height: 40,
                                width: 40,
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          // padding: const EdgeInsets.all(8.0),
                          width: 100.0,
                          child: new Stack(
                            children: <Widget>[
                              otherUserContainer(
                                  'https://images.pexels.com/photos/2904217/pexels-photo-2904217.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                              //CircleAvatar(radius: 12),
                              Positioned(
                                left: 15.0,
                                child: otherUserContainer(
                                    'https://images.pexels.com/photos/1987301/pexels-photo-1987301.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260'),
                              ),
                              new Positioned(
                                left: 30.0,
                                child: otherUserContainer(
                                    'https://images.pexels.com/photos/1816606/pexels-photo-1816606.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                              ),
                              new Positioned(
                                left: 45.0,
                                child: otherUserContainer(
                                    'https://images.pexels.com/photos/1816606/pexels-photo-1816606.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(
              //   width: SizeConfig.widthMultiplier * 10,
              // ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _seleted = 1;
                    //  print(_seleted);
                  });
                },
                child: Container(
                  width: 100,
                  height: 120,
                  //color: Colors.red,
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 0,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          decoration: BoxDecoration(
                              color: redColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          width: 100,
                          height: _seleted == 1 ? 100 : 80,
                        ),
                      ),
                      Positioned(
                        top: 50,
                        left: 5,
                        child: Text(
                          'LiveCam',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ).tr(),
                      ),
                      _seleted == 1
                          ? Positioned(
                              left: 40,
                              child: Container(
                                child: Icon(
                                  Icons.favorite,
                                  color: redColor,
                                ),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                height: 40,
                                width: 40,
                              ),
                            )
                          : Container(),
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          // padding: const EdgeInsets.all(8.0),
                          width: 100.0,
                          child: new Stack(
                            children: <Widget>[
                              otherUserContainer(
                                  'https://images.pexels.com/photos/1987301/pexels-photo-1987301.jpeg?auto=compress&cs=tinysrgb&dpr=3&h=750&w=1260'),
                              //CircleAvatar(radius: 12),
                              Positioned(
                                left: 15.0,
                                child: otherUserContainer(
                                    'https://images.pexels.com/photos/1816606/pexels-photo-1816606.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                              ),
                              new Positioned(
                                left: 30.0,
                                child: otherUserContainer(
                                    'https://images.pexels.com/photos/2904217/pexels-photo-2904217.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                              ),
                              new Positioned(
                                left: 45.0,
                                child: otherUserContainer(
                                    'https://images.pexels.com/photos/1816606/pexels-photo-1816606.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  otherUserContainer(image) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(width: 1, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

// ignore: must_be_immutable
class SeeUserProfile extends StatefulWidget {
  String uid;
  SeeUserProfile({this.uid});

  @override
  _SeeUserProfileState createState() => _SeeUserProfileState();
}

class _SeeUserProfileState extends State<SeeUserProfile> {
  PageController pageController = new PageController();
  UserModel userModel;
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  _getUserData() async {
    DocumentSnapshot userData = await FirebaseFirestore.instance
        .collection('UserData')
        .doc(widget.uid)
        .get();
    setState(() {
      userModel = UserModel.fromDocumentSnapshot(userData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Color(0xff191919),
        body: userModel != null
            ? Column(
                children: [
                  Stack(
                    children: [
                      Container(
                          height: SizeConfig.heightMultiplier * 50,
                          child: userModel.imageList.length != 0
                              ? PageView.builder(
                                  controller: pageController,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: userModel.imageList.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height:
                                            SizeConfig.heightMultiplier * 50,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              userModel.imageList[index],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : Container(
                                  child: Center(
                                    child: Text(
                                      'No Image to show',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )),
                      Positioned(
                        top: 40,
                        left: 10,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey,
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black38,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  userModel.imageList.length != 0
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SmoothPageIndicator(
                            controller: pageController, // PageController
                            count: userModel.imageList.length,
                            effect: WormEffect(
                              dotWidth: 8,
                              dotHeight: 8,
                              dotColor: Colors.grey[200],
                              activeDotColor: Colors.grey[800],
                            ), // your preferred effect
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel.name,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Row(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.all_inclusive_sharp,
                                          color: Colors.blue,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 4.0),
                                          child: Text(
                                            userModel.age.length != 0
                                                ? userModel.age
                                                : 'Not Given',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    userModel.location.length != 0
                                        ? userModel.location
                                        : 'Not seleted',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 18),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  userModel.likes.toString(),
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            : Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

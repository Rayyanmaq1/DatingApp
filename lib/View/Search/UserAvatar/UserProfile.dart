import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/route_manager.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class UserProfile extends StatefulWidget {
  //User user;
  // UserProfile({this.user});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  PageController pageController = PageController();
  Color litegreycolor = Color(0xff5a5d65);
  Color greycolor = Color(0xffb8bbc1);
  Color whitecolor = Colors.white;
  Color liteblackcolor = Color(0xff1a1a1a);

  @override
  Widget build(BuildContext context) {
    final userdataCtr = Get.put(UserDataController());
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Color(0xff191919),
        body: Column(
          children: [
            Stack(
              children: [
                GetX<UserDataController>(builder: (controller) {
                  return Container(
                      height: SizeConfig.heightMultiplier * 50,
                      child: controller.userModel.value.imageList.length != 0
                          ? PageView.builder(
                              controller: pageController,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  controller.userModel.value.imageList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: SizeConfig.heightMultiplier * 50,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          controller
                                              .userModel.value.imageList[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                'No Image to show',
                                style: TextStyle(color: Colors.white),
                              ),
                            ));
                }),
                Positioned(
                  top: 40,
                  left: 10,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: litegreycolor,
                      child: Icon(
                        Icons.arrow_back,
                        color: liteblackcolor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            userdataCtr.userModel.value.imageList.length != 0
                ? Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SmoothPageIndicator(
                      controller: pageController, // PageController
                      count: userdataCtr.userModel.value.imageList.length,
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
                        GetX<UserDataController>(builder: (controller) {
                          return Text(
                            controller.userModel.value.name,
                            style: TextStyle(color: greycolor, fontSize: 18),
                          );
                        }),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.all_inclusive_sharp,
                                    color: Colors.blue,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4.0),
                                    child: GetX<UserDataController>(
                                        builder: (controller) {
                                      return Text(
                                        controller.userModel.value.age,
                                        style: TextStyle(
                                            color: greycolor, fontSize: 18),
                                      );
                                    }),
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
                              color: greycolor,
                            ),
                            GetX<UserDataController>(builder: (controller) {
                              //print(controller.userModel.value.imageList.length);
                              return Text(
                                controller.userModel.value.location,
                                style:
                                    TextStyle(color: greycolor, fontSize: 18),
                              );
                            }),
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
                          backgroundColor: whitecolor,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            Get.find<UserDataController>()
                                .userModel
                                .value
                                .likes
                                .toString(),
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
        ),
      ),
    );
  }
}

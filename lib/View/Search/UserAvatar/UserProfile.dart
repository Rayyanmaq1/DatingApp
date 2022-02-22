import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../SizedConfig.dart';
import '../../../theme.dart';

// ignore: must_be_immutable
class UserProfile extends StatefulWidget {
  UserModel userData;
  UserProfile({this.userData});
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
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: greyColor,
      ),
      backgroundColor: Color(0xff191919),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                  height: SizeConfig.heightMultiplier * 50,
                  child: widget.userData.imageList.length != 0
                      ? PageView.builder(
                          controller: pageController,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.userData.imageList.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: SizeConfig.heightMultiplier * 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      widget.userData.imageList[index],
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
                        )),
            ],
          ),
          widget.userData.imageList.length != 0
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SmoothPageIndicator(
                    controller: pageController, // PageController
                    count: widget.userData.imageList.length,
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
                        widget.userData.name,
                        style: TextStyle(color: greycolor, fontSize: 18),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                        child: Row(
                          children: [
                            Row(children: [
                              Icon(
                                Icons.all_inclusive_sharp,
                                color: Colors.blue,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4.0),
                                child: Text(
                                  widget.userData.age,
                                  style:
                                      TextStyle(color: greycolor, fontSize: 18),
                                ),
                              ),
                            ]),
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
                          Text(
                            widget.userData.location,
                            style: TextStyle(color: greycolor, fontSize: 18),
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
                        backgroundColor: whitecolor,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.userData.likes.toString(),
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

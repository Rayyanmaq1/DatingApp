import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/get.dart';
import 'package:livu/View/Explore/Explore.dart';
import 'package:easy_localization/easy_localization.dart';

class CommunityVideo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => Get.to(() => Explore()),
      child: Row(
        children: [
          Container(
            //  color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: SizeConfig.heightMultiplier * 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: SizeConfig.widthMultiplier * 60,
                  child: new Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: <Widget>[
                      new Positioned(
                        left: 70.0,
                        child: OtherUserContainer(
                          'assets/User/user6.jpg',
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: OtherUserContainer(
                          'assets/User/user7.jpg',
                        ),
                      ),
                      Positioned(
                        left: -30,
                        child: OtherUserContainer(
                          'assets/User/user8.jpg',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // color: Colors.black,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Community Video',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 1.2),
                      ).tr(),
                      Container(
                        height: SizeConfig.heightMultiplier * 2,
                        width: SizeConfig.widthMultiplier * 2,
                        decoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: SizeConfig.imageSizeMultiplier * 5,
                      ),
                    ],
                  ),
                  width: SizeConfig.widthMultiplier * 37,
                  height: SizeConfig.heightMultiplier * 10,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  OtherUserContainer(imageUrl) {
    return Container(
      width: SizeConfig.heightMultiplier * 15,
      height: SizeConfig.widthMultiplier * 15,
      decoration: BoxDecoration(
        color: Colors.black,
        image:
            DecorationImage(image: AssetImage(imageUrl), fit: BoxFit.contain),
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Colors.black),
      ),
    );
  }
}

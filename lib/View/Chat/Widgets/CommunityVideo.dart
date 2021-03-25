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
                          'https://images.pexels.com/photos/4026110/pexels-photo-4026110.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: OtherUserContainer(
                          'https://images.pexels.com/photos/2904217/pexels-photo-2904217.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
                        ),
                      ),
                      Positioned(
                        left: -30,
                        child: OtherUserContainer(
                          'https://images.pexels.com/photos/2697242/pexels-photo-2697242.jpeg?auto=compress&cs=tinysrgb&h=750&w=1260',
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
                            fontSize: SizeConfig.textMultiplier * 1.6),
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
            DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
        shape: BoxShape.circle,
        border: Border.all(width: 2, color: Colors.black),
      ),
    );
  }
}

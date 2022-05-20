import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';

class CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.heightMultiplier * 10,
      width: MediaQuery.of(context).size.width * 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: SizeConfig.widthMultiplier * 5,
          ),
          Container(
            height: SizeConfig.heightMultiplier * 6,
            width: MediaQuery.of(context).size.width * 0.2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Videos',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.textMultiplier * 2),
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
                Container(
                  color: Color.fromRGBO(122, 106, 9, 1),
                  width: SizeConfig.widthMultiplier * 6,
                  height: SizeConfig.heightMultiplier * 0.5,
                ),
                SizedBox(
                  height: SizeConfig.heightMultiplier * 1,
                ),
              ],
            ),
          ),
        ],
      ),
      color: AppColors.greyColor,
    );
  }
}

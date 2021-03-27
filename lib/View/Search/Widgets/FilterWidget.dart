import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/settings.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:easy_localization/easy_localization.dart';

// ignore: must_be_immutable
class FilterWidget extends StatefulWidget {
  int seleted;
  FilterWidget({this.seleted});
  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: MediaQuery.of(context).size.width * 0.4,
      top: SizeConfig.heightMultiplier * 8,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) {
              return _buildDialog();
            },
          ).then((value) {
            setState(() {});
          });
        },
        child: PhysicalModel(
          color: Colors.black,
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          shadowColor: Colors.black,
          elevation: 12,
          child: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.filter_alt,
                  color: purpleColor,
                ),
                SizedBox(
                  width: SizeConfig.widthMultiplier * 1,
                ),
                Text(
                  Select_Gender,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            width: SizeConfig.widthMultiplier * 24,
            height: SizeConfig.heightMultiplier * 6,
          ),
        ),
      ),
    );
  }

  Widget _buildDialog() {
    return AlertDialog(
      titlePadding: EdgeInsets.all(0),
      title: Stack(
        children: [
          ClipPath(
            clipper: MovieTicketClipper(),
            child: Container(
              height: SizeConfig.heightMultiplier * 8,
              color: purpleColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Select_Gender_Alert',
                style: TextStyle(
                  color: Colors.white,
                )).tr(),
          ),
        ],
      ),
      contentPadding: EdgeInsets.all(12),
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Container(
          height: SizeConfig.heightMultiplier * 54.5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/userAvatar.png',
                        width: SizeConfig.widthMultiplier * 12,
                        height: SizeConfig.widthMultiplier * 15,
                      ),
                      Image.asset(
                        'assets/Female_User.png',
                        width: SizeConfig.widthMultiplier * 12,
                        height: SizeConfig.widthMultiplier * 15,
                      ),
                    ],
                  ),
                  Container(
                    width: SizeConfig.widthMultiplier * 15,
                    height: SizeConfig.widthMultiplier * 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('male_gender',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 1.8))
                            .tr(),
                        Text('Free',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 1.8))
                            .tr(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 80,
                      width: 80,
                      child: StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Radio<int>(
                            activeColor: Colors.blue,
                            value: 1,
                            groupValue: widget.seleted,
                            onChanged: (int value) {
                              setState(() {
                                Select_Gender = 'both_gender'.tr();
                                widget.seleted = value;
                                Navigator.pop(context);
                              });
                            },
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/userAvatar.png',
                        width: SizeConfig.widthMultiplier * 15,
                        height: SizeConfig.widthMultiplier * 15,
                      ),
                    ],
                  ),
                  Container(
                    width: SizeConfig.widthMultiplier * 12,
                    height: SizeConfig.widthMultiplier * 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('male_gender',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 1.8))
                            .tr(),
                        Row(
                          children: [
                            Image.asset(
                              'assets/Coin.png',
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '9',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.textMultiplier * 1.8),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Radio<int>(
                          activeColor: Colors.blue,
                          value: 2,
                          groupValue: widget.seleted,
                          onChanged: (int value) {
                            setState(() {
                              Select_Gender = 'male_gender'.tr();
                              widget.seleted = value;
                              Navigator.pop(context);
                            });
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset(
                    'assets/Female_User.png',
                    width: SizeConfig.widthMultiplier * 15,
                    height: SizeConfig.widthMultiplier * 15,
                  ),
                  Container(
                    width: SizeConfig.widthMultiplier * 14,
                    height: SizeConfig.widthMultiplier * 15,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('female_gender',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 1.8))
                            .tr(),
                        Row(
                          children: [
                            Image.asset(
                              'assets/Coin.png',
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              '12',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    child: StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                        return Radio<int>(
                          activeColor: Colors.blue,
                          value: 3,
                          groupValue: widget.seleted,
                          onChanged: (int value) {
                            setState(() {
                              Select_Gender = 'female_gender'.tr();
                              widget.seleted = value;
                              Navigator.pop(context);
                            });
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.all(12),
                height: SizeConfig.heightMultiplier * 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Balance',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: SizeConfig.textMultiplier * 1.8),
                          ).tr(),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                'assets/Coin.png',
                                width: 14,
                                height: 14,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                Get.find<UserDataController>()
                                    .userModel
                                    .value
                                    .coins
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.textMultiplier * 1.8),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        SizedBox(
                          height: SizeConfig.heightMultiplier * 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => BuyCoins());
                          },
                          child: PhysicalModel(
                            color: purpleColor,
                            borderRadius: BorderRadius.circular(4),
                            elevation: 3,
                            child: Container(
                              child: Center(
                                child: Text(
                                  'Buy_Button',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.8),
                                ).tr(),
                              ),
                              width: SizeConfig.widthMultiplier * 12,
                              height: SizeConfig.heightMultiplier * 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
      backgroundColor: greyColor,
    );
  }
}

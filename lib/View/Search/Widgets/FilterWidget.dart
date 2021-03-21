import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/View/Search/Pages/VideoCall/ConnectVideoCall.dart';
import 'package:livu/settings.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';

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
        onTap: () => showDialog(
          context: context,
          builder: (context) {
            return _buildDialog();
          },
        ).then((value) => setState(() {})),
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
                  widget.seleted == 1
                      ? 'Both'
                      : widget.seleted == 2
                          ? 'Male'
                          : 'Female',
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
            child: Text('Selet Gender',
                style: TextStyle(
                  color: Colors.white,
                )),
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
                        Text('Both',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.textMultiplier * 1.8)),
                        Text('Free',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.textMultiplier * 1.8)),
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
                                Select_Gender = 'Both';
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
                        Text('Male',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.textMultiplier * 1.8)),
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
                              Select_Gender = 'Male';
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
                        Text('Female',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.textMultiplier * 1.8)),
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
                              Select_Gender = 'Female';
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
                          ),
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
                                  'Buy',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          SizeConfig.textMultiplier * 1.8),
                                ),
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

// class RPSCustomPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint_0 = new Paint()
//       ..color = purpleColor
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 1;

//     Path path_0 = Path();
//     path_0.moveTo(0, 0);
//     path_0.lineTo(size.width, 0);
//     path_0.lineTo(size.width, size.height * 0.9800000);
//     path_0.lineTo(size.width * 0.9675000, size.height * 0.8100000);
//     path_0.lineTo(size.width * 0.9350000, size.height * 0.6000000);
//     path_0.lineTo(size.width * 0.8850000, size.height * 0.5500000);
//     path_0.lineTo(size.width * 0.8325000, size.height * 0.5800000);
//     path_0.lineTo(size.width * 0.7975000, size.height * 0.7600000);
//     path_0.lineTo(size.width * 0.7375000, size.height * 0.8700000);
//     path_0.lineTo(size.width * 0.6850000, size.height * 0.8100000);
//     path_0.lineTo(size.width * 0.6400000, size.height * 0.7400000);
//     path_0.lineTo(size.width * 0.6025000, size.height * 0.6000000);
//     path_0.lineTo(size.width * 0.5425000, size.height * 0.4800000);
//     path_0.lineTo(size.width * 0.4800000, size.height * 0.4700000);
//     path_0.lineTo(size.width * 0.4050000, size.height * 0.6800000);
//     path_0.lineTo(size.width * 0.3525000, size.height * 0.8100000);
//     path_0.lineTo(size.width * 0.3100000, size.height * 0.8700000);
//     path_0.lineTo(size.width * 0.2625000, size.height * 0.8600000);
//     path_0.lineTo(size.width * 0.2225000, size.height * 0.8000000);
//     path_0.lineTo(size.width * 0.1825000, size.height * 0.7000000);
//     path_0.lineTo(size.width * 0.1375000, size.height * 0.5200000);
//     path_0.lineTo(size.width * 0.0750000, size.height * 0.6000000);
//     path_0.lineTo(size.width * 0.0325000, size.height * 0.8100000);
//     path_0.lineTo(size.width * 0.0025000, size.height * 0.9900000);
//     path_0.lineTo(0, 0);
//     path_0.close();

//     canvas.drawPath(path_0, paint_0);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) {
//     return true;
//   }
// }

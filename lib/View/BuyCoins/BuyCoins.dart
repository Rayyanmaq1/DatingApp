import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:livu/View/BuyCoins/paypal_payment/make_payment.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/Model/Coin.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/View/BuyCoins/payment.dart';

class BuyCoins extends StatefulWidget {
  @override
  _BuyCoinsState createState() => _BuyCoinsState();
}

class _BuyCoinsState extends State<BuyCoins> {
  @override
  List<BuyCoin> data = getCoinData();

// add you merchantId as per apple developer account      androidPayMode: 'test',     ),  );}

  final userData = Get.find<UserDataController>().userModel.value;

  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        bottomNavigationBar: Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Contact us if you have any Question',
                style: TextStyle(color: Colors.white),
              ).tr(),
              Text('Community_Service',
                      style: TextStyle(
                          color: Colors.orange[800],
                          decoration: TextDecoration.underline))
                  .tr(),
            ],
          ),
        ),
        backgroundColor: greyColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              title: Text('buy_coins').tr(),
              backgroundColor: greyColor,
            ),
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                        text: 'Your Have'.tr(),
                        style: TextStyle(
                            fontSize: SizeConfig.textMultiplier * 2,
                            color: orangeColor),
                        children: [
                          TextSpan(
                              text: userData.coins.toString(),
                              style: TextStyle(
                                  fontSize: SizeConfig.textMultiplier * 3),
                              children: [
                                TextSpan(
                                  text: 'Left'.tr(),
                                  style: TextStyle(
                                      fontSize: SizeConfig.textMultiplier * 2),
                                )
                              ])
                        ]),
                  )
                ],
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(12),
              sliver: _buildGridView(),
            ),
          ],
        ),
      ),
    );
  }

  _buildGridView() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        crossAxisCount: 2,
        childAspectRatio: 1 / 1.35,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return data[index].offer != Offer.SALE
              ? _buildCoinOfferContainer(index)
              : _buildSaleContainer(index);
        },
        childCount: data.length,
      ),
    );
  }

  _buildCoinOfferContainer(index) {
    return Stack(
      children: [
        Container(
          width: SizeConfig.widthMultiplier * 50,
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[700], width: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Text(
                    data[index].title,
                    style: TextStyle(
                        color: Colors.orange[900],
                        fontSize: SizeConfig.textMultiplier * 1.5),
                  ),
                ),
                height: SizeConfig.heightMultiplier * 2.2,
                width: SizeConfig.widthMultiplier * 18,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.orange[800].withOpacity(0.3),
                ),
              ),
              Image.asset(
                data[index].imageUrl,
                width: SizeConfig.widthMultiplier * 16,
                height: SizeConfig.heightMultiplier * 12,
              ),
              Text(
                data[index].coins,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 3,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: SizeConfig.heightMultiplier * 1,
              ),
              RawMaterialButton(
                onPressed: () {
                  startPayment(data[index].price, data[index].coins);
                },
                child: Container(
                  height: SizeConfig.heightMultiplier * 4,
                  width: SizeConfig.widthMultiplier * 35,
                  child: Center(
                      child: Text(
                    '\$ ' + data[index].price,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.textMultiplier * 2),
                  )),
                  decoration: BoxDecoration(
                    color: purpleColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 18,
          left: 8,
          child: data[index].offer != Offer.NONE
              ? ClipPath(
                  clipper: StarClipper(8),
                  child: Center(
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7,
                      width: SizeConfig.heightMultiplier * 7,
                      color: redColor,
                      child: Center(
                          child: Text(
                        data[index].offer.toString().substring(6),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.textMultiplier * 1.5),
                      )),
                    ),
                  ),
                )
              : Container(),
        ),
      ],
    );
  }

  _buildSaleContainer(index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700], width: 1),
      ),
      child: Stack(
        children: [
          Image.asset(data[index].imageUrl),
          Positioned(
            top: 40,
            left: 35,
            child: Center(
              child: Text(
                data[index].title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 3,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: 35,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    data[index].coins,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.textMultiplier * 3),
                  ),
                  Image.asset(
                    'assets/Coin.png',
                    width: SizeConfig.widthMultiplier * 10,
                    height: SizeConfig.heightMultiplier * 6,
                  )
                ],
              ),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(8)),
            ),
            width: SizeConfig.widthMultiplier * 30,
            height: SizeConfig.heightMultiplier * 8,
          ),
          Positioned(
            bottom: 25,
            left: 20,
            child: RawMaterialButton(
              onPressed: () {
                startPayment(data[index].price, data[index].coins);
              },
              child: Container(
                height: SizeConfig.heightMultiplier * 4,
                width: SizeConfig.widthMultiplier * 35,
                child: Center(
                    child: Text(
                  '\$ ' + data[index].price,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: SizeConfig.textMultiplier * 2),
                )),
                decoration: BoxDecoration(
                  color: purpleColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  startPayment(price, coins) async {
    print(coins);
    double amount = double.parse(price) * 100;
    int finalAmount = amount.toInt();
    int coin = int.parse(coins);
    print(finalAmount);

    // Get.to(() => Payment(
    //       finalAmount: finalAmount,
    //       coins: coin,
    //     ));
    Get.to(() => MakePayment());
  }
}

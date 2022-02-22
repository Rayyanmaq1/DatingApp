import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:livu/View/SplashScreen.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Color white_color = Colors.white;
  Color red_color = Color(0xffc7474e);
  Color amber_color = Color(0xffcea452);
  Color black_color = Color(0xff161616);
  Color lite_black_color = Color(0xff1a1a1a);
  Color grey_color = Color(0xffb8bbc1);

  bool varIsInstructionView1 = true;
  bool varIsInstructionView2 = true;
  bool varIsInstructionView3 = true;
  bool varIsInstructionView4 = true;
  bool varIsInstructionView5 = true;
  bool varIsInstructionView6 = true;

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: lite_black_color,
        appBar: AppBar(
          elevation: 2,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: black_color,
          title: Text(
            "Setting Screen",
            style: TextStyle(
              color: grey_color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              listTileBar(
                  title: "Blur Effect",
                  IsInstructionView: varIsInstructionView1,
                  ontab: (newValue) => setState(() {
                        varIsInstructionView1 = newValue;
                      }),
                  toogleValue: true),
              listTileBar(
                  title: "Message Notification",
                  IsInstructionView: varIsInstructionView2,
                  ontab: (newValue) => setState(() {
                        varIsInstructionView2 = newValue;
                      }),
                  toogleValue: true,
                  isPadding: false),
              listTileBar(
                  title: "Incomming call notification",
                  IsInstructionView: varIsInstructionView3,
                  ontab: (newValue) => setState(() {
                        varIsInstructionView3 = newValue;
                      }),
                  toogleValue: true,
                  isPadding: false),
              listTileBar(
                  title: "Friend Online notification",
                  IsInstructionView: varIsInstructionView4,
                  ontab: (newValue) => setState(() {
                        varIsInstructionView4 = newValue;
                      }),
                  toogleValue: true,
                  isPadding: false),
              listTileBar(
                  title: "Liked notification",
                  IsInstructionView: varIsInstructionView5,
                  ontab: (newValue) => setState(() {
                        varIsInstructionView5 = newValue;
                      }),
                  toogleValue: true,
                  isPadding: false),
              listTileBar(
                  title: "Reminder list entrance",
                  IsInstructionView: varIsInstructionView6,
                  ontab: (newValue) => setState(() {
                        varIsInstructionView6 = newValue;
                      }),
                  toogleValue: true,
                  isPadding: false),
              listTileBar(title: "Blacklist", isPadding: true),
              listTileBar(
                title: "Help and feedback",
              ),
              listTileBar(title: "Version", subTitle: "01.01.69", id: 0),
              logButton(
                btntitle: "Log Out",
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logButton({String btntitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          FirebaseAuth.instance.signOut();
          Get.offAll(() => SplashScreen());
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * .09,
          color: black_color,
          child: Center(
            child: Text(
              btntitle,
              style: TextStyle(color: red_color, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }

  Widget listTileBar(
      {String title,
      String subTitle,
      int id,
      IsInstructionView,
      ontab,
      toogleValue,
      bool isPadding}) {
    return Padding(
      padding: isPadding == true
          ? const EdgeInsets.only(top: 5.0, bottom: 5)
          : const EdgeInsets.only(top: 0.0, bottom: 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .09,
        color: black_color,
        child: ListTile(
          leading: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: grey_color,
                  fontSize: 16,
                ),
              ),
              id == 0
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        subTitle,
                        style: TextStyle(
                          color: white_color,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          trailing: toogleValue == true
              ? Switch.adaptive(
                  value: IsInstructionView,
                  onChanged: ontab,
                  activeColor: amber_color,
                )
              : SizedBox(),
        ),
      ),
    );
  }
}

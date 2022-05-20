import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:livu/View/SplashScreen.dart';

class BlockedUser {
  checkifuserBlocked(context) {
    FirebaseFirestore.instance
        .collection('BlockedList')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) {
      if (value.exists) {
        showDialog(
            barrierDismissible: false,
            context: (context),
            builder: (context) {
              return AlertDialog(
                backgroundColor: AppColors.greyColor,
                title: Text(
                  'You Have Been Blocked by Admin',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                content: Container(
                  height: SizeConfig.heightMultiplier * 10,
                  child: Column(
                    children: [
                      Text(
                        'You Have been Bloacked by admin due to some issue log out and signin by oher account',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: SizeConfig.textMultiplier * 1.6),
                      )
                    ],
                  ),
                ),
                actions: [
                  FlatButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signOut();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      prefs.clear();
                      Get.offAll(() => SplashScreen());
                    },
                    child: Text(
                      'Log out',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            });
      } else {
        print("NotBlocked");
      }
    });
  }
}

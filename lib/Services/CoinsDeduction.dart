import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';
class CoinsDeduction {
  setCoins(int currentcoins, int deductCoins) {
    Map<String, dynamic> setCoins = {
      'Coins': currentcoins - deductCoins,
    };
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(setCoins);
  }
  addCoins(coins){
    Map<String, dynamic> setCoins = {
      'Coins': Get.find<UserDataController>().userModel.value.coins + coins,
    };
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update(setCoins);
  }
}

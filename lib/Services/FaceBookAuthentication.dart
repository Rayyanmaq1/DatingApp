import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livu/View/CustomNavigation/CustomNavigation.dart';
import 'package:livu/View/UserData/Userdata.dart';

class FaceBookAuthentcation {
  Map userProfile;
  // ignore: missing_return
  Future<bool> signInWithFacebook() async {
    var fbLogin = FacebookLogin();

    var result =
        await fbLogin.logIn(['email', 'public_profile']).catchError((e) {
      print(e);
    });

    // if (result.status == FacebookLoginStatus.loggedIn) {
    FacebookAccessToken myToken = result.accessToken;
    AuthCredential credential =
        // ignore: deprecated_member_use
        FacebookAuthProvider.credential(myToken.token);

    var user = await FirebaseAuth.instance
        .signInWithCredential(credential)
        .catchError(((e) {
      print(e);
    }));

    await FirebaseFirestore.instance
        .collection('UserData')
        .doc(user.user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        Get.offAll(() => CustomNavigation());
      } else {
        Get.offAll(() => UserData());

        return true;
      }
    });
  }
}

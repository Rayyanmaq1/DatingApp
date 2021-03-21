import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:livu/View/CustomNavigation/CustomNavigation.dart';
import 'package:livu/View/UserData/Userdata.dart';

class GmailAuthentication {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  registerWithGmail() async {
    final GoogleSignInAccount _signInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth =
        await _signInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: _googleAuth.accessToken, idToken: _googleAuth.idToken);

    final User user =
        await _auth.signInWithCredential(credential).then((value) {
      return value.user;
    });

    await FirebaseFirestore.instance
        .collection('UserData')
        .doc(user.uid)
        .get()
        .then((value) {
      if (value.exists) {
        Get.offAll(() => CustomNavigation());
      } else {
        Get.offAll(() => UserData());
      }
    });
  }
}

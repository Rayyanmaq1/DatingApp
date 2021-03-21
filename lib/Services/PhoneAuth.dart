import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:livu/View/UserData/Userdata.dart';

String verificationId;

class AuthService {
  String phoneNo, smsCode;
  //Handles Auth
  // handleAuth() {
  //   return StreamBuilder(
  //       stream: FirebaseAuth.instance.onAuthStateChanged,
  //       builder: (BuildContext context, snapshot) {
  //         if (snapshot.hasData) {
  //           return DashboardPage();
  //         } else {
  //           return LoginPage();
  //         }
  //       });
  // }

  //Sign out
  signOut() {
    FirebaseAuth.instance.signOut();
  }

  //SignIn
  signIn(AuthCredential authCreds) {
    print(authCreds.signInMethod);
    FirebaseAuth.instance.signInWithCredential(authCreds).catchError((e) {
      if (e.toString() ==
          '[firebase_auth/invalid-verification-code] The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user.') {
        Fluttertoast.showToast(
            msg: "Incorrect Code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      } else if (e.toString() ==
          '[firebase_auth/session-expired] The sms code has expired. Please re-send the verification code to try again.') {
        Fluttertoast.showToast(
            msg: "Time Expired",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  signInWithOTP(smsCode) {
    //print(verificationId);
    AuthCredential authCreds = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    // authCreds.token == null
    //     ? Fluttertoast.showToast(
    //         msg: "Incorrect Code",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.black,
    //         textColor: Colors.white,
    //         fontSize: 16.0)
    signIn(authCreds);
    Get.offAll(() => UserData());
  }

  Future<void> verifyPhone(phoneNo) async {
    print(phoneNo);
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print(authException.message);
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      print('Verification ID: ' + verId);
      verificationId = verId;
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      verificationId = verId;
    };

    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: phoneNo,
            timeout: const Duration(seconds: 120),
            verificationCompleted: verified,
            verificationFailed: verificationfailed,
            codeSent: smsSent,
            codeAutoRetrievalTimeout: autoTimeout)
        .catchError((e) {
      print(e);
    });
  }
}

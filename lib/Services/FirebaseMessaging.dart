import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:livu/Services/LocalNotification.dart';
import 'package:http/http.dart' as http;

class FirebaseMessage {
  Future initailize() async {
    // final FirebaseMessaging _messaging = FirebaseMessaging();
    // _messaging.requestNotificationPermissions();
    // if (Platform.isIOS) {
    //   _messaging.requestNotificationPermissions(IosNotificationSettings());
    // }
    // _messaging.configure(onMessage: (Map<String, dynamic> message) {
    //   print('onMessage: $message');
    //   final data = message['data'];

    //   final title = data['title'];
    //   final body = data['message'];
    //   LocalNotification(title: title, body: body);

    //   return;
    // }, onResume: (Map<String, dynamic> message) {
    //   print('onResume: $message');
    //   // LocalNotification(title: message['notification']);
    //   return;
    // }, onLaunch: (Map<String, dynamic> message) {
    //   print('onLaunch: $message');
    //   // LocalNotification(title: message['notification']);
    //   return;
    // });

    // _messaging.getToken().then((token) {
    //   print('token: $token');
    //   // print(FirebaseAuth.instance.currentUser.uid);
    //   FirebaseFirestore.instance
    //       .collection('users')
    //       .doc(FirebaseAuth.instance.currentUser.uid)
    //       .set({'pushToken': token});
    // }).catchError((err) {
    //   Fluttertoast.showToast(msg: err.message.toString());
    // });
  }
}

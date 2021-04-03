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
    final FirebaseMessaging _messaging = FirebaseMessaging();
    _messaging.requestNotificationPermissions();
    if (Platform.isIOS) {
      _messaging.requestNotificationPermissions(IosNotificationSettings());
    }
    _messaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      // LocalNotification(title: message['notification']);

      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      // LocalNotification(title: message['notification']);
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      // LocalNotification(title: message['notification']);
      return;
    });

    _messaging.getToken().then((token) {
      print('token: $token');
      // print(FirebaseAuth.instance.currentUser.uid);
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .set({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  Future<bool> sendFcmMessage(String title, String message) async {
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAiFjVFR0:APA91bHLTBwPK34HKn-xKRYyp1gMLMGA-63DsULG9A-E42xQUBL5stRDPxBvwM3G-X66yrCmvaUrJdN03srigrqj6l8MFNO9JKX8jH5kL_VzRcQXrbt-fJftHsH4QmmOyI-XHkzCoHI6",
      };
      var request = {
        "notification": {
          "title": title,
          "text": message,
          "sound": "default",
          "color": "#990000",
        },
        "priority": "high",
        "to": "/topics/all",
      };

      // var client = new Client();
      var response =
          await http.post(url, headers: header, body: jsonEncode(request));
      print(response.headers);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

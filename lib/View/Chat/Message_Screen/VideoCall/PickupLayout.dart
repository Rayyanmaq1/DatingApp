import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:get/get.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:livu/Controller/PrivateVideoController.dart';
import 'PickUpScreen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  // final CallMethods callMethods = CallMethods();

  PickupLayout({
    @required this.scaffold,
  });

  @override
  Widget build(BuildContext context) {
    print(Get.find<UserDataController>().userModel.value.id);
    // final userProvider = Get.find<UserDataController>().userModel.value;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('PrivateCall')
          .where('receiver_id',
              isEqualTo: Get.find<UserDataController>().userModel.value.id)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data.docs.length != 0) {
          Call call = Call.fromMap(snapshot.data.docs.first);

          if (!call.hasDialled) {
            return PickupScreen(call: call);
          }
        }

        return scaffold;
      },
    );
    // : Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
  }
}

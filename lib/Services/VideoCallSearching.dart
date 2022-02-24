import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:livu/Model/CallModel.dart';
import 'package:livu/View/Search/Pages/VideoCall/VideoCall.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:livu/settings.dart';

class VideoCallService {
  UserModel currentUser = Get.find<UserDataController>().userModel.value;
  searchVideocall() {
    Map<String, dynamic> userData = {
      'Uid': currentUser.id,
      'Name': currentUser.name,
      'ImageUrl': currentUser.imageUrl,
      'Likes': currentUser.likes,
      'SelectedGender': Seleted_Genter_value,
      'Location': currentUser.location,
      'ChannelId': 'Id',
      'Age': currentUser.age,
      'timeStamp': DateTime.now().millisecondsSinceEpoch,
    };

    FirebaseFirestore.instance
        .collection('SearchVideoCall')
        .doc(currentUser.id)
        .set(userData);
  }

  Stream<List<CallModel>> getAllsearches() {
    return FirebaseFirestore.instance
        .collection('SearchVideoCall')
        .where('SeletedGender', isEqualTo: Seleted_Genter_value)
        .snapshots()
        .map((QuerySnapshot query) {
      List<CallModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(CallModel.fromQueryDocumnentSnapshot(element));
      });

      return retVal;
    });
  }

  connectCall(CallModel model, cameraController) async {
    var channelId = UniqueKey().toString();
    // print("likes : " + model.likes.toString() + currentUser.likes.toString());
    Map<String, dynamic> userData = {
      'ReciverUid': model.uid,
      'ReciverName': model.name,
      'ReciverImageUrl': model.imageUrl,
      'ReciverLikes': model.likes,
      'ReciverLocation': model.location,
      'ReciverAge': model.age,
      'SenderUid': currentUser.id,
      'SenderName': currentUser.name,
      'SenderImageUrl': currentUser.imageUrl,
      'SenderLikes': currentUser.likes,
      'SenderLocation': currentUser.location,
      'ChannelId': channelId,
      'SenderAge': currentUser.age,
    };
    deleteUserFromSearch();
    FirebaseFirestore.instance
        .collection('SearchVideoCall')
        .doc(model.uid)
        .delete();

    FirebaseFirestore.instance
        .collection('ConnectedVideoCall')
        .doc()
        .set(userData);
    Future.delayed(Duration(seconds: 2), () {
      FirebaseFirestore.instance
          .collection('ConnectedVideoCall')
          .doc(model.uid)
          .get()
          .then((value) {
        print('data');
        print(value.data());
        Get.off(() => VideoCall(
              id: value.id,
              cameraController: cameraController,
              matchedInfo: value.data(),
            ));
      });
    });
  }

  deleteUserFromSearch() {
    FirebaseFirestore.instance
        .collection('SearchVideoCall')
        .doc(currentUser.id)
        .delete();
  }

  checkIfIGotMatched(CameraController cameraController) async {
    print('checking');

    await FirebaseFirestore.instance
        .collection('ConnectedVideoCall')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.get('SenderUid') == currentUser.id ||
            element.get('ReciverUid') == currentUser.id) {
          deleteUserFromSearch();
          print(element.data());
          Get.off(
            () => VideoCall(
              cameraController: cameraController,
              matchedInfo: element.data(),
              id: element.id,
            ),
          );
        }
      });
    });
  }
}

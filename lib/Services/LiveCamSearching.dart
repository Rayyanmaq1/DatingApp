import 'package:livu/Model/UserModel.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Model/LiveCamModel.dart';
// import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:livu/View/Search/Pages/LiveCam/LiveCam.dart';

class LiveCamService {
  UserModel currentUser = Get.find<UserDataController>().userModel.value;
  searchLiveCam() {
    Map<String, dynamic> userData = {
      'Uid': currentUser.id,
      'Name': currentUser.name,
      'ImageUrl': currentUser.imageUrl,
      'Interest': currentUser.interest,
      'Location': currentUser.location,
      'Age': currentUser.age,
      'Likes': currentUser.likes,
    };
    FirebaseFirestore.instance
        .collection('SearchLiveCam')
        .doc(currentUser.id)
        .set(userData);
  }

  Stream<List<LiveCamModel>> getAllsearches() {
    return FirebaseFirestore.instance
        .collection('SearchLiveCam')
        .snapshots()
        .map((QuerySnapshot query) {
      List<LiveCamModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(LiveCamModel.fromDocumentSnapshot(element));
      });

      return retVal;
    });
  }

  addFriend(Map<String, dynamic> callData) async {
    String otherUserUid = callData['SenderUid'] != currentUser.id
        ? callData['SenderUid']
        : callData['ReciverUid'];
    Map<String, dynamic> setFriendRequest = {
      'Uid': otherUserUid,
      'Name': callData['SenderUid'] != currentUser.id
          ? callData['SenderName']
          : callData['ReciverName'],
      'ImageUrl': callData['SenderUid'] != currentUser.id
          ? callData['SenderImageUrl']
          : callData['ReciverImageUrl'],
      'time': DateTime.now().toString().substring(0, 10),
    };
    await FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUser.id)
        .collection('FriendRequests')
        .doc(otherUserUid)
        .set(setFriendRequest);
  }

  connectCall(LiveCamModel model, cameraController) async {
    var channelId = UniqueKey().toString();
    Map<String, dynamic> userData = {
      'ReciverUid': model.uid,
      'ReciverName': model.name,
      'ReciverImageUrl': model.imageUrl,
      'ReciverInterest': model.interest,
      'ReciverLocation': model.location,
      'ReciverLikes': model.likes,
      'ReciverAge': model.age,
      'SenderUid': currentUser.id,
      'SenderName': currentUser.name,
      'SenderImageUrl': currentUser.imageUrl,
      'SenderLikes': currentUser.likes,
      'SenderLocation': currentUser.location,
      'ChannelId': channelId,
      'SenderAge': currentUser.age,
      'SenderInterest': currentUser.interest,
      'SenderLike': false,
      'ReciverLike': false,
    };
    deleteUserFromSearch();
    FirebaseFirestore.instance
        .collection('SearchLiveCam')
        .doc(model.uid)
        .delete();

    FirebaseFirestore.instance
        .collection('ConnectedLiveCam')
        .doc()
        .set(userData);
    Future.delayed(Duration(seconds: 2), () {
      FirebaseFirestore.instance
          .collection('ConnectedLiveCam')
          .doc(model.uid)
          .get()
          .then((value) {
        print('data');
        print(value.data());
        Get.off(() => LiveCam(
              id: value.id,
              matchedData: userData,
            ));
      });
    });
  }

  deleteUserFromSearch() {
    FirebaseFirestore.instance
        .collection('SearchLiveCam')
        .doc(currentUser.id)
        .delete();
  }

  giveHeart(id, variable) {
    print(id);
    Map<String, dynamic> updateHeart = {variable: true};
    FirebaseFirestore.instance
        .collection('ConnectedLiveCam')
        .doc(id)
        .update(updateHeart);
  }

  deleteVideoCall(id) {
    FirebaseFirestore.instance.collection('ConnectedLiveCam').doc(id).delete();
  }

  checkIfIGotMatched(CameraController cameraController) async {
    print('checking');

    await FirebaseFirestore.instance
        .collection('ConnectedLiveCam')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.data());
        if (element.get('SenderUid') == currentUser.id ||
            element.get('ReciverUid') == currentUser.id) {
          deleteUserFromSearch();

          Get.off(
            () => LiveCam(
              cameraController: cameraController,
              matchedData: element.data(),
              id: element.id,
            ),
          );
        }
      });
    });
  }

  history(historyCollection, Map<String, dynamic> callData) {
    print('Histoery Witten');
    String otherUserUid = callData['SenderUid'] != currentUser.id
        ? callData['SenderUid']
        : callData['ReciverUid'];
    Map<String, dynamic> historyData = {
      'Uid': otherUserUid,
      'Name': callData['SenderUid'] != currentUser.id
          ? callData['SenderName']
          : callData['ReciverName'],
      'ImageUrl': callData['SenderUid'] != currentUser.id
          ? callData['SenderImageUrl']
          : callData['ReciverImageUrl'],
      'Location': callData['SenderUid'] != currentUser.id
          ? callData['SenderLocation']
          : callData['ReciverLocation'],
      'Likes': callData['SenderUid'] != currentUser.id
          ? callData['SenderLikes']
          : callData['ReciverLikes'],
      'Date': DateTime.now().toString().substring(0, 10),
    };
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUser.id)
        .collection(historyCollection)
        .doc(otherUserUid)
        .set(historyData);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/call.dart';
import 'package:livu/Model/MessageModel.dart';

class PrivateCallService {
  final currentUserData = Get.put(UserDataController()).userModel.value;

  setData(data) {
    String currentUid = FirebaseAuth.instance.currentUser.uid;
    FirebaseFirestore.instance
        .collection('PrivateCall')
        .doc(currentUid)
        .set(data);
  }

  deleteCall(id) {
    FirebaseFirestore.instance.collection('PrivateCall').doc(id).delete();
  }

  checkCallifExist(docID) {
    return FirebaseFirestore.instance
        .collection('PrivateCall')
        .doc(docID)
        .get()
        .then((value) {
      if (!value.exists) {
        return false;
      }
    });
  }

  Stream<List<Call>> getVideCallData() {
    String currentUid = FirebaseAuth.instance.currentUser.uid;
    return FirebaseFirestore.instance
        .collection('PrivateCall')
        .where('receiver_id', isEqualTo: currentUid)
        .snapshots()
        .map((QuerySnapshot query) {
      print(query.docs.length);
      List<Call> retVal = List();
      query.docs.forEach((element) {
        retVal.add(Call.fromMap(element));
      });

      return retVal;
    });
  }

  void randomVideoCall(String documentId) {
    FirebaseFirestore.instance
        .collection('ConnectedVideoCall')
        .doc(documentId)
        .delete();
  }

  sendAddFriendRequest(toSenduid) {
    Map<String, dynamic> sendRequestData = {
      'ImageUrl': currentUserData.imageUrl,
      'Uid': currentUserData.id,
      'Name': currentUserData.name,
      'time': DateTime.now().toString().substring(0, 10),
    };
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(toSenduid)
        .collection('FriendRequests')
        .doc(currentUserData.id)
        .set(sendRequestData);
  }

  giveLike(toSenduid, int likes) {
    print('SenderUid: ' + toSenduid.toString());
    print('Likes : ' + likes.toString());
    Map<String, dynamic> giveLike = {'Likes': likes + 1};
    print('giveLike : ' + giveLike.toString());

    FirebaseFirestore.instance
        .collection('UserData')
        .doc(toSenduid)
        .update(giveLike);
  }

  sendMessage(
      {String messageText,
      String imageUrl,
      tosendUid,
      tosendImage,
      tosendName}) {
    final reference = FirebaseDatabase.instance.reference().child('messages');

    reference.push().set({
      MESSAGE_TEXT: messageText,
      SENDER_UID: currentUserData.id,
      RECEIVER_UID: tosendUid,
      MESSAGE_IMAGE_URL: imageUrl,
      SENDER_NAME: currentUserData.name,
      SENDER_IMAGE_URL: currentUserData.imageUrl,
    }).catchError((e) {
      print(e);
    });

    _sendLatestMessage(messageText, tosendUid, tosendImage, tosendName);
  }

  void _sendLatestMessage(
      String latestMessage, String tosendUid, tosendImage, tosendName) {
    print(USERS_COLLECTION + ' here  ' + LATEST_MESSAGES);
    CollectionReference _receiverColl = FirebaseFirestore.instance
        .collection('UserData')
        .doc(tosendUid)
        .collection('last_message');
    CollectionReference _userColl = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(currentUserData.id)
        .collection('last_message');

    // DocumentReference _recRef = FirebaseFirestore.instance
    //     .collection(USERS_COLLECTION)
    //     .doc(widget.lastMessage.uid);
    // DocumentReference _userRef = FirebaseFirestore.instance
    //     .collection(USERS_COLLECTION)
    //     .doc(Get.find<UserDataController>().userModel.value.id);

    _userColl.doc(tosendUid).set({
      LATEST_MESSAGE: latestMessage,
      // LATEST_REFERENCE: _recRef,
      'chatters': [
        {
          'uid': currentUserData.id,
          'dp': currentUserData.imageUrl,
          'name': currentUserData.name,
          'isTyping': false
        },
        {
          'uid': tosendUid,
          'dp': tosendImage,
          'name': tosendName,
          'isTyping': false
        }
      ],
      'chattersUid': [currentUserData.id, tosendUid],
      MESSAGE_TIME: DateTime.now().toString(),
      'Uid': tosendUid,
      'ImageUrl': tosendImage,
      'Name': tosendName,
    }).catchError((e) {
      // print(e);
    });
    print('asdasd');
    // print(_userRef);
    _receiverColl.doc(Get.find<UserDataController>().userModel.value.id).set({
      LATEST_MESSAGE: latestMessage,
      'Uid': Get.find<UserDataController>().userModel.value.id,
      'ImageUrl': Get.find<UserDataController>().userModel.value.imageUrl,
      'Name': Get.find<UserDataController>().userModel.value.name,
      // ignore: equal_keys_in_map
      // LATEST_REFERENCE: _userRef,
      // ignore: equal_keys_in_map
      MESSAGE_TIME: DateTime.now().toString()
    });
  }
}

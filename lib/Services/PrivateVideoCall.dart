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
    Map<String, dynamic> giveLike = {'Likes': likes + 1};

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
      tosendName}) async {
    final reference = FirebaseDatabase.instance.ref().child('messages');
    String docID = await _sendLatestMessage(
        messageText, tosendUid, tosendImage, tosendName);

    reference.push().set({
      CHATDOCID: docID,
      TIMESTAMP: DateTime.now().millisecondsSinceEpoch,
      MESSAGE_TEXT: messageText,
      SENDER_UID: currentUserData.id,
      RECEIVER_UID: tosendUid,
      MESSAGE_IMAGE_URL: imageUrl,
      SENDER_NAME: currentUserData.name,
      SENDER_IMAGE_URL: currentUserData.imageUrl,
    }).catchError((e) {
      print(e);
    });
  }

  Future<String> _sendLatestMessage(
      String latestMessage, String tosendUid, tosendImage, tosendName) {
    Map<String, dynamic> msg = {
      LATEST_MESSAGE: latestMessage,
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
    };
    bool msgFound = false;
    return FirebaseFirestore.instance
        .collection('lastMessage')
        .where('chattersUid', arrayContains: currentUserData.id)
        .get()
        // ignore: missing_return
        .then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i].data()['chattersUid'].contains(tosendUid)) {
          FirebaseFirestore.instance
              .collection('lastMessage')
              .doc(value.docs[i].id)
              .update(msg);
          msgFound = true;
          return value.docs[i].id;
        }
      }
      if (!msgFound) {
        return FirebaseFirestore.instance
            .collection('lastMessage')
            .add(msg)
            .then((value) {
          return value.id;
        });
      }
    });
  }
}

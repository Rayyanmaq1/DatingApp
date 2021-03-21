import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:get/get.dart';
import 'package:livu/Model/FriendRequest_Model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:livu/Model/FriendRequest_Model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendRequestService {
  currentUid() {
    return FirebaseAuth.instance.currentUser.uid;
  }

  Stream<List<FriendRequest>> getfriendRequests() {
    return FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection('FriendRequests')
        .snapshots()
        .map((QuerySnapshot query) {
      List<FriendRequest> retVal = List();
      query.docs.forEach((element) {
        retVal.add(FriendRequest.fromDocumentSnapshot(data: element));
      });

      return retVal;
    });
  }

  getUsersData(RxList<FriendRequest> friendRequestCtr,
      RxList<UserModel> otherUserDataCtr) async {
    DocumentSnapshot userData;
    for (int i = 0; i < friendRequestCtr.length; i++) {
      userData = await FirebaseFirestore.instance
          .collection('UserData')
          .doc(friendRequestCtr[i].otherUserUid)
          .get();
      otherUserDataCtr.add(UserModel.fromDocumentSnapshot(userData));
      print('this');
    }
  }

  deleteFriendRequest(deleteUserUid) {
    String currentUserUid = currentUid();
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUserUid)
        .collection('FriendRequests')
        .doc(deleteUserUid)
        .delete();
  }

  acceptUser(requestUserUid, name, image) {
    String currentUserUid = currentUid();
    DocumentReference ref =
        FirebaseFirestore.instance.collection('UserData').doc(currentUserUid);
    DocumentReference messageUserRef =
        FirebaseFirestore.instance.collection('UserData').doc(requestUserUid);

    ref.collection('FriendRequests').doc(requestUserUid).delete();
    ref.collection('Friends').doc(requestUserUid).set(({
          'ImageUrl': image,
          'Name': name,
          'Uid': requestUserUid,
        }));
    ref.collection('last_message').doc(requestUserUid).set({
      'last_message': 'Now you can chat with each other',
      'lastestRederence': messageUserRef,
      'messageTime': DateTime.now().toString(),
      'ImageUrl': image,
      'Name': name,
      'Uid': requestUserUid,
    });
  }
}

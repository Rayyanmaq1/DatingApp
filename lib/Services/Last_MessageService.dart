import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:get/get.dart';

class LastMessageService {
  currentUid() {
    return FirebaseAuth.instance.currentUser.uid;
  }

  deleteChat(List<String> seletedUser) {
    for (int i = 0; i < seletedUser.length; i++) {
      print(seletedUser[i]);
      FirebaseFirestore.instance
          .collection('UserData')
          .doc(currentUid())
          .collection('last_message')
          .doc(seletedUser[i])
          .delete();
    }
  }

  Stream<List<LastMessage>> getfriendRequests() {
    return FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection('last_message')
        .snapshots()
        .map((QuerySnapshot query) {
      List<LastMessage> retVal = List();
      query.docs.forEach((element) {
        retVal
            .add(LastMessage.fromDocumentSnapshot(element.data(), element.id));
      });

      return retVal;
    });
  }

  addtofriend(uid, name, imageUrl) {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('UserData').doc(currentUid());
    ref.collection('FavFriends').doc(uid).delete();
    ref.collection('Friends').doc(uid).set(({
          'ImageUrl': imageUrl,
          'Uid': uid,
          'Name': name,
        }));
  }

  Future<bool> checkIfUserisFav(uid) async {
    return await FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection('FavFriends')
        .doc(uid)
        .get()
        .then((value) {
      print(value.exists);
      if (value.exists) {
        return true;
      } else {
        return false;
      }
    });
  }

  addtoFavFriend(uid, name, imageUrl) {
    DocumentReference ref =
        FirebaseFirestore.instance.collection('UserData').doc(currentUid());
    ref.collection('Friends').doc(uid).delete();
    ref.collection('FavFriends').doc(uid).set(({
          'ImageUrl': imageUrl,
          'Uid': uid,
          'Name': name,
        }));
  }

  deleteUser(uid) {
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection('last_message')
        .doc(uid)
        .delete();
  }

  changeName(uid, name) {
    Map<String, dynamic> setName = {
      'Name': name,
    };
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection('last_message')
        .doc(uid)
        .update(setName);
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livu/Model/HistoryModel.dart';

class HistoryService {
  Stream<List<HistoryModel>> getIMissedHistory() {
    return FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection('IMissed')
        .snapshots()
        .map((QuerySnapshot query) {
      List<HistoryModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(HistoryModel.fromquerySnapshot(element));
      });
      return retVal;
    });
  }

  currentUid() {
    return FirebaseAuth.instance.currentUser.uid;
  }

  Stream<List<HistoryModel>> getTheyMissedHistory() {
    return FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection('TheyMissed')
        .snapshots()
        .map((QuerySnapshot query) {
      List<HistoryModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(HistoryModel.fromquerySnapshot(element));
      });
      return retVal;
    });
  }

  deleteVideoCallHistory(historyName, deleteUid) {
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection(historyName)
        .doc(deleteUid)
        .delete();
  }

  Stream<List<HistoryModel>> getVideoCallHistory() {
    return FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUid())
        .collection('VideoCallHistory')
        .snapshots()
        .map((QuerySnapshot query) {
      List<HistoryModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(HistoryModel.fromquerySnapshot(element));
      });
      return retVal;
    });
  }
}

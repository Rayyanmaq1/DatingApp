import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livu/Model/VideoModel.dart';

class VideoService {
  Stream<List<VideoModel>> getAllVideos() {
    return FirebaseFirestore.instance
        .collection('AllVideos')
        .snapshots()
        .map((QuerySnapshot query) {
      print(query.docs.length);
      List<VideoModel> retVal = List();
      query.docs.forEach((element) {
        retVal.add(VideoModel.fromQueryDocumentSnapshot(element));
      });

      return retVal;
    });
  }
}

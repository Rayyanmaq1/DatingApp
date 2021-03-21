import 'package:cloud_firestore/cloud_firestore.dart';

class VideoModel {
  String videoLink;
  String userName;
  String uid;
  String location;
  List<dynamic> interest;
  VideoModel(
      {this.interest, this.location, this.uid, this.userName, this.videoLink});

  factory VideoModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    return VideoModel(
      interest: snapshot.get('Interest'),
      uid: snapshot.get('Uid'),
      userName: snapshot.get('Name'),
      location: snapshot.get('Location'),
      videoLink: snapshot.get('VideoLink'),
    );
  }
  Map<String, dynamic> toMap(VideoModel model) {
    Map<String, dynamic> videoModel = Map();
    videoModel['Name'] = model.userName;
    videoModel['Interest'] = model.interest;
    videoModel['Uid'] = model.uid;
    videoModel['VideoLink'] = model.videoLink;
    videoModel['Location'] = model.location;
    return videoModel;
  }
}

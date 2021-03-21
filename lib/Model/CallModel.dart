import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  String name;
  String uid;
  String imageUrl;
  int likes;
  String age;
  String location;
  String channelId;
  CallModel(
      {this.name,
      this.channelId,
      this.imageUrl,
      this.likes,
      this.age,
      this.location,
      this.uid});

  factory CallModel.fromQueryDocumnentSnapshot(QueryDocumentSnapshot query) {
    return CallModel(
      name: query['Name'],
      uid: query['Uid'],
      imageUrl: query['ImageUrl'],
      likes: query['Likes'],
      location: query['Location'],
      channelId: query['ChannelId'],
      age: query['Age'].toString(),
    );
  }
}

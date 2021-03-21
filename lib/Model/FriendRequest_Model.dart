import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  String otherUserUid;
  String name;
  String imageUrl;
  String time;

  FriendRequest({this.otherUserUid, this.time, this.imageUrl, this.name});

  factory FriendRequest.fromDocumentSnapshot({QueryDocumentSnapshot data}) {
    // print(data[i]['Uid']);
    return FriendRequest(
      otherUserUid: data['Uid'],
      time: data['time'].toString(),
      name: data['Name'],
      imageUrl: data['ImageUrl'],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livu/Model/FriendRequest_Model.dart';
import 'package:livu/Model/HistoryModel.dart';

class LastMessage {
  String lastMessage;
  String time;
  String imageUrl;
  String name;
  String uid;

  LastMessage(
      {this.lastMessage, this.time, this.imageUrl, this.uid, this.name});
  factory LastMessage.fromDocumentSnapshot(QueryDocumentSnapshot data) {
    return LastMessage(
      lastMessage: data['last_message'],
      time: data['messageTime'],
      imageUrl: data['ImageUrl'],
      name: data['Name'],
      uid: data['Uid'],
    );
  }
  factory LastMessage.fromFriendModel(FriendRequest model) {
    return LastMessage(
      time: model.time,
      imageUrl: model.imageUrl,
      name: model.name,
      uid: model.otherUserUid,
    );
  }
  factory LastMessage.fromHistoryModel(HistoryModel model) {
    return LastMessage(
      time: model.date,
      imageUrl: model.imageUrl,
      name: model.name,
      uid: model.uid,
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livu/Model/FriendRequest_Model.dart';
import 'package:livu/Model/HistoryModel.dart';
import 'UserModel.dart';

class LastMessage {
  String docId;
  int timeStamp;
  LatestMessage lastestMessage;
  List<String> chattersUid;
  List<ChattingUserData> chatters;
  String lastMessage;
  String time;
  String imageUrl;
  String name;
  String uid;

  LastMessage({
    this.lastestMessage,
    this.docId,
    this.chattersUid,
    this.chatters,
    this.timeStamp,
    this.lastMessage,
    this.time,
    this.imageUrl,
    this.name,
    this.uid,
  });

  factory LastMessage.fromDocumentSnapshot(Map<String, dynamic> data, docID) {
    return LastMessage(
      lastMessage: data['last_message'],
      time: data['messageTime'],
      imageUrl: data['ImageUrl'],
      name: data['Name'],
      uid: data['Uid'],
      docId: docID,
      timeStamp: data['timeStamp'],
      chattersUid: List<String>.from(data['chattersUid']),
      chatters: List<ChattingUserData>.from(data['chatters']),
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
  factory LastMessage.userModel(UserModel userModel) {
    return LastMessage(
      imageUrl: userModel.imageUrl,
      name: userModel.name,
      uid: userModel.id,
    );
  }
  factory LastMessage.feomUserInfo(name, image, uid) {
    return LastMessage(
      imageUrl: image,
      name: name,
      uid: uid,
    );
  }
}

class ChattingUserData {
  String dp;
  String uid;
  String userName;
  bool isTyping;
  ChattingUserData({this.dp, this.uid, this.userName, this.isTyping});
  factory ChattingUserData.fromJson(Map<String, dynamic> data) {
    return ChattingUserData(
      dp: data['dp'],
      uid: data['uid'],
      userName: data['userName'],
      isTyping: data['isTyping'],
    );
  }
  Map<String, dynamic> toMap() => {
        'dp': this.dp,
        'uid': this.uid,
        'userName': this.userName,
        'isTyping': this.isTyping,
      };
}

class LatestMessage {
  String text;
  int timeStamp;
  String attachment;
  String senderUid;
  bool seen;
  Map<String, dynamic> typing;
  LatestMessage({
    this.text,
    this.attachment,
    this.timeStamp,
    this.seen,
    this.typing,
    this.senderUid,
  });

  factory LatestMessage.fromJson(Map<String, dynamic> data) {
    return LatestMessage(
      text: data['text'],
      timeStamp: data['timestamp'],
      attachment: data['attachment'],
      senderUid: data['sender'],
      seen: data['seen'],
      typing: data['typing'],
    );
  }

  Map<String, dynamic> toMap() => {
        'text': this.text,
        'attachment': this.attachment,
        'sender': this.senderUid,
        'seen': this.seen,
        'typing': {'istyping': false, 'typerUid': ''},
        'timestamp': this.timeStamp,
      };
}

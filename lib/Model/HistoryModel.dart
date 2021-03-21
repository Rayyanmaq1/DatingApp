import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryModel {
  String uid;
  String imageUrl;
  String location;
  int likes;
  String date;
  String name;
  HistoryModel(
      {this.date,
      this.uid,
      this.imageUrl,
      this.likes,
      this.location,
      this.name});
  factory HistoryModel.fromquerySnapshot(QueryDocumentSnapshot query) {
    return HistoryModel(
      uid: query['Uid'],
      date: query['Date'],
      likes: query['Likes'],
      location: query['Location'],
      name: query['Name'],
      imageUrl: query['ImageUrl'],
    );
  }
}

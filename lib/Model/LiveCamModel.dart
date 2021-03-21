import 'package:cloud_firestore/cloud_firestore.dart';

class LiveCamModel {
  String name;
  String uid;
  String imageUrl;
  String age;
  int likes;
  List interest;
  String location;
  LiveCamModel(
      {this.age,
      this.name,
      this.imageUrl,
      this.likes,
      this.interest,
      this.location,
      this.uid});
  factory LiveCamModel.fromDocumentSnapshot(QueryDocumentSnapshot data) {
    return LiveCamModel(
      name: data.get('Name'),
      imageUrl: data.get('ImageUrl'),
      age: data.get('Age'),
      uid: data.id,
      likes: data.get('Likes'),
      location: data.get('Location'),
      interest: data.get('Interest'),
    );
  }
}

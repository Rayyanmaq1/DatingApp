import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String id;
  String age;
  String imageUrl;
  String birthDay;
  String country;
  String bio;
  int coins;
  List interest;
  List languages;
  List imageList;
  String flag;
  String location;
  int likes;
  String videoLink;

  UserModel(
      {this.name,
      this.imageUrl,
      this.likes,
      this.age,
      this.coins,
      this.country,
      this.flag,
      this.id,
      this.birthDay,
      this.location,
      this.imageList,
      this.bio,
      this.languages,
      this.videoLink,
      this.interest});

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    return UserModel(
      id: snapshot.id,
      name: snapshot.get('Name'),
      imageUrl: snapshot.get('Image'),
      birthDay: snapshot.get('BirthDay'),
      imageList: snapshot.get('ImageList'),
      bio: snapshot.get('Bio'),
      languages: snapshot.get('Language'),
      interest: snapshot.get('Interest'),
      coins: snapshot.get('Coins'),
      age: snapshot.get('Age').toString(),
      likes: snapshot.get('Likes'),
      location: snapshot.get('Location'),
      videoLink: snapshot.get('VideoLink'),
    );
  }
}

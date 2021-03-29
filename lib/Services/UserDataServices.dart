import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:livu/Model/VideoModel.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UserDataServices {
  Stream<UserModel> getUserData() {
    return FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUserUid())
        .snapshots()
        .map((DocumentSnapshot query) {
      UserModel model;
      model = UserModel.fromDocumentSnapshot(query);

      return model;
    });
  }

  currentUserUid() {
    return FirebaseAuth.instance.currentUser.uid;
  }

  setUserData(birthday, gender, name) {
    String uid = currentUserUid();
    Map<String, dynamic> data = {
      'BirthDay': birthday,
      'Gender': gender,
      'Name': name,
      'Likes': 0,
      'Bio': '',
      'Age': int.parse(DateTime.now().toString().substring(0, 4)) -
          int.parse(birthday.substring(0, 4)),
      'Language': [],
      'Interest': [],
      'ImageList': [],
      'Location': '',
      'Image':
          'https://firebasestorage.googleapis.com/v0/b/kimapp-d73b4.appspot.com/o/userAvatar.png?alt=media&token=5e874cf1-866c-41b4-924b-b75f690c24c8',
      'PhoneNumber': "",
      'Email': "",
      'Coins': 100,
      'VideoLink': '',
    };
    FirebaseFirestore.instance.collection('UserData').doc(uid).set(data);
  }

  deleteVideo() {
    Map<String, dynamic> link = {'VideoLink': ''};
    FirebaseFirestore.instance
        .collection('AllVideos')
        .doc(currentUserUid())
        .delete();
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(currentUserUid())
        .update(link);
  }

  uploadpetImage(image, imageName) async {
    var downloadUrl;
    var snapshot =
        await FirebaseStorage.instance.ref().child(imageName).putFile(image);

    await snapshot.ref.getDownloadURL().then((value) {
      downloadUrl = value;
    });

    return downloadUrl;
  }

  setImageList(imageList) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "ImageList": imageList,
    });
  }

  setVideo(videoLink) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    final userData = Get.find<UserDataController>().userModel.value;
    VideoModel model = new VideoModel(
        location: userData.location,
        interest: userData.interest,
        uid: userData.id,
        videoLink: videoLink,
        userName: userData.name);

    Map<String, dynamic> videoData = VideoModel().toMap(model);

    await FirebaseFirestore.instance
        .collection('AllVideos')
        .doc(currentUserUid())
        .set(videoData);
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "VideoLink": videoLink,
    });
  }

  setUserName(username) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "Name": username,
    });
  }

  setLanguages(languages) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "Language": languages,
    });
  }

  setinterest(interest) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "Interest": interest,
    });
  }

  setImage() async {
    var gallery = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxWidth: 200, maxHeight: 300);
    print(gallery.path);
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('chat_images/${DateTime.now().toString()}myimage.jpg')
        .putFile(File(gallery.path));

    await snapshot.ref.getDownloadURL().then((value) {
      FirebaseFirestore.instance
          .collection('UserData')
          .doc(currentUserUid())
          .update(({'Image': value}));
      ;
    });
  }

  setBirthday(birthday) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "BirthDay": birthday,
    });
  }

  setBio(bio) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "Bio": bio,
    });
  }

  setAge(age) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "Age": age,
    });
  }

  setLocataion(location) async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    await FirebaseFirestore.instance.collection('UserData').doc(uid).update({
      "Location": location,
    });
  }
}

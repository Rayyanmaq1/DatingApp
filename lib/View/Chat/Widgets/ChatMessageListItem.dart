import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Model/MessageModel.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/theme.dart';

var currentUserEmail;

// ignore: must_be_immutable
class ChatMessageListItem extends StatelessWidget {
  final DocumentSnapshot messageSnapshot;
  final Animation animation;
  // final userdataCtr = Get.put(UserDataController());
  // final CurrentUser currentUser;
  final receiverEmail;
  ChatMessageListItem(
      {this.messageSnapshot, this.animation, this.receiverEmail});
  // GoogleTranslator translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    print(messageSnapshot.get('Uid'));
    return new Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: new Row(
        children: Get.find<UserDataController>().userModel.value.id ==
                messageSnapshot.get('Uid')
            ? getSentMessageLayout()
            : getReceivedMessageLayout(),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(messageSnapshot.get('Name'),
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: new Text(
                messageSnapshot.get(LATEST_MESSAGE),
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(left: 8.0),
              child: new CircleAvatar(
                backgroundImage:
                    new NetworkImage(messageSnapshot.get('ImageUrl')),
              )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: new CircleAvatar(
                backgroundImage:
                    new NetworkImage(messageSnapshot.get('ImageUrl')),
              )),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(messageSnapshot.get('Name'),
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold)),
            new Container(
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(
                  messageSnapshot.get('last_message'),
                  style: TextStyle(color: Colors.grey),
                )),
          ],
        ),
      ),
    ];
  }
}

// ignore: must_be_immutable
class FullImageViewScreen extends StatelessWidget {
  String url;
  FullImageViewScreen({this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          color: AppColors.greyColor,
          child: Center(
              child: CachedNetworkImage(
            imageUrl: url,
            imageBuilder: (context, imageProvider) => Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          )),
        ));
  }
}

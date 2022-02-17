import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/theme.dart';
import '../../../Model/MessageModel.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:translator/translator.dart';
import 'package:easy_localization/easy_localization.dart';

var currentUserEmail;

// ignore: must_be_immutable
class ChatMessageListItem extends StatelessWidget {
  final DataSnapshot messageSnapshot;
  final Animation animation;
  // final userdataCtr = Get.put(UserDataController());
  // final CurrentUser currentUser;
  final receiverEmail;
  ChatMessageListItem(
      {this.messageSnapshot, this.animation, this.receiverEmail});
  GoogleTranslator translator = GoogleTranslator();

  @override
  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor:
          new CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          children: Get.find<UserDataController>().userModel.value.id ==
                  (messageSnapshot.value as Map)[SENDER_UID]
              ? getSentMessageLayout()
              : getReceivedMessageLayout(),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout() {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text((messageSnapshot.value as Map)[SENDER_NAME],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 12.0),
              child: (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL] != null
                  ? GestureDetector(
                      onTap: () {
                        print(
                            (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL]);

                        Get.to(() => FullImageViewScreen(
                            url: (messageSnapshot.value
                                as Map)[MESSAGE_IMAGE_URL]));
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                            (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL],
                        imageBuilder: (context, imageProvider) => Container(
                          height: SizeConfig.heightMultiplier * 14,
                          width: SizeConfig.widthMultiplier * 48,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.contain),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      //       new Image.network(
                      //   (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL],
                      //   width: 250.0,
                      // ),
                    )
                  // new Image.network(
                  //   (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL],
                  //   width: 250.0,
                  // )
                  : new Text(
                      (messageSnapshot.value as Map)[MESSAGE_TEXT],
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
                backgroundImage: new NetworkImage(
                    (messageSnapshot.value as Map)[SENDER_IMAGE_URL]),
              )),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout() {
    print("recieved layout called");

    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
              margin: const EdgeInsets.only(right: 8.0),
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(
                    (messageSnapshot.value as Map)[SENDER_IMAGE_URL]),
              )),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text((messageSnapshot.value as Map)[SENDER_NAME],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[300],
                    fontWeight: FontWeight.bold)),
            new Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL] != null
                  ? GestureDetector(
                      onTap: () {
                        Get.to(() => FullImageViewScreen(
                            url: (messageSnapshot.value
                                as Map)[MESSAGE_IMAGE_URL]));
                      },
                      child: CachedNetworkImage(
                        imageUrl:
                            (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL],
                        imageBuilder: (context, imageProvider) => Container(
                          height: SizeConfig.heightMultiplier * 14,
                          width: SizeConfig.widthMultiplier * 48,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.contain),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      //       new Image.network(
                      //   (messageSnapshot.value as Map)[MESSAGE_IMAGE_URL],
                      //   width: 250.0,
                      // ),
                    )
                  : 'app_name'.tr() == 'KIM LIVE'
                      ? FutureBuilder(
                          future: translator.translate(
                              (messageSnapshot.value as Map)[MESSAGE_TEXT],
                              from: 'ar',
                              to: 'en'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyle(color: Colors.grey),
                            );
                          },
                        )
                      : FutureBuilder(
                          future: translator.translate(
                              (messageSnapshot.value as Map)[MESSAGE_TEXT],
                              from: 'en',
                              to: 'ar'),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }
                            return Text(
                              snapshot.data.toString(),
                              style: TextStyle(color: Colors.grey),
                            );
                          },
                        ),
            ),
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
          color: greyColor,
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

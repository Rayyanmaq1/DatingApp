import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Model/MessageModel.dart';
import 'package:livu/theme.dart';

class ChatMessageListItem extends StatelessWidget {
  final Map<String, dynamic> messageSnapshot;
  final Animation animation;
  final int index;
  final bool self,
      nextIsSelf,
      prevIsSelf,
      isLastMessage,
      senderNext,
      senderPrevSelf;

  // final userdataCtr = Get.put(UserDataController());
  // final CurrentUser currentUser;
  final receiverEmail;
  ChatMessageListItem(
      {this.messageSnapshot,
      this.animation,
      this.receiverEmail,
      this.self,
      this.nextIsSelf,
      this.prevIsSelf,
      this.isLastMessage,
      this.index,
      this.senderNext,
      this.senderPrevSelf});

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animation, curve: Curves.decelerate),
      child: Container(
        margin: EdgeInsets.only(
          top: self
              ? prevIsSelf
                  ? 2
                  : 6
              : !prevIsSelf
                  ? 2
                  : 6,
          bottom: self
              ? nextIsSelf
                  ? 2
                  : 6
              : !nextIsSelf
                  ? 2
                  : 6,
        ),
        child: Row(
          children: Get.find<UserDataController>().userModel.value.id ==
                  messageSnapshot['value'][SENDER_UID]
              ? getSentMessageLayout(context)
              : getReceivedMessageLayout(context),
        ),
      ),
    );
  }

  List<Widget> getSentMessageLayout(context) {
    double _topPadding = MediaQuery.of(context).padding.top;
    double _height = MediaQuery.of(context).size.height - _topPadding;
    double _width = MediaQuery.of(context).size.width;
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 0.0, right: 8),
              child: messageSnapshot['value'][MESSAGE_IMAGE_URL] != null
                  ? GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => GestureDetector(
                            onTap: () => Navigator.pop(context),
                            onVerticalDragUpdate: (value) =>
                                Navigator.pop(context),
                            onDoubleTap: () => Navigator.pop(context),
                            child: CupertinoPageScaffold(
                              child: SafeArea(
                                child: Container(
                                  height: _height,
                                  width: _width,
                                  child: CachedNetworkImage(
                                      imageUrl: messageSnapshot['value']
                                          [MESSAGE_IMAGE_URL]),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: messageSnapshot['value'][MESSAGE_IMAGE_URL],
                          width: 160,
                        ),
                      ),
                    )
                  : Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            14,
                          ),
                          topRight: Radius.circular(
                            nextIsSelf && self && prevIsSelf
                                ? nextIsSelf
                                    ? 0
                                    : 14
                                : !nextIsSelf
                                    ? prevIsSelf
                                        ? 0
                                        : 14
                                    : 14,
                          ),
                          bottomLeft: Radius.circular(
                            14,
                          ),
                          bottomRight: Radius.circular(
                            nextIsSelf
                                ? 0
                                : prevIsSelf
                                    ? 14
                                    : 0,
                          ),
                        ),
                        color: greyColor,
                      ),
                      child: Container(
                        // alignment: Alignment.centerLeft,
                        child: Text(
                          messageSnapshot['value'][MESSAGE_TEXT],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          (!(self && nextIsSelf) || isLastMessage)
              ? new Container(
                  height: 29,
                  width: 29,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: messageSnapshot['value'][SENDER_IMAGE_URL] == null ||
                            messageSnapshot['value'][SENDER_IMAGE_URL] == ''
                        ? Container(
                            color: Color(0xFFD8D8D8),
                            child: Center(
                              child: Text(
                                messageSnapshot['value'][SENDER_NAME][0]
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: messageSnapshot['value']
                                [SENDER_IMAGE_URL],
                            fit: BoxFit.cover,
                          ),
                  ),
                )
              : Container(
                  height: 29, width: 29, margin: EdgeInsets.only(right: 10)),
        ],
      ),
    ];
  }

  List<Widget> getReceivedMessageLayout(context) {
    double _topPadding = MediaQuery.of(context).padding.top;
    double _height = MediaQuery.of(context).size.height - _topPadding;
    double _width = MediaQuery.of(context).size.width;
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ((self || nextIsSelf) || isLastMessage)
              ? new Container(
                  height: 29,
                  width: 29,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: messageSnapshot['value'][SENDER_IMAGE_URL] == null ||
                            messageSnapshot['value'][SENDER_IMAGE_URL] == ''
                        ? Container(
                            color: Color(0xFFD8D8D8),
                            child: Center(
                              child: Text(
                                messageSnapshot['value'][SENDER_NAME][0]
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: messageSnapshot['value']
                                [SENDER_IMAGE_URL],
                            fit: BoxFit.cover,
                          ),
                  ),
                )
              : Container(
                  height: 29, width: 29, margin: EdgeInsets.only(right: 10)),
        ],
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: messageSnapshot['value'][MESSAGE_IMAGE_URL] != null
                  ? GestureDetector(
                      onTap: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => GestureDetector(
                            onTap: () => Navigator.pop(context),
                            onVerticalDragUpdate: (value) =>
                                Navigator.pop(context),
                            onDoubleTap: () => Navigator.pop(context),
                            child: CupertinoPageScaffold(
                              child: SafeArea(
                                child: Container(
                                  height: _height,
                                  width: _width,
                                  child: CachedNetworkImage(
                                      imageUrl: messageSnapshot['value']
                                          [MESSAGE_IMAGE_URL]),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: messageSnapshot['value'][MESSAGE_IMAGE_URL],
                          width: 160,
                        ),
                      ))
                  : Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                            senderPrevSelf ? 0 : 14,
                          ),
                          topRight: Radius.circular(
                            !self
                                ? 14
                                : prevIsSelf
                                    ? 0
                                    : 14,
                          ),
                          bottomLeft: Radius.circular(
                            senderPrevSelf && senderNext
                                ? 0
                                : senderPrevSelf
                                    ? 14
                                    : 0,
                          ),
                          bottomRight: Radius.circular(
                            !self
                                ? 14
                                : !nextIsSelf && !prevIsSelf
                                    ? 0
                                    : nextIsSelf
                                        ? 0
                                        : 14,
                          ),
                        ),
                        color:
                            // self
                            //     ? Color(kSelfMessageColor)
                            // :
                            greyColor,
                      ),
                      child: Container(
                        // alignment: Alignment.centerLeft,
                        child: Text(
                          messageSnapshot['value'][MESSAGE_TEXT],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
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
          color: Colors.white,
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

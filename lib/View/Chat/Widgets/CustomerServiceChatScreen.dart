import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:livu/Model/last_MessageModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Trans;
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/theme.dart';
import 'package:livu/Model/MessageModel.dart';
import 'ChatMessageListItem.dart';

var currentUserEmail;

var _scaffoldContext;

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  LastMessage lastMessage;
  bool friendRequest;
  ChatScreen({this.lastMessage, this.friendRequest});

  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool switchButton = false;
  bool favourite;
  final TextEditingController controller = TextEditingController();
  File image;
  final reference = FirebaseDatabase.instance.reference().child('messages');
  // String userId = Get.find<UserDataController>().userModel.;
  String name = "Admin";
  FocusNode focusNode = FocusNode();
  bool showGifts = false;
  AnimationController _controller;
  Animation _animation;
  bool showEmoji = false;
  final pageController = PageController(viewportFraction: 0.8);
  QuerySnapshot msgData;
  @override
  // void initState() {
  //   super.initState();

  //       .then((value) {
  //     setState(() {
  //       msgData = value;
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: greyColor,
      appBar: new AppBar(
        backgroundColor: greyColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Customer Service',
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('UserData')
                    .doc(Get.find<UserDataController>().userModel.value.id)
                    .collection('CustomerService')
                    .orderBy('messageTime', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (ConnectionState.waiting == snapshot.connectionState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      // ignore: missing_return
                      itemBuilder: (context, index) {
                        return ChatMessageListItem(
                          messageSnapshot: snapshot.data.docs[index],
                        );
                      });
                }),
          ),
          new Divider(height: 1.0),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildMessageComposer(context),
          ),
          new Builder(builder: (BuildContext context) {
            _scaffoldContext = context;
            return new Container(width: 0.0, height: 0.0);
          })
        ],
      ),
    );
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: () => _textMessageSubmitted(_textEditingController.text),
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(
        Icons.send,
        color: purpleColor,
      ),
      onPressed: () {
        setState(() {
          focusNode.unfocus();
          focusNode.canRequestFocus = false;
        });
        _textMessageSubmitted(_textEditingController.text);
      },
    );
  }

  _buildMessageComposer(context) {
    return Container(
      color: greyColor,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: Platform.isIOS ? 20.0 : 0.0),
            child: new Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: new Row(
                children: <Widget>[
                  new Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: new TextField(
                          focusNode: focusNode,
                          controller: _textEditingController,
                          onChanged: (String messageText) {},
                          style: TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: _textMessageSubmitted,
                          decoration: new InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "Send a message")),
                    ),
                  ),
                  new Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Theme.of(context).platform == TargetPlatform.iOS
                        ? getIOSSendButton()
                        : getDefaultSendButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    _sendMessage(messageText: text, imageUrl: null);
  }

  void _sendMessage({String messageText, String imageUrl}) {
    _sendLatestMessage(messageText);
  }

  void _sendLatestMessage(String latestMessage) {
    CollectionReference _currentUserColl = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(Get.find<UserDataController>().userModel.value.id)
        .collection('CustomerService');
    CollectionReference _customerServiceColl =
        FirebaseFirestore.instance.collection('CustomerService');

    _customerServiceColl
        .doc(Get.find<UserDataController>().userModel.value.id)
        .set({
      LATEST_MESSAGE: latestMessage,
      MESSAGE_TIME: DateTime.now().toString(),
      'Uid': Get.find<UserDataController>().userModel.value.id,
      'ImageUrl': Get.find<UserDataController>().userModel.value.imageUrl,
      'Name': Get.find<UserDataController>().userModel.value.name,
    }).catchError((e) {});
    _currentUserColl.doc().set({
      LATEST_MESSAGE: latestMessage,
      'Uid': FirebaseAuth.instance.currentUser.uid,
      'ImageUrl': Get.find<UserDataController>().userModel.value.imageUrl,
      'Name': Get.find<UserDataController>().userModel.value.name,
      MESSAGE_TIME: DateTime.now().toString()
    });
  }
}

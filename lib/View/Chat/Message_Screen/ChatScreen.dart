import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Controller/FriendRequestController.dart';
import 'package:livu/Controller/lastMessageController.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:livu/Model/MessageModel.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:livu/Services/CoinsDeduction.dart';
import 'package:livu/Services/FriendRequestService.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/View/Chat/Message_Screen/GiftsList.dart';
import 'package:livu/View/Chat/Widgets/typingAnimation.dart';
import 'package:livu/theme.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_database/firebase_database.dart';

import 'ChatMessageListItem.dart';
import 'VideoCall/Dial.dart';

class ChatPage extends StatefulWidget {
  final String dp, userName, chatID, selfUid, partnerUid;
  final dynamic userData;
  final LastMessage lastMessage;
  bool friendRequest;

  ChatPage({
    this.chatID,
    this.dp,
    this.userName,
    this.userData,
    this.partnerUid,
    this.selfUid,
    this.lastMessage,
  });
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool _uploading = false;
  XFile _image;
  // ignore: unused_field
  String _selectedImageName;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _editingController;
  ScrollController _listController;
  final _imagePicker = ImagePicker();

  Future _getCameraImage() async {
    _imagePicker
        // ignore: deprecated_member_use
        .getImage(
          source: ImageSource.camera,
          imageQuality: 80,
          maxHeight: 1620,
          maxWidth: 1080,
        )
        .then(
          (value) => setState(() {
            if (value != null) {
              _image = XFile(value.path);
              _selectedImageName = 'captured-image.jpg';
            } else
              _selectedImageName = '';
          }),
        );
  }

  Future _getGalleryImage() async {
    _imagePicker
        // ignore: deprecated_member_use
        .getImage(
          source: ImageSource.gallery,
          imageQuality: 80,
          maxHeight: 1620,
          maxWidth: 1080,
        )
        .then((value) => setState(() {
              if (value != null) {
                _image = XFile(value.path);
                _selectedImageName = path.basename(_image.path);
              } else
                _selectedImageName = '';
            }));
  }

  void _sendMessage({String messageText, String imageUrl}) {
    reference.push().set({
      MESSAGE_TEXT: messageText,
      SENDER_UID: userId,
      RECEIVER_UID: widget.lastMessage.uid,
      MESSAGE_IMAGE_URL: imageUrl,
      SENDER_NAME: Get.find<UserDataController>().userModel.value.name,
      SENDER_IMAGE_URL: Get.find<UserDataController>().userModel.value.imageUrl,
    }).catchError((e) {
      print(e);
    });

    _sendLatestMessage(messageText);
  }

  void _sendLatestMessage(String latestMessage) {
    print(USERS_COLLECTION + ' here  ' + LATEST_MESSAGES);
    CollectionReference _receiverColl = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(widget.lastMessage.uid)
        .collection('last_message');
    CollectionReference _userColl = FirebaseFirestore.instance
        .collection(USERS_COLLECTION)
        .doc(Get.find<UserDataController>().userModel.value.id)
        .collection('last_message');
    _userColl.doc(widget.lastMessage.uid).set({
      LATEST_MESSAGE: latestMessage,
      // LATEST_REFERENCE: _recRef,
      MESSAGE_TIME: DateTime.now().toString(),
      'Uid': widget.lastMessage.uid,
      'ImageUrl': widget.lastMessage.imageUrl,
      'Name': widget.lastMessage.name,
    }).catchError((e) {
      // print(e);
    });
    print('asdasd');
    // print(_userRef);
    _receiverColl.doc(Get.find<UserDataController>().userModel.value.id).set({
      LATEST_MESSAGE: latestMessage,
      'Uid': Get.find<UserDataController>().userModel.value.id,
      'ImageUrl': Get.find<UserDataController>().userModel.value.imageUrl,
      'Name': Get.find<UserDataController>().userModel.value.name,
      // ignore: equal_keys_in_map
      // LATEST_REFERENCE: _userRef,
      // ignore: equal_keys_in_map
      MESSAGE_TIME: DateTime.now().toString()
    });
  }

  // void _markSeen(List messages) {
  //   bool changed = false;
  //   for (int i = 0; i < messages.length; i++) {
  //     if (messages[i]['sender'] != widget.selfUid) {
  //       if (!messages[i]['seen']) {
  //         changed = true;
  //         messages[i]['seen'] = true;
  //       }
  //     }
  //   }
  //   if (changed) {
  //     FirebaseFirestore.instance.collection('chats').doc(widget.chatID).update({
  //       'messages': messages,
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
    _listController = ScrollController();
    _editingController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _listController.dispose();
    _editingController.dispose();
    Get.find<LastMessageController>()
        .typingFalse(widget.chatID, widget.lastMessage);
    super.dispose();
  }

  int length = 0;
  final TextEditingController _textEditingController =
      new TextEditingController();
  bool _isComposingMessage = false;
  bool switchButton = false;
  bool favourite;
  final TextEditingController controller = TextEditingController();
  XFile image;
  final reference = FirebaseDatabase.instance.reference().child('messages');
  String userId = Get.find<UserDataController>().userModel.value.id;
  final friendRequest = Get.put(FriendRequestController());
  String name;
  FocusNode focusNode = FocusNode();
  bool showGifts = false;
  AnimationController _controller;
  Animation _animation;
  bool showEmoji = false;
  final pageController = PageController(viewportFraction: 0.8);
  List<Gifts> getGifts = getGiftsList();
  List<Gifts> getData = getlist();

  Icon _emojiIcon = Icon(
    FontAwesomeIcons.smileWink,
    color: Colors.grey,
    size: 20,
  );
  @override
  Widget build(BuildContext context) {
    Animation<double> animation = kAlwaysCompleteAnimation;
    double _topPadding = MediaQuery.of(context).padding.top;
    double _width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Column(
          children: [
            SizedBox(height: _topPadding),
            _appBar(),
            Expanded(
              child: Container(
                color: greyColor,
                child: StreamBuilder(
                    stream: reference.onValue,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> messaages = [];
                        final json =
                            snapshot.data.value as Map<dynamic, dynamic>;

                        json.forEach((key, value) {
                          if ((value[SENDER_UID] ==
                                      Get.find<UserDataController>()
                                          .userModel
                                          .value
                                          .id ||
                                  value[RECEIVER_UID] ==
                                      Get.find<UserDataController>()
                                          .userModel
                                          .value
                                          .id) &&
                              (value[SENDER_UID] == widget.partnerUid ||
                                  value[RECEIVER_UID] == widget.partnerUid)) {
                            messaages.add({'value': value, 'key': key});
                          }
                        });
                        messaages.sort((a, b) => b['value']['timeStamp']
                            .compareTo(a['value']['timeStamp']));

                        return Column(
                          children: [
                            if (messaages.length == 0)
                              Container(
                                margin: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: _width * 0.045,
                                ),
                                child: encryptionMessage(),
                              ),
                            Expanded(
                              child: Stack(
                                children: [
                                  ListView.builder(
                                      controller: _listController,
                                      itemCount: messaages.length,
                                      keyboardDismissBehavior:
                                          ScrollViewKeyboardDismissBehavior
                                              .onDrag,
                                      reverse: true,
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(
                                          top: 8,
                                          left: Get.width * 0.045,
                                          right: Get.width * 0.045,
                                          bottom: 50),
                                      itemBuilder: (context, index) {
                                        return Column(
                                          children: [
                                            if (index == messaages.length - 1)
                                              encryptionMessage(),
                                            ChatMessageListItem(
                                              index: index,
                                              messageSnapshot: messaages[index],
                                              animation: animation,
                                              senderNext: (index == 0)
                                                  ? false
                                                  : messaages[index - 1]
                                                              ['value']
                                                          [RECEIVER_UID] ==
                                                      widget.selfUid,
                                              senderPrevSelf:
                                                  index == messaages.length - 1
                                                      ? false
                                                      : messaages[index + 1]
                                                                  ['value']
                                                              [RECEIVER_UID] ==
                                                          widget.selfUid,
                                              self: messaages[index]['value']
                                                      [SENDER_UID] ==
                                                  widget.selfUid,
                                              prevIsSelf:
                                                  index == messaages.length - 1
                                                      ? false
                                                      : messaages[index + 1]
                                                                  ['value']
                                                              [SENDER_UID] ==
                                                          widget.selfUid,
                                              nextIsSelf: (index == 0)
                                                  ? false
                                                  : messaages[index - 1]
                                                              ['value']
                                                          [SENDER_UID] ==
                                                      widget.selfUid,
                                              isLastMessage: index == 0,
                                            ),
                                          ],
                                        );
                                      }),
                                  widget.friendRequest
                                      ? Positioned(
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              children: [
                                                Text(
                                                    widget.lastMessage.name +
                                                        " " +
                                                        'sent you friend request'
                                                            .tr +
                                                        "Do you want to agree"
                                                            .tr,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: purpleColor)),
                                                SizedBox(
                                                  height: SizeConfig
                                                          .heightMultiplier *
                                                      5,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // friendRequest.friendRequestCtr
                                                        //     .remove(widget.index);
                                                        // friendRequest.otherUserDataCtr
                                                        //     .remove(widget.index);
                                                        FriendRequestService()
                                                            .acceptUser(
                                                                widget
                                                                    .lastMessage
                                                                    .uid,
                                                                widget
                                                                    .lastMessage
                                                                    .name,
                                                                widget
                                                                    .lastMessage
                                                                    .imageUrl);
                                                        Get.back();
                                                      },
                                                      child: Container(
                                                        height: SizeConfig
                                                                .heightMultiplier *
                                                            5,
                                                        width: SizeConfig
                                                                .widthMultiplier *
                                                            20,
                                                        child: Center(
                                                          child: Text('Agree'),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: purpleColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        // print('tapped');
                                                        // friendRequest.friendRequestModel
                                                        //     .remove(widget.index);
                                                        // friendRequest.otherUserData
                                                        //     .remove(widget.index);
                                                        FriendRequestService()
                                                            .deleteFriendRequest(
                                                                widget
                                                                    .lastMessage
                                                                    .uid);
                                                      },
                                                      child: Container(
                                                        height: SizeConfig
                                                                .heightMultiplier *
                                                            5,
                                                        width: SizeConfig
                                                                .widthMultiplier *
                                                            20,
                                                        child: Center(
                                                          child: Text(
                                                            'Ignore',
                                                            style: TextStyle(
                                                                color:
                                                                    purpleColor),
                                                          ),
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  purpleColor),
                                                          color: greyColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(20),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height:
                                                SizeConfig.heightMultiplier *
                                                    20,
                                          ),
                                        )
                                      : Container(),
                                  if (_image != null)
                                    Positioned(
                                      left: 10,
                                      bottom: 20,
                                      child: Column(
                                        children: [
                                          Stack(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                child: Image.file(
                                                  File(_image.path),
                                                  width: _width * 0.25,
                                                ),
                                              ),
                                              Positioned(
                                                top: 5,
                                                right: 5,
                                                child: CupertinoButton(
                                                  padding: EdgeInsets.zero,
                                                  minSize: 0,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color: Colors.white70,
                                                        width: 1.5,
                                                      ),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              1.0),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: Colors.white70,
                                                        size: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  onPressed: () => setState(() {
                                                    _image = null;
                                                  }),
                                                ),
                                              ),
                                            ],
                                          ),
                                          if (_uploading) ...[
                                            SizedBox(height: 4),
                                            Container(
                                              width: _width * 0.25,
                                              child: LinearProgressIndicator(
                                                backgroundColor:
                                                    greyColor.withOpacity(0.3),
                                                valueColor:
                                                    new AlwaysStoppedAnimation<
                                                        Color>(greyColor),
                                                minHeight: 3,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                  Positioned(
                                    bottom: 10,
                                    left: 10,
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance
                                          .collection('lastMessage')
                                          .doc(widget.chatID)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<dynamic> snapshot) {
                                        if (snapshot.hasData) {
                                          for (int i = 0;
                                              i <
                                                  snapshot.data
                                                      .data()["chatters"]
                                                      .length;
                                              i++) {
                                            if (snapshot.data.data()["chatters"]
                                                    [i]["uid"] !=
                                                Get.find<UserDataController>()
                                                    .userModel
                                                    .value
                                                    .id) {
                                              if (snapshot.data
                                                      .data()["chatters"][i]
                                                  ['isTyping']) {
                                                return SizedBox(
                                                    height: 80,
                                                    width: 120,
                                                    child: TypingAnimation());
                                              }
                                            }
                                          }

                                          return SizedBox();
                                        }
                                        return SizedBox();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: SizedBox(),
                        );
                      }
                    }),
              ),
            ),
            Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildMessageComposer(context),
            ),
          ],
        ),
      ),
    );
  }

  Container encryptionMessage() => Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        margin: EdgeInsets.only(top: 6, bottom: 8, left: 30, right: 30),
        child: Text(
          '🔒 All direct messages between users are 100% safe and secured.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      );

  _buildMessageComposer(context) {
    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: greyColor,
        height: showEmoji || showGifts
            ? SizeConfig.heightMultiplier * 45
            : SizeConfig.heightMultiplier * 15,
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
                          onChanged: (String messageText) {
                            setState(() {
                              _isComposingMessage = messageText.length > 0;
                            });
                          },
                          style: TextStyle(color: Colors.white),
                          textCapitalization: TextCapitalization.sentences,
                          onSubmitted: _textMessageSubmitted,
                          decoration: new InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.grey),
                              hintText: "Send a message".tr),
                        ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (showEmoji == true) {
                        showEmoji = false;
                      }
                      showGifts = !showGifts;
                    });
                  },
                  child: FaIcon(
                    FontAwesomeIcons.gift,
                    color: purpleColor,
                    size: 26,
                  ),
                ),
                GestureDetector(
                    onTap: () async {
                      var gallery = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 200,
                          maxHeight: 300);
                      print(gallery.path);
                      var snapshot = await FirebaseStorage.instance
                          .ref()
                          .child(
                              'chat_images/${DateTime.now().toString()}myimage.jpg')
                          .putFile(File(gallery.path));

                      await snapshot.ref.getDownloadURL().then((value) {
                        _sendMessage(
                            messageText: 'Image'.tr,
                            imageUrl: value.toString());
                      });
                    },
                    child: Icon(
                      Icons.photo_camera,
                      color: purpleColor,
                    )),
                GestureDetector(
                  onTap: () {
                    if (showGifts == true) {
                      setState(() {
                        showGifts = false;
                      });
                    }
                    focusNode.unfocus();
                    focusNode.canRequestFocus = false;
                    setState(() {
                      showEmoji = !showEmoji;
                      _emojiIcon = Icon(FontAwesomeIcons.keyboard);
                    });
                  },
                  child: Icon(
                    Icons.emoji_emotions,
                    color: Colors.grey[600],
                    size: 26,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (Get.find<UserDataController>().userModel.value.coins >=
                        40) {
                      _call(false);
                    } else {
                      Get.to(() => BuyCoins());
                      Get.snackbar(
                          'NoEnoughCoin'.tr, 'NoEnoughCoinSubTitle'.tr);
                    }
                  },
                  child: Icon(
                    Icons.call,
                    color: orangeColor,
                    size: 26,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (Get.find<UserDataController>().userModel.value.coins >=
                        80) {
                      _call(true);
                    } else {
                      Get.to(() => BuyCoins());
                      Get.snackbar(
                          'NoEnoughCoin'.tr, 'NoEnoughCoinSubTitle'.tr);
                    }
                  },
                  child: Icon(
                    Icons.videocam,
                    color: purpleColor,
                    size: 26,
                  ),
                )
              ],
            ),
            showGiftPicker(),
            showEmojiPicker(),
          ],
        ));
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    // await _ensureLoggedIn();
    _sendMessage(messageText: text, imageUrl: null);
  }

  CupertinoButton getIOSSendButton() {
    return new CupertinoButton(
      child: new Text("Send"),
      onPressed: _isComposingMessage
          ? () => _textMessageSubmitted(_textEditingController.text)
          : null,
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(
        Icons.send,
        color: purpleColor,
      ),
      onPressed: _isComposingMessage
          ? () {
              setState(() {
                showEmoji = false;
                focusNode.unfocus();
                focusNode.canRequestFocus = false;
              });
              _textMessageSubmitted(_textEditingController.text);
            }
          : null,
    );
  }

  _call(bool videoCall) {
    UserCallModel from = UserCallModel(
        name: Get.find<UserDataController>().userModel.value.name,
        imageUrl: Get.find<UserDataController>().userModel.value.imageUrl,
        uid: Get.find<UserDataController>().userModel.value.id);
    UserCallModel to = UserCallModel(
        name: widget.lastMessage.name,
        imageUrl: widget.lastMessage.imageUrl,
        uid: widget.lastMessage.uid);
    CallUtils.dial(from: from, to: to, context: context, videoCall: videoCall);
  }

  Widget showGiftPicker() {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: showGifts ? SizeConfig.heightMultiplier * 35 : 0,
      width: MediaQuery.of(context).size.width,
      child: PageView(
        // controller: pageController,
        children: [
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1 / 1.45,
            ),
            itemCount: getGifts.length,
            itemBuilder: (context, index) {
              // print(getData[index].imageUrl);
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    showGifts = false;
                  });

                  if (Get.find<UserDataController>().userModel.value.coins >=
                      getGifts[index].coins) {
                    CoinsDeduction().setCoins(
                        Get.find<UserDataController>().userModel.value.coins,
                        getGifts[index].coins);
                    _sendMessage(
                        messageText: 'Gift'.tr,
                        imageUrl: getGifts[index].imageUrl);
                  } else {
                    Get.snackbar('NoEnoughCoin'.tr, 'NoEnoughCoinSubTitle'.tr);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      imageUrl: getGifts[index].imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: SizeConfig.widthMultiplier * 18,
                        height: SizeConfig.heightMultiplier * 12,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: imageProvider),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/Coin.png',
                          width: 20,
                          height: 20,
                        ),
                        Text(
                          getGifts[index].coins.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 1 / 1.5,
            ),
            itemCount: getData.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    showGifts = false;
                  });
                  if (Get.find<UserDataController>().userModel.value.coins >=
                      getData[index].coins) {
                    CoinsDeduction().setCoins(
                        Get.find<UserDataController>().userModel.value.coins,
                        getData[index].coins);
                    _sendMessage(
                        messageText: 'Gift'.tr,
                        imageUrl: getData[index].imageUrl);
                  } else {
                    Get.snackbar('NoEnoughCoin'.tr, 'NoEnoughCoinSubTitle'.tr);
                  }
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CachedNetworkImage(
                      imageUrl: getData[index].imageUrl,
                      imageBuilder: (context, imageProvider) => Container(
                        width: SizeConfig.widthMultiplier * 18,
                        height: SizeConfig.heightMultiplier * 12,
                        decoration: BoxDecoration(
                          image: DecorationImage(image: imageProvider),
                        ),
                      ),
                      placeholder: (context, url) =>
                          CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image.asset(
                          'assets/Coin.png',
                          width: 20,
                          height: 20,
                        ),
                        Text(
                          getData[index].coins.toString(),
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget showEmojiPicker() {
    return Container(
      height: showEmoji ? SizeConfig.heightMultiplier * 35 : 0,
      // duration: Duration(seconds: 1),
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          // Do something when emoji is tapped
        },
        onBackspacePressed: () {
          // Backspace-Button tapped logic
          // Remove this line to also remove the button in the UI
        },
        config: Config(
            columns: 7,
            emojiSizeMax: 32 *
                (Platform.isIOS
                    ? 1.30
                    : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
            verticalSpacing: 0,
            horizontalSpacing: 0,
            initCategory: Category.RECENT,
            bgColor: Color(0xFFF2F2F2),
            indicatorColor: Colors.blue,
            iconColor: Colors.grey,
            iconColorSelected: Colors.blue,
            progressIndicatorColor: Colors.blue,
            backspaceColor: Colors.blue,
            skinToneDialogBgColor: Colors.white,
            skinToneIndicatorColor: Colors.grey,
            enableSkinTones: true,
            showRecentsTab: true,
            recentsLimit: 28,
            noRecentsText: "No Recents",
            noRecentsStyle:
                const TextStyle(fontSize: 20, color: Colors.black26),
            tabIndicatorAnimDuration: kTabScrollDuration,
            categoryIcons: const CategoryIcons(),
            buttonMode: ButtonMode.MATERIAL),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.black),
              onPressed: () {
                // if (FocusNode().hasFocus)
                //   FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
              child: Container(
            child: CupertinoButton(
              onPressed: () {
                // showModalBottomSheet(
                //   context: context,
                //   backgroundColor: Colors.transparent,
                //   isScrollControlled: true,
                //   isDismissible: true,
                //   builder: (context) => ProfileView(
                //     uid: widget.partnerUid,
                //     currentUser: widget.userData,
                //   ),
                // );
              },
              minSize: 0,
              padding: EdgeInsets.zero,
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Container(
                    height: 40,
                    width: 40,
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
                      child: widget.dp == null || widget.dp == ''
                          ? Container(
                              color: Color(0xFFD8D8D8),
                              child: Center(
                                child: Text(
                                  widget.userName[0].toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Poppins',
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: widget.dp,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    '@${widget.userName}',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade800,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
          )),
          // Expanded(child: SizedBox()),
        ],
      ),
    );
  }

  void _pickMenu(BuildContext context, String option) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                option == 'gallery' ? _getGalleryImage() : _getCameraImage();
                Navigator.pop(context);
              },
              child:
                  Text(option == 'camera' ? 'Capture Image' : 'Choose Image'),
            ),
            // CupertinoActionSheetAction(
            //   onPressed: () {
            //     option == 'gallery' ? getGalleryVideo() : getCameraVideo();
            //     Navigator.pop(context);
            //   },
            //   child:
            //       Text(option == 'camera' ? 'Capture Video' : 'Choose Video'),
            // ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        );
      },
    );
  }
}

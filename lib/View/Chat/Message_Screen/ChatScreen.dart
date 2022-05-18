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
import 'package:livu/Services/Last_MessageService.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/View/Chat/Message_Screen/GiftsList.dart';
import 'package:livu/View/Chat/Widgets/typingAnimation.dart';
import 'package:livu/theme.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_database/firebase_database.dart';

import 'ChatMessageListItem.dart';
import 'VideoCall/Dial.dart';

class ChattingScreen extends StatefulWidget {
  final String dp, userName, chatID, selfUid, partnerUid;
  final dynamic userData;
  final LastMessage lastMessage;

  bool friendRequest;

  ChattingScreen(
      {this.chatID,
      this.dp,
      this.userName,
      this.userData,
      this.partnerUid,
      this.selfUid,
      this.lastMessage,
      this.friendRequest});
  @override
  _ChattingScreenState createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  bool _uploading = false;
  XFile _image;
  // ignore: unused_field
  String _selectedImageName;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _editingController;
  ScrollController _listController;
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

  // int length = 0;
  // final TextEditingController _textEditingController =
  //     new TextEditingController();
  // bool _isComposingMessage = false;
  // bool switchButton = false;
  // bool favourite;
  // final TextEditingController controller = TextEditingController();
  // XFile image;
  final reference = FirebaseDatabase.instance.ref().child('messages');
  // String userId = Get.find<UserDataController>().userModel.value.id;
  // final friendRequest = Get.put(FriendRequestController());
  String name;
  // FocusNode focusNode = FocusNode();
  // bool showGifts = false;
  // AnimationController _controller;
  // Animation _animation;
  // bool showEmoji = false;
  // final pageController = PageController(viewportFraction: 0.8);
  // List<Gifts> getGifts = getGiftsList();
  // List<Gifts> getData = getlist();
  // Icon _emojiIcon = Icon(
  //   FontAwesomeIcons.smileWink,
  //   color: Colors.grey,
  //   size: 20,
  // );
  @override
  Widget build(BuildContext context) {
    Animation<double> animation = kAlwaysCompleteAnimation;
    double _topPadding = MediaQuery.of(context).padding.top;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: _topPadding),
                  _appBar(),
                  Expanded(
                    child: Container(
                      color: greyColor,
                      child: StreamBuilder(
                          stream: reference
                            
                          .onValue,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<Map<String, dynamic>> messaages = [];
                              final json = snapshot.data.snapshot.value;

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
                                        value[RECEIVER_UID] ==
                                            widget.partnerUid)) {
                                  messaages.add({'value': value, 'key': key});
                                }
                              });
                              messaages.sort((a, b) => b['value']['timeStamp']
                                  .compareTo(a['value']['timeStamp']));
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Get.find<LastMessageController>()
                                    .isLoading
                                    .value = false;
                              });

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
                                            physics: BouncingScrollPhysics(),
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
                                                bottom: 80),
                                            itemBuilder: (context, index) {
                                              return Column(
                                                children: [
                                                  if (index ==
                                                      messaages.length - 1)
                                                    encryptionMessage(),
                                                  ChatMessageListItem(
                                                    index: index,
                                                    messageSnapshot:
                                                        messaages[index],
                                                    animation: animation,
                                                    senderNext: (index == 0)
                                                        ? false
                                                        : messaages[index - 1]
                                                                    ['value'][
                                                                RECEIVER_UID] ==
                                                            widget.selfUid,
                                                    senderPrevSelf: index ==
                                                            messaages.length - 1
                                                        ? false
                                                        : messaages[index + 1]
                                                                    ['value'][
                                                                RECEIVER_UID] ==
                                                            widget.selfUid,
                                                    self: messaages[index]
                                                                ['value']
                                                            [SENDER_UID] ==
                                                        widget.selfUid,
                                                    prevIsSelf: index ==
                                                            messaages.length - 1
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
                                                  // Cont?
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
                                                          widget.lastMessage
                                                                  .name +
                                                              " " +
                                                              'sent you friend request'
                                                                  .tr +
                                                              "Do you want to agree"
                                                                  .tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  purpleColor)),
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
                                                              FriendRequestService().acceptUser(
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
                                                                child: Text(
                                                                    'Agree'),
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color:
                                                                    purpleColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
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
                                                                color:
                                                                    greyColor,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          20),
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
                                                  height: SizeConfig
                                                          .heightMultiplier *
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
                                                          BorderRadius.circular(
                                                              8),
                                                      child: Image.file(
                                                        File(_image.path),
                                                        width: _width * 0.25,
                                                      ),
                                                    ),
                                                    Positioned(
                                                      top: 5,
                                                      right: 5,
                                                      child: CupertinoButton(
                                                        padding:
                                                            EdgeInsets.zero,
                                                        minSize: 0,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            border: Border.all(
                                                              color: Colors
                                                                  .white70,
                                                              width: 1.5,
                                                            ),
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(1.0),
                                                            child: Icon(
                                                              Icons.close,
                                                              color: Colors
                                                                  .white70,
                                                              size: 14,
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () =>
                                                            setState(() {
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
                                                    child:
                                                        LinearProgressIndicator(
                                                      backgroundColor: greyColor
                                                          .withOpacity(0.3),
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
                                          bottom: 2,
                                          left: 2,
                                          child: StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('lastMessage')
                                                .doc(widget.chatID)
                                                .snapshots(),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<dynamic>
                                                    snapshot) {
                                              if (snapshot.hasData) {
                                                for (int i = 0;
                                                    i <
                                                        snapshot.data
                                                            .data()["chatters"]
                                                            .length;
                                                    i++) {
                                                  if (snapshot.data.data()[
                                                              "chatters"][i]
                                                          ["uid"] !=
                                                      Get.find<
                                                              UserDataController>()
                                                          .userModel
                                                          .value
                                                          .id) {
                                                    if (snapshot.data
                                                            .data()["chatters"]
                                                        [i]['isTyping']) {
                                                      return SizedBox(
                                                          height: 80,
                                                          width: 120,
                                                          child:
                                                              TypingAnimation());
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
                    decoration:
                        new BoxDecoration(color: Theme.of(context).cardColor),
                    child: MessageContainer(
                      lastMessage: widget.lastMessage,
                      chatID: widget.lastMessage.docId,
                      dp: widget.dp,
                      userName: widget.userName,
                      partnerUid: widget.partnerUid,
                      selfUid:
                          Get.find<UserDataController>().userModel.value.id,
                      // friendRequest: false,
                    ),
                  ),
                ],
              ),
              GetX<LastMessageController>(
                  init: LastMessageController(),
                  builder: (ctrl) {
                    print(ctrl.isLoading.value);
                    return ctrl.isLoading.value
                        ? Container(
                            height: SizeConfig.heightMultiplier * 100,
                            width: SizeConfig.widthMultiplier * 100,
                            child: Center(
                              child: Lottie.asset(
                                'assets/lotiesAnimation/Loading.json',
                                width: SizeConfig.widthMultiplier * 50,
                                height: SizeConfig.heightMultiplier * 50,
                              ),
                            ),
                          )
                        : SizedBox();
                  })
            ],
          ),
        ),
      ),
    );
  }

  Container encryptionMessage() => Container(
        decoration: BoxDecoration(
          color: greyColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.grey[900],
                offset: const Offset(4.0, 4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0),
            BoxShadow(
                color: Colors.grey[900],
                offset: Offset(-4.0, -4.0),
                blurRadius: 15.0,
                spreadRadius: 1.0),
          ],
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
    return Container();
  }

  Widget _appBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.only(),
      color: greyColor,
      child: Row(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: CupertinoButton(
              minSize: 0,
              padding: EdgeInsets.only(left: 12),
              child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
              onPressed: () {
                if (FocusNode().hasFocus)
                  FocusScope.of(context).requestFocus(FocusNode());
                Navigator.pop(context);
              },
            ),
          ),
          Expanded(
              child: Container(
            child: CupertinoButton(
              onPressed: () {},
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
          Expanded(
              child: Container(
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(),
                ),
                CupertinoButton(
                  onPressed: () => _buildBottomModel(context),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  _buildBottomModel(context) async {
    bool favFriend =
        await LastMessageService().checkIfUserisFav(widget.lastMessage.uid);
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: greyColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              height: SizeConfig.heightMultiplier * 55,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _customTile('Alias', Icons.edit, () {
                    Get.back();
                    _buildBottomModelForName();
                  }),
                  _customTileWithTailing(
                    'Add to Favourite',
                    Icons.star,
                    favFriend == false
                        ? GestureDetector(
                            onTap: () {
                              LastMessageService().addtoFavFriend(
                                  widget.lastMessage.uid,
                                  widget.lastMessage.name,
                                  widget.lastMessage.imageUrl);
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.star_outline,
                              color: Colors.white,
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              LastMessageService().addtofriend(
                                  widget.lastMessage.uid,
                                  widget.lastMessage.name,
                                  widget.lastMessage.imageUrl);
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                          ),
                  ),
                  // _customTileWithTailing(
                  //   'Online reminder',
                  //   Icons.notifications,
                  //   Switch(
                  //     value: switchButton,
                  //     onChanged: (bool newValue) {
                  //       Navigator.pop(context);
                  //       switchButton = newValue;
                  //     },
                  //     activeColor: greenColor,
                  //     activeTrackColor: greenColor,
                  //   ),
                  // ),
                  _customTile('Block', Icons.block, () {}),
                  _customTile('Report', Icons.report, () {}),
                  _customTile('Delete', Icons.delete, () {
                    LastMessageService().deleteUser(widget.lastMessage.uid);
                    Get.back();
                    Get.back();
                    Get.snackbar('Deleted', 'Chat Have been Deleted');
                  }),
                  _customTile('Cancel', Icons.arrow_back, () {
                    Get.back();
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _customTileWithTailing(title, icon, tailingWidget) {
    return ListTile(
      leading:
          Icon(icon, color: icon == Icons.delete ? Colors.red : Colors.grey),
      title: Text(
        title,
        style:
            TextStyle(color: icon == Icons.delete ? Colors.red : Colors.white),
      ),
      trailing: tailingWidget,
    );
  }

  _customTile(title, icon, Function ontap) {
    return ListTile(
      onTap: ontap,
      leading:
          Icon(icon, color: icon == Icons.delete ? Colors.red : Colors.grey),
      title: Text(
        title,
        style:
            TextStyle(color: icon == Icons.delete ? Colors.red : Colors.white),
      ),
    );
  }

  _buildBottomModelForName() {
    return showMaterialModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          decoration: BoxDecoration(
            color: greyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(
                top: 40, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 2),
                      ),
                      SizedBox(
                        height: SizeConfig.heightMultiplier * 2,
                      ),
                      Container(
                        color: Colors.grey[850],
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            initialValue: widget.lastMessage.name,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.white),
                            maxLength: 30,
                            onChanged: (value) {
                              name = value;
                            },
                            decoration: InputDecoration.collapsed(
                              hintStyle: TextStyle(color: Colors.white),
                              hintText: 'Name',
                            ),
                            autofocus: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GestureDetector(
                    onTap: () {
                      LastMessageService()
                          .changeName(widget.lastMessage.uid, name);
                      Get.back();
                      Get.back();
                      Get.snackbar('Name Changed', 'Name has been Changed');
                    },
                    child: Container(
                      height: SizeConfig.heightMultiplier * 7,
                      width: MediaQuery.of(context).size.width * 1,
                      child: Center(
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      color: purpleColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MessageContainer extends StatefulWidget {
  MessageContainer(
      {Key key,
      this.dp,
      this.userName,
      this.chatID,
      this.selfUid,
      this.partnerUid,
      this.userData,
      this.lastMessage})
      : super(key: key);

  final String dp, userName, chatID, selfUid, partnerUid;
  final dynamic userData;
  final LastMessage lastMessage;
  @override
  State<MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  int length = 0;

  final TextEditingController _textEditingController =
      new TextEditingController();

  bool _isComposingMessage = false;

  bool switchButton = false;

  bool favourite;

  final TextEditingController controller = TextEditingController();

  XFile image;

  final reference = FirebaseDatabase.instance.ref().child('messages');

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
  bool _uploading = false;
  XFile _image;
  // ignore: unused_field
  String _selectedImageName;
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    if (focusNode.hasFocus) {
      setState(() {
        showEmoji = false;
        showGifts = false;
      });
    }

    return AnimatedContainer(
        duration: Duration(milliseconds: 500),
        color: greyColor,
        height: (showEmoji || showGifts)
            ? SizeConfig.heightMultiplier * 50
            : SizeConfig.heightMultiplier * 15,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: 4.0),
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
                              if (_isComposingMessage) {
                                Get.find<LastMessageController>().typing(
                                    messageText,
                                    widget.chatID,
                                    widget.lastMessage);
                              } else {
                                Get.find<LastMessageController>().typingFalse(
                                    widget.chatID, widget.lastMessage);
                              }
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
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
                      if (Get.find<UserDataController>()
                              .userModel
                              .value
                              .coins >=
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
                      if (Get.find<UserDataController>()
                              .userModel
                              .value
                              .coins >=
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
            ),
            showGiftPicker(),
            showEmojiPicker(),
          ],
        ));
  }

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
      CHATDOCID: widget.chatID,
      TIMESTAMP: DateTime.now().millisecondsSinceEpoch,
      MESSAGE_TEXT: messageText,
      SENDER_UID: userId,
      RECEIVER_UID: widget.partnerUid,
      MESSAGE_IMAGE_URL: imageUrl,
      SENDER_NAME: Get.find<UserDataController>().userModel.value.name,
      SENDER_IMAGE_URL: Get.find<UserDataController>().userModel.value.imageUrl,
    }).catchError((e) {
      print(e);
    });

    _sendLatestMessage(messageText);
  }

  void _sendLatestMessage(String latestMessage) {
    CollectionReference docRef =
        FirebaseFirestore.instance.collection('lastMessage');

    docRef.doc(widget.chatID).update({
      LATEST_MESSAGE: latestMessage,
      // LATEST_REFERENCE: _recRef,
      'chatters': [
        {
          'uid': Get.find<UserDataController>().userModel.value.id,
          'dp': Get.find<UserDataController>().userModel.value.imageUrl,
          'name': Get.find<UserDataController>().userModel.value.name,
          'isTyping': false
        },
        {
          'uid': widget.partnerUid,
          'dp': widget.dp,
          'name': widget.userName,
          'isTyping': false
        }
      ],
      'chattersUid': [
        Get.find<UserDataController>().userModel.value.id,
        widget.partnerUid
      ],
      MESSAGE_TIME: DateTime.now().toString(),
      'uid': widget.partnerUid,
      'dp': widget.dp,
    }).catchError((e) {
      // print(e);
    });
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
        uid: widget.partnerUid);
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
    return AnimatedContainer(
      height: showEmoji ? SizeConfig.heightMultiplier * 35 : 0,
      duration: Duration(milliseconds: 500),
      child: EmojiPicker(
        onEmojiSelected: (category, Emoji emoji) {
          _textEditingController.text =
              _textEditingController.text + emoji.emoji;
          setState(() {
            _isComposingMessage = true;
          });
          // Do something when emoji is tapped
        },
        onBackspacePressed: () {
          _backspace();
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

  void _backspace() {
    final text = _textEditingController.text;
    final textSelection = _textEditingController.selection;
    final selectionLength = textSelection.end - textSelection.start;

    // There is a selection.
    if (selectionLength > 0) {
      final newText = text.replaceRange(
        textSelection.start,
        textSelection.end,
        '',
      );
      _textEditingController.text = newText;
      _textEditingController.selection = textSelection.copyWith(
        baseOffset: textSelection.start,
        extentOffset: textSelection.start,
      );
      return;
    }

    // The cursor is at the beginning.
    if (textSelection.start == 0) {
      return;
    }

    // Delete the previous character
    final previousCodeUnit = text.codeUnitAt(textSelection.start - 1);
    final offset = _isUtf16Surrogate(previousCodeUnit) ? 2 : 1;
    final newStart = textSelection.start - offset;
    final newEnd = textSelection.start;
    final newText = text.replaceRange(
      newStart,
      newEnd,
      '',
    );
    _textEditingController.text = newText;
    _textEditingController.selection = textSelection.copyWith(
      baseOffset: newStart,
      extentOffset: newStart,
    );
  }

  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    // await _ensureLoggedIn();
    _sendMessage(messageText: text, imageUrl: null);
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

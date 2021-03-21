import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:livu/Services/Last_MessageService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'VideoCall/Dial.dart';
import 'VideoCall/call.dart';
import 'package:flutter/cupertino.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:image_picker/image_picker.dart';
import '../../../Model/MessageModel.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'ChatMessageListItem.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:livu/Services/FriendRequestService.dart';
import 'package:get/get.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:livu/Model/FriendRequest_Model.dart';
import 'package:livu/Controller/FriendRequestController.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'VideoCall/PickupLayout.dart';
import 'package:livu/View/BuyCoins/BuyCoins.dart';
import 'package:livu/View/Chat/Message_Screen/GiftsList.dart';

// final googleSignIn = new GoogleSignIn();
// final analytics = new FirebaseAnalytics();
final auth = FirebaseAuth.instance;
var currentUserEmail;
var _scaffoldContext;

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
  bool _isComposingMessage = false;
  bool switchButton = false;
  bool favourite;
  final TextEditingController controller = TextEditingController();
  File image;
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
    return PickupLayout(
      scaffold: new Scaffold(
        appBar: new AppBar(
          backgroundColor: greyColor,
          title: Text(widget.lastMessage.name),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () => _buildBottomModel(context),
                child: widget.friendRequest == false
                    ? Icon(Icons.more_horiz)
                    : SizedBox(),
              ),
            ),
          ],
        ),
        body: GestureDetector(
          onTap: () {
            setState(() {
              showGifts == true ? showGifts = false : null;
              showEmoji == true ? showEmoji = false : null;
            });
          },
          child: new Container(
            color: greyColor,
            child: Stack(
              children: [
                new Column(
                  children: <Widget>[
                    new Flexible(
                      child: new FirebaseAnimatedList(
                        query: reference,
                        padding: const EdgeInsets.all(8.0),
                        reverse: true,
                        sort: (a, b) => b.key.compareTo(a.key),

                        //comparing timestamp of messages to check which one would appear first
                        itemBuilder: (_, DataSnapshot messageSnapshot,
                            Animation<double> animation, ref) {
                          if ((messageSnapshot.value[SENDER_UID] == userId ||
                                  messageSnapshot.value[RECEIVER_UID] ==
                                      userId) &&
                              (messageSnapshot.value[SENDER_UID] ==
                                      widget.lastMessage.uid ||
                                  messageSnapshot.value[RECEIVER_UID] ==
                                      widget.lastMessage.uid)) {
                            print("item called");
                            return new ChatMessageListItem(
                              messageSnapshot: messageSnapshot,
                              animation: animation,
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                    new Divider(height: 1.0),
                    new Container(
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
                      child: _buildMessageComposer(context),
                    ),
                    new Builder(builder: (BuildContext context) {
                      _scaffoldContext = context;
                      return new Container(width: 0.0, height: 0.0);
                    })
                  ],
                ),
                widget.friendRequest
                    ? Positioned(
                        child: Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Text(
                                  widget.lastMessage.name +
                                      ' has sent you friend request. Do you want to agree',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: purpleColor)),
                              SizedBox(
                                height: SizeConfig.heightMultiplier * 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // friendRequest.friendRequestCtr
                                      //     .remove(widget.index);
                                      // friendRequest.otherUserDataCtr
                                      //     .remove(widget.index);
                                      FriendRequestService().acceptUser(
                                          widget.lastMessage.uid,
                                          widget.lastMessage.name,
                                          widget.lastMessage.imageUrl);
                                      Get.back();
                                    },
                                    child: Container(
                                      height: SizeConfig.heightMultiplier * 5,
                                      width: SizeConfig.widthMultiplier * 20,
                                      child: Center(
                                        child: Text('Agree'),
                                      ),
                                      decoration: BoxDecoration(
                                        color: purpleColor,
                                        borderRadius: BorderRadius.all(
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
                                              widget.lastMessage.uid);
                                    },
                                    child: Container(
                                      height: SizeConfig.heightMultiplier * 5,
                                      width: SizeConfig.widthMultiplier * 20,
                                      child: Center(
                                        child: Text(
                                          'Ignore',
                                          style: TextStyle(color: purpleColor),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: purpleColor),
                                        color: greyColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          width: MediaQuery.of(context).size.width,
                          height: SizeConfig.heightMultiplier * 20,
                        ),
                      )
                    : Container(),
              ],
            ),
            decoration: Theme.of(context).platform == TargetPlatform.iOS
                ? new BoxDecoration(
                    border: new Border(
                      top: new BorderSide(
                        color: Colors.grey[200],
                      ),
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
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
    print('tapped');
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
                              hintText: "Send a message"),
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
                      var gallery = await ImagePicker.pickImage(
                          source: ImageSource.gallery,
                          maxWidth: 200,
                          maxHeight: 300);
                      print(gallery.path);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      var snapshot = await FirebaseStorage.instance
                          .ref()
                          .child(
                              'chat_images/${DateTime.now().toString()}myimage.jpg')
                          .putFile(File(gallery.path));

                      await snapshot.ref.getDownloadURL().then((value) {
                        _sendMessage(
                            messageText: 'Image', imageUrl: value.toString());
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
                      Get.snackbar('Buy Coins',
                          'You Dont have enough coin for video call');
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
                      Get.snackbar('Buy Coins',
                          'You Dont have enough coin for video call');
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
                  print(File(getData[index].imageUrl.createPath()));
                  //  var gallery = await ImagePicker.platform.
                  int timestamp = new DateTime.now().millisecondsSinceEpoch;
                  var snapshot = await FirebaseStorage.instance
                      .ref()
                      .child(
                          'chat_images/${DateTime.now().toString()}myimage.jpg')
                      .putFile(File(getData[index].imageUrl.createPath()))
                      .catchError((e) {
                    print(e);
                  });

                  await snapshot.ref.getDownloadURL().then((value) {
                    _sendMessage(
                        messageText: 'Image', imageUrl: value.toString());
                  });
                  setState(() {
                    showGifts = false;
                  });
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: SizeConfig.widthMultiplier * 18,
                      height: SizeConfig.heightMultiplier * 12,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(getGifts[index].imageUrl),
                        ),
                      ),
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
                          getGifts[index].coins,
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: SizeConfig.widthMultiplier * 18,
                    height: SizeConfig.heightMultiplier * 12,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(getData[index].imageUrl),
                      ),
                    ),
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
                        getData[index].coins,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
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
        rows: 3,
        columns: 7,
        selectedCategory: Category.SMILEYS,
        buttonMode: ButtonMode.CUPERTINO,
        bgColor: greyColor,
        onEmojiSelected: (emoji, category) {
          // print(emoji);
          setState(() {
            _isComposingMessage = true;
            _textEditingController.text =
                _textEditingController.text + emoji.emoji;
          });
        },
      ),
    );
  }

  Future<Null> _textMessageSubmitted(String text) async {
    _textEditingController.clear();

    setState(() {
      _isComposingMessage = false;
    });

    // await _ensureLoggedIn();
    _sendMessage(messageText: text, imageUrl: null);
  }

  _getImagefromgallery() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
  }

  _getImagefromcamera() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
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

    // DocumentReference _recRef = FirebaseFirestore.instance
    //     .collection(USERS_COLLECTION)
    //     .doc(widget.lastMessage.uid);
    // DocumentReference _userRef = FirebaseFirestore.instance
    //     .collection(USERS_COLLECTION)
    //     .doc(Get.find<UserDataController>().userModel.value.id);

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
                  _customTileWithTailing(
                    'Online reminder',
                    Icons.notifications,
                    Switch(
                      value: switchButton,
                      onChanged: (bool newValue) {
                        Navigator.pop(context);
                        switchButton = newValue;
                      },
                      activeColor: greenColor,
                      activeTrackColor: greenColor,
                    ),
                  ),
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

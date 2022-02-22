import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'Widgets/CommunityVideo.dart';
import 'package:get/route_manager.dart';
import 'Message_Screen/ChatScreen.dart';
import 'Pages/FriendsScreen.dart';
import 'package:livu/View/Chat/Pages/AddFriend.dart';
import 'package:livu/Services/Last_MessageService.dart';
import 'Widgets/CustomerService.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/lastMessageController.dart';
import 'package:livu/Controller/FriendRequestController.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool appBar = true;
  List<String> seletedUser = [];
  int count;
  final friendRequest = Get.put(FriendRequestController());

  @override
  Widget build(BuildContext context) {
    // friendRequest.onInit();
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: greyColor,
        body: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  CommunityVideo(),
                  Divider(
                    color: Colors.grey[850],
                  ),
                  CustomerService(),
                  Divider(
                    color: Colors.grey[850],
                  ),
                  ListTile(
                    onTap: () => Get.to(() => AddFriend()),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: orangeColor,
                      backgroundImage: AssetImage('assets/userAvatar.png'),
                    ),
                    title: Text(
                      'Add Friend',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: SizeConfig.textMultiplier * 2),
                    ).tr(),
                    trailing:
                        GetX<FriendRequestController>(builder: (controller) {
                      // controller.refresh();
                      return controller.friendRequestCtr.length != 0
                          ? Container(
                              width: 20,
                              height: 20,
                              child: Center(
                                  child: Text(
                                controller.friendRequestCtr.length.toString(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              )),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      redColor,
                                      pinkColor,
                                    ],
                                  ),
                                  shape: BoxShape.circle),
                            )
                          : Container(
                              width: 30,
                              height: 30,
                            );
                    }),
                  ),
                  Divider(
                    color: Colors.grey[850],
                  ),
                  GetX<LastMessageController>(
                    builder: (controller) {
                      return controller.lastMessage.length != 0
                          ? Container(
                              child: ListView.separated(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: Colors.grey[850],
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return chatContainer(
                                    controller.lastMessage[index],
                                  );
                                },
                                itemCount: controller.lastMessage.length,
                              ),
                            )
                          : Container();
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  chatContainer(LastMessage lastmessage) {
    return ListTile(
      onLongPress: () {
        setState(() {
          appBar = false;
          seletedUser.add(lastmessage.uid);
        });
      },
      tileColor:
          seletedUser.contains(lastmessage.uid) ? Colors.grey[800] : greyColor,
      onTap: () {
        appBar == true
            ? Get.to(() => ChatScreen(
                  lastMessage: lastmessage,
                  friendRequest: false,
                  // lastMessage: lastmessage,
                ))
            : setState(
                () {
                  seletedUser.contains(lastmessage.uid)
                      ? seletedUser.remove(lastmessage.uid)
                      : seletedUser.add(lastmessage.uid);
                  seletedUser.length >= 1 ? appBar = false : appBar = true;
                },
              );
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          lastmessage.imageUrl,
        ),
        radius: 30,
      ),
      title: Text(
        lastmessage.name,
        style: TextStyle(
            color: Colors.grey[300], fontSize: SizeConfig.textMultiplier * 2),
      ),
      subtitle: Text(
        lastmessage.lastMessage,
        style: TextStyle(
            color: Colors.grey, fontSize: SizeConfig.textMultiplier * 1.5),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            lastmessage.time.substring(0, 10),
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  _buildAppBar() {
    return appBar
        ? SliverAppBar(
            pinned: false,
            floating: true,
            elevation: 0,
            title: Text(
              'Message',
              style: TextStyle(color: Colors.white),
            ).tr(),
            backgroundColor: greyColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () => Get.to(() => FriendsScreen()),
                  child: FaIcon(
                    FontAwesomeIcons.userFriends,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          )
        : SliverAppBar(
            pinned: false,
            floating: true,
            elevation: 0,
            title: Text(seletedUser.length.toString() + ' Message'),
            backgroundColor: greyColor,
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        appBar = true;
                        seletedUser.length = 0;
                      });
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: GestureDetector(
                    onTap: () {
                      print(seletedUser);
                      LastMessageService()
                          .deleteChat(seletedUser)
                          .then((value) {
                        setState(() {
                          seletedUser = [];
                          appBar = true;
                        });
                      });
                    },
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    )),
              ),
            ],
          );
  }
}

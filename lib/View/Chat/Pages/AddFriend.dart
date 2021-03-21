import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:livu/View/Chat/Message_Screen/ChatScreen.dart';
import 'package:livu/Controller/FriendRequestController.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class AddFriend extends StatefulWidget {
  @override
  _AddFriendState createState() => _AddFriendState();
}

bool showAppbar = true;
bool seletedValue = true;

class _AddFriendState extends State<AddFriend> {
  //final friendRequest = Get.put(FriendRequestController());

  @override
  Widget build(BuildContext context) {
    final friendRequest = Get.find<FriendRequestController>();
    //friendRequest.onInit();
    // print('this');
    // print(friendRequest.friendRequestModel.value.time);
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: greyColor,
        appBar: showAppbar
            ? AppBar(
                backgroundColor: purpleColor,
                title: Text('Hi'),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: GestureDetector(
                        onTap: () => setState(() {
                              showAppbar = false;
                              //friendRequest.onInit();
                            }),
                        child: Icon(Icons.sort)),
                  ),
                ],
              )
            : AppBar(
                backgroundColor: purpleColor,
                title: Text('Messages'),
                actions: [
                  GestureDetector(
                    onTap: () => setState(() {
                      friendRequest.onInit();
                      showAppbar = true;
                    }),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.message),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Icon(Icons.delete),
                  ),
                ],
              ),
        body: Column(
          children: [
            Expanded(
              child: GetX<FriendRequestController>(builder: (controller) {
                // print(controller.otherUserData.length);
                return ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.grey[800],
                    );
                  },
                  itemBuilder: (_, index) {
                    return _buildListTile(controller, index);
                  },
                  itemCount: controller.friendRequestCtr.length,
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  _buildListTile(FriendRequestController dataController, index) {
    return GestureDetector(
      onTap: () {
        LastMessage model =
            LastMessage.fromFriendModel(dataController.friendRequestCtr[index]);
        Get.to(
          () => ChatScreen(
            lastMessage: model,
            friendRequest: true,
          ),
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius: 32,
          backgroundImage:
              NetworkImage(dataController.friendRequestCtr[index].imageUrl),
        ),
        title: Text(
          dataController.friendRequestCtr[index].name,
          style: TextStyle(
              color: Colors.grey[300],
              fontSize: SizeConfig.textMultiplier * 1.7),
        ),
        subtitle: Text(
          dataController.friendRequestCtr[index].name +
              ' sent you friend request',
          style: TextStyle(
            fontSize: SizeConfig.textMultiplier * 1.5,
            color: Colors.grey[500],
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              dataController.friendRequestCtr[index].time,
              style: TextStyle(color: Colors.white),
            ),
            Container(
              width: SizeConfig.heightMultiplier * 2,
              height: SizeConfig.heightMultiplier * 2,
              child: Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: SizeConfig.textMultiplier * 1.1,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [orangeColor, pinkColor],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

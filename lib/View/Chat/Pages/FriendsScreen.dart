import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/Chat/Message_Screen/ChatScreen.dart';
import 'package:livu/theme.dart';
import '../Widgets/CustomerService.dart';
import 'package:flag/flag.dart';
import 'package:get/route_manager.dart';
import 'package:livu/Controller/lastMessageController.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'online_remender.dart';
import 'SearchFriends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';

class FriendsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: greyColor,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: false,
              floating: true,
              elevation: 0,
              title: Text('Friends'),
              backgroundColor: greyColor,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: GestureDetector(
                    onTap: () => Get.to(() => SearchFriends()),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                )
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Favourite Friends',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: SizeConfig.textMultiplier * 1.6)),
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('UserData')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection('FavFriends')
                        .get(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : snapshot.data.docs.length != 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return chatContainer(
                                        snapshot.data.docs[index].get('Name'),
                                        snapshot.data.docs[index]
                                            .get('ImageUrl'),
                                        snapshot.data.docs[index].get('Uid'));
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'No Favourite Friends Available',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize:
                                            SizeConfig.textMultiplier * 1.3),
                                  ),
                                );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Friends',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('UserData')
                        .doc(FirebaseAuth.instance.currentUser.uid)
                        .collection('Friends')
                        .get(),
                    builder: (context, snapshot) {
                      return snapshot.connectionState == ConnectionState.waiting
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : snapshot.data.docs.length != 0
                              ? ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return chatContainer(
                                        snapshot.data.docs[index].get('Name'),
                                        snapshot.data.docs[index]
                                            .get('ImageUrl'),
                                        snapshot.data.docs[index].get('Uid'));
                                  },
                                )
                              : Center(
                                  child: Text(
                                    'No Friends Available',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.heightMultiplier * 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  chatContainer(name, image, uid) {
    return GestureDetector(
      onTap: () {
        LastMessage model = LastMessage.feomUserInfo(name, image, uid);
        Get.to(() => ChatScreen(
              lastMessage: model,
              friendRequest: false,
            ));
      },
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
            image,
          ),
          radius: 30,
        ),
        title: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Row(
          children: [
            // Text(
            //   'Last Message: ' + lastMessageModel.time.substring(0, 19),
            //   style: TextStyle(color: Colors.grey[400]),
            // ),
          ],
        ),
      ),
    );
  }
}

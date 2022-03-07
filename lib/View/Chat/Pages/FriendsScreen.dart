import 'package:flutter/material.dart';
import 'package:livu/SizedConfig.dart';
import 'package:livu/View/Chat/Message_Screen/ChatScreen.dart';
import 'package:livu/View/Chat/Widgets/CustomerServiceChatScreen.dart';
import 'package:livu/theme.dart';
import 'package:get/route_manager.dart';
import 'package:livu/Model/Last_MessageModel.dart';
import 'package:lottie/lottie.dart';
import 'SearchFriends.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';
import 'package:easy_localization/easy_localization.dart';

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
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'Friend',
                style: TextStyle(
                  color: Colors.white,
                ),
              ).tr(),
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
                    child: Text('Favourite_Friend',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.textMultiplier * 1.6))
                        .tr(),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            SizeConfig.heightMultiplier * 25,
                                        width: SizeConfig.heightMultiplier * 25,
                                        child: Lottie.asset(
                                            'assets/lotiesAnimation/AddFriend.json'),
                                      ),
                                      // SizedBox(
                                      //   height: SizeConfig.heightMultiplier * 1,
                                      // ),
                                      Text(
                                        'No_Friend',
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.heightMultiplier * 2.5,
                                          color: purpleColor,
                                        ),
                                      ).tr(),
                                    ],
                                  ),
                                );
                      ;
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
                      'Friend',
                      style: TextStyle(color: Colors.white),
                    ).tr(),
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
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height:
                                            SizeConfig.heightMultiplier * 25,
                                        width: SizeConfig.heightMultiplier * 25,
                                        child: Lottie.asset(
                                            'assets/lotiesAnimation/AddFriend.json'),
                                      ),
                                      // SizedBox(
                                      //   height: SizeConfig.heightMultiplier * 1,
                                      // ),
                                      Text(
                                        'No_Friend',
                                        style: TextStyle(
                                          fontSize:
                                              SizeConfig.heightMultiplier * 2.5,
                                          color: purpleColor,
                                        ),
                                      ).tr(),
                                    ],
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
              // lastMessage: model,
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

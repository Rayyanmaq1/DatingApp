import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:livu/theme.dart';
import 'package:livu/SizedConfig.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/PickupLayout.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:lottie/lottie.dart';

class SearchFriends extends StatefulWidget {
  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  @override
  TextEditingController _controller;
  String search = '';
  // searchUser() {
  //   controller.addListener(() {
  //     setState(() {});
  //   });
  //   super.initState();
  // }

  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
          backgroundColor: AppColors.greyColor,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: AppColors.greyColor,
            elevation: 0,
            title: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  print('nick_name'.tr());
                  search = value;
                });
              },
              style: TextStyle(color: Colors.white),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(
                hintText: 'Search'.tr(),
                hintStyle: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.only(top: 15, right: 12, bottom: 8),
                child: Container(
                  child: Center(child: Text('Search').tr()),
                  decoration: BoxDecoration(
                    color: AppColors.purpleColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  width: SizeConfig.widthMultiplier * 15,
                ),
              )
            ],
          ),
          body: search == ''
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: SizeConfig.heightMultiplier * 30,
                        width: SizeConfig.heightMultiplier * 30,
                        child: Lottie.asset(
                            'assets/lotiesAnimation/NoSearch.json'),
                      ),

                      // SizedBox(
                      //   height: SizeConfig.heightMultiplier * 1,
                      // ),
                    ],
                  ),
                )
              : FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('UserData')
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .collection('last_message')
                      .get(),
                  builder: (context, snapshot) {
                    if (ConnectionState.waiting == snapshot.connectionState) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.data.docs.length != 0) {
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return search.length != 0
                                  ? search.toString().toUpperCase() ==
                                          snapshot.data.docs[index]
                                              .get('Name')
                                              .toString()
                                              .toUpperCase()
                                              .substring(0, search.length)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ListTile(
                                            leading: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                snapshot.data.docs[index]
                                                    .get('ImageUrl'),
                                              ),
                                              radius: 30,
                                            ),
                                            title: Text(
                                              snapshot.data.docs[index]
                                                  .get('Name'),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : Container()
                                  : Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            snapshot.data.docs[index]
                                                .get('ImageUrl'),
                                          ),
                                          radius: 30,
                                        ),
                                        title: Text(
                                          snapshot.data.docs[index].get('Name'),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    );
                            });
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: SizeConfig.heightMultiplier * 30,
                                width: SizeConfig.heightMultiplier * 30,
                                child: Lottie.asset(
                                    'assets/lotiesAnimation/NoSearch.json'),
                              ),

                              // SizedBox(
                              //   height: SizeConfig.heightMultiplier * 1,
                              // ),
                              Text(
                                'No_Friend',
                                style: TextStyle(
                                  fontSize: SizeConfig.heightMultiplier * 2.5,
                                  color: AppColors.purpleColor,
                                ),
                              ).tr(),
                            ],
                          ),
                        );
                      }
                    }
                  })),
    );
  }
}

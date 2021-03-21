import 'package:flutter/material.dart';
import 'package:livu/View/Explore/Explore.dart';
import 'package:livu/View/Chat/ChatPage.dart';
import 'package:livu/View/Search/Search.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:livu/theme.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';
import 'package:livu/Controller/FriendRequestController.dart';
import 'package:livu/Controller/HistoryController.dart';
import 'package:livu/Controller/lastMessageController.dart';
import 'package:livu/Controller/PrivateVideoController.dart';
//import 'package:livu/View/Chat/Message_Screen/ChatScreen.dart';
import 'package:livu/Controller/VideoController.dart';

class CustomNavigation extends StatefulWidget {
  @override
  _CustomNavigationState createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  PageController controller = PageController();
  List<Widget> pageList = List<Widget>();
  int index;
  bool userStatus = false;
  int _selectedPage = 1;

  @override
  void initState() {
    Get.put(UserDataController());
    Get.put(FriendRequestController());
    Get.put(LastMessageController());
    Get.put(HistoryController());
    Get.put(PrivateVideoController());
    Get.put(AllVideoController());
    Get.put(PrivateVideoController());

    pageList.add(Explore());
    pageList.add(Search());
    pageList.add(ChatPage());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          pageList[_selectedPage],
          Align(
            alignment: Alignment.bottomCenter,
            child: Theme(
              data: Theme.of(context).copyWith(canvasColor: Colors.black),
              child: BottomNavigationBar(
                showSelectedLabels: false,
                elevation: 0,
                iconSize: 28,
                showUnselectedLabels: false,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.explore),
                    label: ("Explore"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: ("Search"),
                  ),
                  BottomNavigationBarItem(
                    icon: FaIcon(
                      FontAwesomeIcons.solidCommentDots,
                    ),
                    label: ("Chat"),
                  ),
                ],
                currentIndex: _selectedPage,
                selectedItemColor: _selectedPage == 0
                    ? Colors.amber
                    : _selectedPage == 1
                        ? Colors.white
                        : purpleColor,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
    });
  }
}

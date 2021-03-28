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
import 'package:livu/View/Search/Widgets/PopUp.dart';
import 'package:livu/Controller/VideoController.dart';
import 'package:easy_localization/easy_localization.dart';

class CustomNavigation extends StatefulWidget {
  bool showPopUps = false;
  CustomNavigation({this.showPopUps});
  @override
  _CustomNavigationState createState() => _CustomNavigationState();
}

class _CustomNavigationState extends State<CustomNavigation> {
  PageController controller = PageController(initialPage: 1);
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

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    widget.showPopUps
        ? setState(() {
            widget.showPopUps = false;
            popUp(context);
          })
        : null;
    return Scaffold(
      body: SizedBox.expand(
          child: PageView(
        controller: controller,
        children: [
          Explore(),
          Search(),
          ChatPage(),
        ],
        onPageChanged: (index) {
          setState(() => _selectedPage = index);
        },
      )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        onTap: _onItemTapped,
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
        // onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;
      //
      //
      //using this page controller you can make beautiful animation effects
      controller.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedPage = index;
  //   });
  // }

}

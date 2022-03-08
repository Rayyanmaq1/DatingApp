import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:livu/Model/Last_MessageModel.dart';

import 'package:livu/Services/Last_MessageService.dart';

import 'CurrentUserData.dart';

class LastMessageController extends GetxController {
  // ignore: deprecated_member_use
  RxList<LastMessage> lastMessage = List<LastMessage>().obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    lastMessage.bindStream(LastMessageService().getfriendRequests());
  }

  typing(String message, String id, LastMessage messageModel) {
    bool runOnce = true;

    FirebaseFirestore.instance
        .collection('lastMessage')
        .doc(id)
        .get()
        .then((value) {
      if (message.length != 0 && runOnce) {
        runOnce = false;
        LastMessage lastMessage =
            LastMessage.fromDocumentSnapshot(value.data(), value.id);

        lastMessage.chatters.map((e) {
          if (e.uid == Get.find<UserDataController>().userModel.value.id) {
            e.isTyping = true;
          }
        }).toList();

        List<Map<String, dynamic>> mappedList =
            List.from(lastMessage.chatters.map((e) => e.toMap()));
        FirebaseFirestore.instance.collection('lastMessage').doc(id).set({
          'chatters': mappedList,
        }, SetOptions(merge: true));
      } else if (message.length == 0) {
        runOnce = true;
        LastMessage lastMessage =
            LastMessage.fromDocumentSnapshot(value.data(), value.id);

        lastMessage.chatters.map((e) {
          if (e.uid == Get.find<UserDataController>().userModel.value.id) {
            e.isTyping = false;
          }
        }).toList();

        List<Map<String, dynamic>> mappedList =
            List.from(lastMessage.chatters.map((e) => e.toMap()));
        FirebaseFirestore.instance.collection('lastMessage').doc(id).set({
          'chatters': mappedList,
        }, SetOptions(merge: true));
      }
    });
  }

  typingFalse(String id, LastMessage messageModel) {
    FirebaseFirestore.instance
        .collection('lastMessage')
        .doc(id)
        .get()
        .then((value) {
      LastMessage lastMessage =
          LastMessage.fromDocumentSnapshot(value.data(), value.id);

      lastMessage.chatters.map((e) {
        if (e.uid == Get.find<UserDataController>().userModel.value.id) {
          e.isTyping = false;
        }
      }).toList();

      List<Map<String, dynamic>> mappedList =
          List.from(lastMessage.chatters.map((e) => e.toMap()));
      FirebaseFirestore.instance.collection('lastMessage').doc(id).set({
        'chatters': mappedList,
      }, SetOptions(merge: true));
    });
  }
}

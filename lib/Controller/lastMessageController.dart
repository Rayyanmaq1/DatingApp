import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:livu/Model/Last_MessageModel.dart';

import 'package:livu/Services/Last_MessageService.dart';

class LastMessageController extends GetxController {
  RxList<LastMessage> lastMessage = List<LastMessage>().obs;

  @override
  void onInit() {
    super.onInit();
    lastMessage.bindStream(LastMessageService().getfriendRequests());
  }
}

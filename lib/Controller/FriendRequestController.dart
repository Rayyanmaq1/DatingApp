import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get.dart';
import 'package:livu/Services/FriendRequestService.dart';
import 'package:livu/Model/FriendRequest_Model.dart';

class FriendRequestController extends GetxController {
  RxList<FriendRequest> friendRequestCtr = List<FriendRequest>().obs;
  @override
  void onInit() {
    super.onInit();
    friendRequestCtr.bindStream(FriendRequestService().getfriendRequests());
  }
}

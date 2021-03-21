import 'package:get/get.dart';
import 'package:livu/Model/VideoCallModel.dart';
import 'package:livu/Services/PrivateVideoCall.dart';
import 'package:livu/View/Chat/Message_Screen/VideoCall/call.dart';

class PrivateVideoController extends GetxController {
  RxList<Call> callList = List<Call>().obs;
  @override
  void onInit() {
    super.onInit();
    callList.bindStream(PrivateCallService().getVideCallData());
    // print(callList.first.callerId);
    print('here we are');
    // if (callList.length != 0) {
    //   print(callList.first.callerId);
    //   Get.to(
    //     () => CallPage(
    //       documentId: callList.first.toString(),
    //       channelName: callList.first.channelId,
    //     ),
    //   );
  }
}

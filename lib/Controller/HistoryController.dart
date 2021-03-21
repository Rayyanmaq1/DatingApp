import 'package:get/get.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:livu/Services/HistoryService.dart';
import 'package:livu/Model/HistoryModel.dart';

class HistoryController extends GetxController {
  RxList<HistoryModel> videoCallhistoryController = List<HistoryModel>().obs;
  RxList<HistoryModel> iMissedhistoryController = List<HistoryModel>().obs;
  RxList<HistoryModel> theyMissedhistoryController = List<HistoryModel>().obs;
  @override
  void onInit() {
    super.onInit();
    videoCallhistoryController
        .bindStream(HistoryService().getVideoCallHistory());
    iMissedhistoryController.bindStream(HistoryService().getIMissedHistory());
    theyMissedhistoryController
        .bindStream(HistoryService().getTheyMissedHistory());
  }
}

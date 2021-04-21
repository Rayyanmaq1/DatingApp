import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:livu/Controller/CurrentUserData.dart';

class ReportService {
  reportUser(reportMsg, uid, name) {
    String reportUserMsg =
        'Reason: ' + reportMsg + '\nUid: ' + uid + '\nName: ' + name;

    Map<String, dynamic> setReport = {
      'last_message': reportUserMsg,
      'messageTime': DateTime.now().toString(),
      'Uid': Get.find<UserDataController>().userModel.value.id,
      'ImageUrl': Get.find<UserDataController>().userModel.value.imageUrl,
      'Name': Get.find<UserDataController>().userModel.value.name,
    };

    FirebaseFirestore.instance
        .collection('CustomerService')
        .doc(Get.find<UserDataController>().userModel.value.id)
        .set(setReport);
    FirebaseFirestore.instance
        .collection('UserData')
        .doc(Get.find<UserDataController>().userModel.value.id)
        .collection('CustomerService')
        .doc()
        .set(setReport);
  }
}

import 'package:livu/Model/UserModel.dart';
import 'package:get/get.dart';
import 'package:livu/Services/UserDataServices.dart';

class UserDataController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;

  @override
  void onInit() {
    super.onInit();
    userModel.bindStream(UserDataServices().getUserData());
  }
}

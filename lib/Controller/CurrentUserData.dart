import 'package:livu/Model/UserModel.dart';
import 'package:get/get.dart';
import 'package:livu/Services/UserDataServices.dart';

class UserDataController extends GetxController {
  Rx<UserModel> userModel = UserModel().obs;
  UserModel get userData => userModel.value;
  @override
  void onInit() {
    super.onInit();
    userModel.bindStream(UserDataServices().getUserData());
  }
}

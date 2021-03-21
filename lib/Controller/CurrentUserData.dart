import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:livu/Model/UserModel.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
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

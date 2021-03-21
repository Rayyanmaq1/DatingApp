import 'package:get/get.dart ';
import 'package:livu/Model/VideoModel.dart';
import 'package:livu/Services/VideoLinkServices.dart';

class AllVideoController extends GetxController {
  RxList<VideoModel> videoLinks = List<VideoModel>().obs;

  @override
  void onInit() {
    super.onInit();
    videoLinks.bindStream(VideoService().getAllVideos());
  }
}

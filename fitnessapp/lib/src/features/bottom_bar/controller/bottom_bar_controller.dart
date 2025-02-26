import 'package:get/get.dart';

class BottomBarController extends GetxController {
  static BottomBarController get to => Get.find();
  RxInt bottomBarIndex = 0.obs;
  void updateBottomBarIndex(index) {
    bottomBarIndex.value = index;
  }
}

import 'package:FitTrack/src/features/bottom_bar/controller/bottom_bar_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Homecontroller extends GetxController{
  static Homecontroller get to => Get.find();
  RxString startDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;

  RxBool loadchart=false.obs;
  

}
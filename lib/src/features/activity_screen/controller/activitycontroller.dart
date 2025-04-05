import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/repository/avg_heartrate_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Activitycontroller extends GetxController {
  static Activitycontroller get to => Get.find();
  RxBool isActivityFound = false.obs;
  late Rx<Activity> dropDownValue = FitBitConst.activities![0].obs;
  RxString startDate = DateFormat("yyyy-MM-dd").format(DateTime.now()).obs;

  RxBool isLoadingmap = false.obs;
}

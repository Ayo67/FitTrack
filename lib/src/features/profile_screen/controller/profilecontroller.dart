import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitnessapp/src/common/constant/fitbitconst.dart';
import 'package:fitnessapp/src/repository/usermodel.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  RxBool isEdit = false.obs;

  edit(UserModel model) async {
    FitBitConst.usesrData.value = model;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FitBitConst.
        fitbitCredentials!.userID)
        .update(FitBitConst.usesrData.value.toMap())
        .whenComplete(
          () => isEdit.value = false,
        );
  }
 String getBmiWithCategory(double weight, double heightCm) {
  if (weight == 0 || heightCm == 0) return "N/A";

  double heightM = heightCm / 100;
  double bmi = weight / (heightM * heightM);

  String category;
  if (bmi < 18.5) {
    category = "Underweight";
  } else if (bmi < 25) {
    category = "Healthy Weight";
  } else if (bmi < 30) {
    category = "Overweight";
  } else {
    category = "Obese";
  }

  return "${bmi.toStringAsFixed(1)} ($category)";
}

}

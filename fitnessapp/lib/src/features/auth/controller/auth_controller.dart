import 'package:get/get.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  RxBool visibilityBool = true.obs;
  void changeVisibilityStatus() {
    visibilityBool.value = !visibilityBool.value;
  }

  RxBool signUpVisibilityBool = true.obs;
  void changeSignUpVisibilityStatus() {
    signUpVisibilityBool.value = !signUpVisibilityBool.value;
  }

  RxBool rememberMe = false.obs;
  void changeRemeberMeStatus() {
    rememberMe.value = !rememberMe.value;
  }
}

import 'package:get/get.dart';

class AppController extends GetxController {
  static AppController instance = Get.find();
  RxBool isLoginWidgetDisplayed = false.obs;
  RxBool isProfileOwner = false.obs;

  changeDIsplayedAuthWidget() {
    isLoginWidgetDisplayed.value = !isLoginWidgetDisplayed.value;
  }

  hideProfileButton() {
    isProfileOwner.value = !isProfileOwner.value;
  }
}

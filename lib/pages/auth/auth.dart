import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/appcontroller.dart';
import 'package:my_app/pages/auth/login.dart';
import 'package:my_app/pages/auth/signup.dart';
import 'package:my_app/widgets/bottom_text.dart';


class AuthenticationScreen extends StatelessWidget {
  AuthenticationScreen({Key? key}) : super(key: key);
  final AppController _appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Obx(
          () => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: MediaQuery.of(context).size.width / 14),
                Image.asset(
                  "assets/logo.png",
                  width: 210,
                ),
                SizedBox(height: MediaQuery.of(context).size.width / 18),
                Visibility(
                    visible: _appController.isLoginWidgetDisplayed.value,
                    child: const LoginWidget()),
                Visibility(
                    visible: !_appController.isLoginWidgetDisplayed.value,
                    child: const RegistrationWidget()),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: _appController.isLoginWidgetDisplayed.value,
                  child: BottomTextWidget(
                    onTap: () => _appController.changeDIsplayedAuthWidget,
                    text1: "Don't have an account?",
                    text2: "Create account!",
                  ),
                ),
                 Visibility(
                  visible: !_appController.isLoginWidgetDisplayed.value,
                  child: BottomTextWidget(
                    onTap: () => _appController.changeDIsplayedAuthWidget,
                    text1: "Already have an account?",
                    text2: "Sign in!!",
                  ),
                ),
                
              ],
            ),
          ),
        ));
  }
}

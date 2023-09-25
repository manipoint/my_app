import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/controllers/app_provider.dart';
import 'package:my_app/controllers/comment_controller.dart';


import 'constent/const.dart';
import 'constent/controllers.dart';
import 'constent/firebase.dart';
import 'controllers/activitycontroller.dart';
import 'controllers/appcontroller.dart';
import 'controllers/auth_controller.dart';
import 'controllers/post_controller.dart';
import 'pages/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initialization.then((value) {
    Get.put(AppController());
    Get.put(AuthController());
    Get.put(AppProvider());
    Get.put(PostController());
    Get.put(CommentController());
    Get.put(ActivityFeedController());
    //Get.put(ProfileController());
  });
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      key: appProvider.key,
      debugShowCheckedModeBanner: false,
      navigatorKey: appProvider.navigatorKey,
      title: Constants.appName,
      theme: appProvider.theme,
      darkTheme: Constants.darkTheme,
      home: const SplashScreen(),
    );
  }
}

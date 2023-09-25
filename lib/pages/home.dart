import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/pages/activity_feed.dart';
import 'package:my_app/pages/profile.dart';
import 'package:my_app/pages/search.dart';
import 'package:my_app/pages/timeline.dart';
import 'package:my_app/pages/upload.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  PageController? pageController;
  int pageIndex = 0;


  @override
  void initState() {
    super.initState();
    pageController = PageController();
   
  }
  @override
  void dispose() {
    pageController!.dispose();
    super.dispose();
  }


  onPageChanged(int pageIndex) {
    setState(() {
      this.pageIndex = pageIndex;
    });
  }

  onTap(int pageIndex) {
    pageController!.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildAuthScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Timeline(userModel: authController.userModel.value,),
          ActivityFeed(currentUser: authController.firebaseUser.value!.uid,userModel: authController.userModel.value),
          Upload(),
          SearchPage(),
          Profile(user: authController.userModel.value),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
          currentIndex: pageIndex,
          onTap: onTap,
          activeColor: Colors.amber,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.whatshot)),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active)),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 35.0,
              ),
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search)),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle)),
          ]),
    );
  }
  @override
  Widget build(BuildContext context) {
    return buildAuthScreen();
  }
}

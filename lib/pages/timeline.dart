import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/models/post_model.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/widgets/header.dart';
import 'package:my_app/widgets/post.dart';
import 'package:my_app/widgets/progress.dart';

class Timeline extends StatelessWidget {
  final UserModel userModel;
  Timeline({Key? key, required this.userModel}) : super(key: key);

  RxList<PostModel>? posts = <PostModel>[].obs;
  RxList<String> followingList = <String>[].obs;

  getTimelinePost() async {
    List<PostModel> ref = await timelineRef
        .doc(auth.currentUser!.uid)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get()
        .then((value) =>
            value.docs.map((e) => PostModel.fromJson(e.data())).toList());

    posts!.value = ref;
  }

  Widget buildTimeLine() {
    if (posts!.isEmpty) {
      return circularProgress();
    } else {
      return Obx(() => ListView.builder(
          shrinkWrap: true,
          itemCount: posts!.length,
          itemBuilder: (BuildContext _, index) {
            return Obx(() => Post(
                  postModel: posts![index],
                  userModel: userModel.obs,
                ));
          }));
    }
  }

  // getFollowing() async {
  //   QuerySnapshot snapshot = await followingRef
  //       .doc(auth.currentUser!.uid)
  //       .collection('userFollowing')
  //       .get();

  //   followingList.value = snapshot.docs.map((doc) => doc.id).toList();
  // }

  // buildUsersToFollow() {
  //   List<UserModel> userModel = authController.limtedUsers;
  //   List<UserResult> userResults = [];
  //   for (var element in userModel) {
  //     final bool isAuthUser = auth.currentUser!.uid == element.id;
  //     final bool isFollowingUser = followingList.contains(element.id);
  //     if (isAuthUser) {
  //       return;
  //     } else if (isFollowingUser) {
  //       return;
  //     } else {
  //       UserResult userResult = UserResult(element);
  //       userResults.add(userResult);
  //     }
  //   }
  //   return Container(
  //     color: Colors.pink,
  //     child: Column(
  //       children: [
  //         Container(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: const [
  //               Icon(
  //                 Icons.person_add,
  //                 color: Colors.black,
  //                 size: 30.0,
  //               ),
  //               SizedBox(
  //                 width: 8.0,
  //               ),
  //               Text(
  //                 "Users to Follow",
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 30.0,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Column(children: userResults),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    getTimelinePost();
   // getFollowing();
buildTimeLine();
    return Scaffold(
        appBar: header(context, isAppTitle: true, titleText: ''),
        body: Obx(() => RefreshIndicator(
            onRefresh: () => getTimelinePost(), child: buildTimeLine())));
  }
}

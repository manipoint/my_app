// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:my_app/constent/controllers.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/models/post_model.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/widgets/custom_text.dart';
import 'package:my_app/widgets/header.dart';
import 'package:my_app/widgets/post.dart';
import 'package:my_app/widgets/post_tile.dart';

import 'edit_profile.dart';

class Profile extends StatelessWidget {
  //String currentUser;
  final UserModel? user;
  Profile({
    Key? key,
    this.user,
  }) : super(key: key);

  Rx<bool> isFollowing = false.obs;
  RxString? postOrientation = "grid".obs;
  RxInt postCount = 0.obs;
  RxInt followerCount = 0.obs;
  RxInt followingCount = 0.obs;

  @override
  Widget build(BuildContext context) {
    checkIfFollowing();
    getProfilePosts();
    getFollowers();
    getFollowing();

    return Scaffold(
        appBar: header(context, titleText: "Profile"),
        body: SingleChildScrollView(
            child: Column(
          children: [
            buildProfileHeader(),
            const Divider(
              height: 0.0,
            ),
            buildPostOrientation(),
            const Divider(
              height: 0.0,
            ),
            Obx(() => buildProfilePost()),
          ],
        )));
  }

  buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user!.photoUrl!),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Obx(() => buildCountColumn("Posts", postCount.value)),
                        Obx(() =>
                            buildCountColumn("followers", followerCount.value)),
                        Obx(() => buildCountColumn(
                            "following", followingCount.value)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(() => buildProfileButton()),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 12.0),
            child: Text(
              user!.username!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              user!.displayName!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(
              user!.bio!,
            ),
          ),
        ],
      ),
    );
  }

  buildCountColumn(String lable, int? count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          text: count.toString(),
          size: 22,
          weight: FontWeight.bold,
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: CustomText(
            text: lable,
            color: Colors.grey,
            size: 15,
            weight: FontWeight.w400,
          ),
        )
      ],
    );
  }

  buildPostOrientation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Obx(
          () => IconButton(
            onPressed: () => setPostOrientation("grid"),
            icon: const Icon(Icons.grid_on),
            color: postOrientation!.value == 'grid'
                ? Colors.deepOrange
                : Colors.grey,
          ),
        ),
        Obx(
          () => IconButton(
            onPressed: () => setPostOrientation("list"),
            icon: const Icon(Icons.list),
            color: postOrientation!.value == 'list'
                ? Colors.deepOrange
                : Colors.grey,
          ),
        )
      ],
    );
  }

  setPostOrientation(String? s) {
    postOrientation!.value = s!;
  }

  buildProfilePost() {
    if (postOrientation!.value == 'grid') {
      return StreamBuilder<List<PostModel>>(
          stream: postController.getAllPostDescending(user!.id!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            List<GridTile> gridTiles = [];
            for (var post in snapshot.data!) {
              gridTiles.add(GridTile(child: PostTile(post: post)));
            }

            return GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              mainAxisSpacing: 1.5,
              crossAxisSpacing: 1.5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: gridTiles,
            );
          });
    } else if (postOrientation!.value == 'list') {
      return StreamBuilder<List<PostModel>>(
          stream: postController.getAllPostDescending(user!.id!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }

            return ListView.builder(
                shrinkWrap: true,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext _, index) {
                  return Post(
                    postModel: snapshot.data![index],
                    userModel: user!.obs,
                  );
                });
          });
    }
  }

  Future<int> getProfilePosts() async {
    QuerySnapshot snapshot = await postsRef
        .doc(user!.id)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();

    return postCount.value = snapshot.docs.length;
  }

  Future<bool> checkIfFollowing() async {
    DocumentSnapshot doc = await followersRef
        .doc(user!.id)
        .collection('userFollowers')
        .doc(auth.currentUser!.uid)
        .get();

    return isFollowing.value = doc.exists;
  }

  Future<int> getFollowers() async {
    QuerySnapshot snapshot =
        await followersRef.doc(user!.id).collection('userFollowers').get();
    return followerCount.value = snapshot.docs.length;
  }

  Future<int> getFollowing() async {
    QuerySnapshot snapshot =
        await followingRef.doc(user!.id).collection('userFollowing').get();
    return followingCount.value = snapshot.docs.length;
  }

  Container buildButton({RxString? text, Function? function}) {
    return Container(
      padding: const EdgeInsets.only(top: 2.0),
      child: TextButton(
        onPressed: () => function!(),
        child: Container(
          width: 230.0,
          height: 27.0,
          child: Text(
            text!.value,
            style: TextStyle(
              color: isFollowing.value ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFollowing.value ? Colors.white : Colors.blue,
            border: Border.all(
              color: isFollowing.value ? Colors.grey : Colors.blue,
            ),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }

  buildProfileButton() {
    // viewing your own profile - should show edit profile button
    bool isProfileOwner = user!.id == auth.currentUser!.uid;
    if (isProfileOwner) {
      return buildButton(
        text: "Edit Profile".obs,
        function: () => Get.to(() => const EditProfile()),
      );
    } else if (isFollowing.value == true) {
      return buildButton(
        text: "Unfollow".obs,
        function: () => handleUnfollowUser(),
      );
    } else if (isFollowing.value == false) {
      return buildButton(
        text: "Follow".obs,
        function: () => handleFollowUser(),
      );
    }
  }

  handleUnfollowUser() async {
    isFollowing.value = false;
    followersRef
        .doc(user!.id)
        .collection('userFollowers')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
    followingRef
        .doc(auth.currentUser!.uid)
        .collection('userFollowing')
        .doc(user!.id)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });

    activityFeedRef
        .doc(user!.id)
        .collection('feedItems')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
    await getFollowing();
    await getFollowers();
  }

  handleFollowUser() async {
    getFollowers();
    getFollowing();
    isFollowing.value = true;
    // Make auth user follower of THAT user (update THEIR followers collection)
    followersRef
        .doc(user!.id)
        .collection('userFollowers')
        .doc(auth.currentUser!.uid)
        .set({});

    authController.followerModel.value= await usersRef
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) => UserModel.fromJson(value.data()!));
   

// Put THAT user on YOUR following collection (update your following collection)
    followingRef
        .doc(auth.currentUser!.uid)
        .collection('userFollowing')
        .doc(user!.id)
        .set({});
    // add activity feed item for that user to notify about new follower (us)
    activityFeedRef
        .doc(user!.id)
        .collection('feedItems')
        .doc(auth.currentUser!.uid)
        .set({
      "type": "follow",
      "ownerId": user!.id,
      "username": authController.followerModel.value.username,
      "userId": authController.followerModel.value.id,
      "userProfileImg": authController.followerModel.value.photoUrl,
      "timestamp": DateTime.now(),
    });
  }
}

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/models/post_model.dart';

class PostController extends GetxController {
  static PostController instance = Get.find();

  //String postCollection = "posts";

  //text controllers
  TextEditingController captionController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  Rx<bool> showHeart = false.obs;


  RxList<PostModel> posts = RxList<PostModel>();
  RxList<PostModel> timeLinePosts = RxList<PostModel>();

  // @override
  // void onInit() {
  //   super.onInit();
  //   handleLikePost(postModel, auth.currentUser!.uid);
  //   updateLikes(postModel, currentUser);
  //   getLikeValue(postModel, currentUser);
  // }

  @override
  void onReady() {
    super.onReady();
    posts.bindStream(getAllPost());
  }

  deletePost({String? postId, String? ownerId}) async {
    // delete post itself
    postsRef
        .doc(ownerId)
        .collection('userPosts')
        .doc(postId)
        .get()
        .then((value) {
      if (value.exists) {
        value.reference.delete();
      }
    });
    // delete uploaded image for the post
    storageRef.child("post_$postId.jpg").delete();
    // then delete all activity feed notifications
    QuerySnapshot activityFeedSnapShot = await activityFeedRef
        .doc(ownerId)
        .collection('feedItems')
        .where('postId', isEqualTo: postId)
        .get();
    for (var element in activityFeedSnapShot.docs) {
      if (element.exists) {
        element.reference.delete();
      }
    }
    // then delete all comments
    QuerySnapshot commentsSnapShot =
        await commentsRef.doc(postId).collection('postcomments').get();
    for (var element in commentsSnapShot.docs) {
      if (element.exists) {
        element.reference.delete();
      }
    }
  }

  updateLikes(PostModel postModel, String currentUser) {
    postsRef
        .doc(postModel.ownerId)
        .collection('userPosts')
        .doc(postModel.postId)
        .update({'likes.$currentUser': false});
    update();
  }

  bool getLikeValue(PostModel? postModel, String currentUser) {
    bool isLiked = postModel!.likes![currentUser] == true;
    return isLiked ? true : false;
  }

  handleLikePost(PostModel? postModel, String currentUser) {
    Rx<bool> isLiked = true.obs;
    isLiked.value = postModel!.likes![currentUser] == true;
    if (isLiked.value) {
      postsRef
          .doc(postModel.ownerId)
          .collection('userPosts')
          .doc(postModel.postId)
          .update({'likes.$currentUser': false});
      removeLikeFromActivityFeed(currentUser, postModel);
      showHeart = false.obs;
    } else if (!isLiked.value) {
      postsRef
          .doc(postModel.ownerId)
          .collection('userPosts')
          .doc(postModel.postId)
          .update({'likes.$currentUser': true});
      addLikeToActivityFeed(currentUser, postModel);
      showHeart = true.obs;
    }

    Timer(const Duration(milliseconds: 500), () {
      showHeart.value = false;
    });
    update();
  }

  addLikeToActivityFeed(String currentUser, PostModel postModel) {
    bool isNotPostOwner = currentUser != postModel.ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(postModel.ownerId)
          .collection("feedItems")
          .doc(postModel.postId)
          .set({
        "type": "like",
        "username": authController.userModel.value.username,
        "userId": authController.userModel.value.id,
        "userProfileImg": authController.userModel.value.photoUrl,
        "postId": postModel.postId,
        "mediaUrl": postModel.mediaUrl,
        "timestamp": DateTime.now(),
      });
    }
    update();
  }

  removeLikeFromActivityFeed(String currentUserId, PostModel postModel) {
    bool isNotPostOwner = currentUserId != postModel.ownerId;
    if (isNotPostOwner) {
      activityFeedRef
          .doc(postModel.ownerId)
          .collection("feedItems")
          .doc(postModel.postId)
          .get()
          .then((doc) {
        if (doc.exists) {
          doc.reference.delete();
        }
      });
    }
  }

  Rx<int> getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0.obs;
    }
    RxInt count = 0.obs;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    update();
    return count;
  }

  Stream<List<PostModel>> getAllPostDescending(String postId) {
    return postsRef
        .doc(postId)
        .collection("userPosts")
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((event) =>
            event.docs.map((e) => PostModel.fromJson(e.data())).toList());
  }

  getAllPost() => postsRef
      .doc(authController.userModel.value.id)
      .collection("userPosts")
      .snapshots()
      .map((event) =>
          event.docs.map((e) => PostModel.fromJson(e.data())).toList());
}

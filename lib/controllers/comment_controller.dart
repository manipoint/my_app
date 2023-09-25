import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/models/comment_model.dart';
import 'package:my_app/models/post_model.dart';

class CommentController extends GetxController {
  static CommentController instance = Get.find();
  //String commentCollection = "comments";
  TextEditingController comment = TextEditingController();

  addComment(PostModel postModel) {
    commentsRef
        .doc(postModel.postId)
        .collection("postcomments")
        .add({
      "username": authController.userModel.value.username,
      "userId": authController.userModel.value.id,
      "avatarUrl": authController.userModel.value.photoUrl,
      "comment": comment.text,
      "timestamp": DateTime.now(),
    });
    activityFeedRef
        .doc(postModel.ownerId)
        .collection("feedItems")
        .add({
      "type": "comment",
      "commentData": comment.text,
      "timestamp": DateTime.now(),
      "postId": postModel.postId,
      "userId": authController.userModel.value.id,
      "username": authController.userModel.value.username,
      "userProfileImg": authController.userModel.value.photoUrl,
      "mediaUrl": postModel.mediaUrl,
    });
    comment.clear();
  }

  Stream<List<CommentModel>> getAllComment(String postId) => commentsRef
      .doc(postId)
      .collection("postcomments")
      .snapshots()
      .map((event) =>
          event.docs.map((e) => CommentModel.fromJson(e.data())).toList());
}

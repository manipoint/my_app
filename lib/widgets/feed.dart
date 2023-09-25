import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/models/comment_model.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/pages/post_screen.dart';
import 'package:my_app/pages/profile.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class Feed extends StatelessWidget {
  final ActivityFeedModel activityFeedModel;
  final UserModel user;
  Feed({Key? key, required this.activityFeedModel,required this.user}) : super(key: key);
  Widget? mediaPreview;
  String? activityItemText;
  @override
  Widget build(BuildContext context) {
    configureMediaPreview();
    return Padding(
      padding: const EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(
            onTap: () => Get.to(
              Profile(user: user),
            ),
            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: activityFeedModel.username,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: "$activityItemText"),
                ],
                style: const TextStyle(fontSize: 14.0, color: Colors.black),
              ),
            ),
          ),
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(activityFeedModel.userProfileImg!),
          ),
          subtitle: Text(
            timeago.format(activityFeedModel.timestamp!.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  configureMediaPreview() {
    if (activityFeedModel.type == "like" ||
        activityFeedModel.type == "comment") {
      mediaPreview = GestureDetector(
        onTap: () => Get.to(
          PostScreen(
            postId: activityFeedModel.postId,
            userId: activityFeedModel.userId,
          ),
        ),
        child: SizedBox(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                      CachedNetworkImageProvider(activityFeedModel.mediaUrl!),
                ),
              ),
            ),
          ),
        ),
      );
    } else {
      mediaPreview = const Text(" ");
    }
    if (activityFeedModel.type == 'like') {
      activityItemText = " liked your post";
    } else if (activityFeedModel.type == 'follow') {
      activityItemText = " is following you";
    } else if (activityFeedModel.type == 'comment') {
      activityItemText = ' comment: ${activityFeedModel.commentData}';
    } else {
      activityItemText = "Error: Unknown type ${activityFeedModel.type}";
    }
  }
}

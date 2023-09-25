import 'package:animator/animator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/constent/firebase.dart';
import 'package:my_app/models/post_model.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/pages/comments.dart';
import 'package:my_app/pages/profile.dart';
import 'package:my_app/widgets/custom_image.dart';
import 'package:my_app/widgets/progress.dart';

class Post extends StatelessWidget {
  final PostModel postModel;
  final Rx<UserModel> userModel;
  const Post({
    Key? key,
    required this.postModel,
    required this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            buildPostHeader(),
            buildPostImage(),
           buildPostFooter(),
          ],
        ),
      ),
    );
  }

  buildPostHeader() {
    return FutureBuilder(
      future: usersRef.doc(postModel.ownerId).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return circularProgress();
        }
        Map<String, dynamic> user =
            snapshot.data!.data() as Map<String, dynamic>;
        UserModel userData = UserModel.fromJson(user);
        bool isPostOwner = auth.currentUser!.uid == postModel.ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(userData.photoUrl!),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => Get.to(() => Profile(
                  user: userData,
                )),
            child: Text(
              postModel.username!,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(postModel.location!),
          trailing: isPostOwner
              ? IconButton(
                  onPressed: () => handleDeletePost(context),
                  icon: const Icon(Icons.more_vert),
                )
              : const Text(''),
        );
      },
    );
  }

  buildPostImage() {
    return Obx(() => GestureDetector(
          onTap: () =>
              postController.handleLikePost(postModel, auth.currentUser!.uid),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              cachedNetworkImage(postModel.mediaUrl!),
              postController.showHeart.value
                  ? Animator(
                      tween: Tween(begin: 0.8, end: 1.4),
                      duration: const Duration(milliseconds: 2),
                      curve: Curves.elasticOut,
                      builder: (_, anim, child) => Transform.scale(
                        scale: 2.0,
                        child: const Icon(
                          Icons.favorite,
                          size: 80.0,
                          color: Colors.red,
                        ),
                      ),
                    )
                  : const Text("")
            ],
          ),
        ));
  }

  buildPostFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(top: 40.0, left: 20.0)),
            IconButton(
              icon: Icon(
                    postController.getLikeValue(
                            postModel, auth.currentUser!.uid)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 28.0,
                    color: Colors.pink,
                  ),
              onPressed: () => postController.handleLikePost(
                  postModel, auth.currentUser!.uid),
            ),
            const Padding(padding: EdgeInsets.only(right: 20.0)),
            GestureDetector(
              onTap: () => showComments(
                  postId: postModel.postId,
                  ownerId: postModel.ownerId,
                  mediaUrl: postModel.mediaUrl),
              child: Icon(
                Icons.chat,
                size: 28.0,
                color: Colors.blue[900],
              ),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Obx(() => Container(
                  margin: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    postController.getLikeCount(postModel.likes!).toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 20.0),
              child: Text(
                postModel.username!,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Text(postModel.description!),
            ),
          ],
        ),
      ],
    );
  }

  showComments({String? postId, String? ownerId, String? mediaUrl}) {
    Get.to(() => Comments(
          postModel: postModel,
        ));
  }

  handleDeletePost(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Remove this post?"),
            children: <Widget>[
              SimpleDialogOption(
                  onPressed: () {
                    Navigator.pop(context);
                    postController.deletePost(
                        postId: postModel.postId,
                        ownerId: auth.currentUser!.uid);
                  },
                  child: const Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  )),
              SimpleDialogOption(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel')),
            ],
          );
        });
  }
}

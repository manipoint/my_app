import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter/material.dart';
import 'package:my_app/constent/controllers.dart';
import 'package:my_app/models/comment_model.dart';
import 'package:my_app/models/post_model.dart';
import 'package:my_app/widgets/header.dart';

class Comments extends StatelessWidget {
  final PostModel postModel;

  const Comments({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, titleText: "Comments"),
      body: Column(
        children: [
          Expanded(
              child: StreamBuilder<List<CommentModel>>(
                  stream: commentController.getAllComment(postModel.postId!),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Comment(
                            commentModel: snapshot.data![index],
                          );
                        });
                  })),
          const Divider(),
          ListTile(
            title: Container(
              margin: const EdgeInsets.only(bottom: 20),
              //height: 40,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                 // color: Colors.grey.withOpacity(.3),
                ),
              child: Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: TextField(
                  controller: commentController.comment,
                  decoration:
                      const InputDecoration(
                        border: InputBorder.none,
                        labelText: "Write a comment..."),
                ),
              ),
            ),
            trailing: OutlinedButton(
              style:OutlinedButton.styleFrom(
                primary: Colors.white,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ) ,
              onPressed: () => commentController.addComment(postModel),
              child: const Text("Post"),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final CommentModel? commentModel;

 
  const Comment({Key? key,this.commentModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(commentModel!.comment!),
          leading: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(commentModel!.avatarUrl!),
          ),
          subtitle: Text(timeago.format(commentModel!.timestamp!.toDate())),
        ),
        const Divider(),
      ],
    );
  }
}

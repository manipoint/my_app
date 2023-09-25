import 'package:flutter/material.dart';

class PostScreen extends StatelessWidget {
  final String? userId;
  final String? postId;
  const PostScreen({Key? key, this.userId, this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Post Screen");
  }
}

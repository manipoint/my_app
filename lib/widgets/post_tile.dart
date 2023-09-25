import 'package:flutter/material.dart';
import 'package:my_app/models/post_model.dart';

import 'custom_image.dart';

class PostTile extends StatelessWidget {
  final PostModel? post;

  const PostTile({Key? key,this.post}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('showing post'),
      child: cachedNetworkImage(post!.mediaUrl!),
    );
  }
}

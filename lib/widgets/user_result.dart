import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_app/models/user.dart';
import 'package:my_app/pages/profile.dart';

class UserResult extends StatelessWidget {
  final UserModel user;

  UserResult(this.user);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor.withOpacity(0.7),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Profile(
              user: user,
            ),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: CachedNetworkImageProvider(user.photoUrl!),
              ),
              title: Text(
                user.displayName!,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                user.username!,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const Divider(
            height: 2.0,
            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}
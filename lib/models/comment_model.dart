import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? username;
  String? userId;
  String? avatarUrl;
  String? comment;
  Timestamp? timestamp;

  CommentModel(
      {this.username,
      this.userId,
      this.avatarUrl,
      this.comment,
      this.timestamp});
  CommentModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['userId'];
    avatarUrl = json['avatarUrl'];
    comment = json['comment'];
    timestamp = json['timestamp'];
  }
}

class ActivityFeedModel {
  String? username;
  String? userId;
  String? type; // 'like', 'follow', 'comment'
  String? mediaUrl;
  String? postId;
  String? userProfileImg;
  String? commentData;
  Timestamp? timestamp;

  ActivityFeedModel({
    this.username,
    this.userId,
    this.type,
    this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this.timestamp,
  });
  ActivityFeedModel.fromJson(Map<String, dynamic> data) {
    username = data["username"];
    userId = data["userId"];
    type = data["type"];
    mediaUrl = data["mediaUrl"];
    postId = data["postId"];
    userProfileImg = data["userProfileImg"];
    commentData = data["commentData"];
    timestamp = data["timestamp"];
  }
}

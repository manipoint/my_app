class PostModel {
  String? postId;
  String? ownerId;
  String? username;
  String? location;
  String? description;
  String? mediaUrl;
  Map? likes;
  int? timestamp;

  PostModel(
      {this.postId,
      this.ownerId,
      this.username,
      this.location,
      this.description,
      this.mediaUrl,
      this.timestamp,
      this.likes});
  PostModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    ownerId = json['ownerId'];
    username = json['username'];
    location = json['location'];
    description = json['description'];
    mediaUrl = json['mediaUrl'];
    likes = json['likes'];
    timestamp = json[' timestamp'];
  }

  Map<String, Object?> toJson() {
    return {
      'postId': postId,
      'ownerId': ownerId,
      'username': username,
      'location': location,
      'description': description,
      'mediaUrl': mediaUrl,
      'likes': likes,
      ' timestamp': timestamp,
    };
  }
}

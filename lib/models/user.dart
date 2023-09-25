


class UserModel {
  String? id;
  String? username;
  String? email;
  String? photoUrl;
  String? displayName;
  String? bio;

  UserModel({
    this.id,
    this.username,
    this.email,
    this.photoUrl,
    this.displayName,
    this.bio,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    username = json['userName'];
    photoUrl=json['photoUrl'];
    displayName = json['displayName'];
    bio = json['bio'];
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'email':email,
      'userName': username,
      'photoUrl': photoUrl,
      'displayName':displayName,
      'bio':bio
      
    };
  }
  
}

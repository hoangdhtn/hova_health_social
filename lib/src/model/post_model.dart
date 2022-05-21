import 'package:health_app/src/model/comment_model.dart';
import 'package:health_app/src/model/like_model.dart';
import 'package:health_app/src/model/user_model.dart';

class Post {
  int id;
  String content;
  User user;
  List<Images> posts_imgs;
  List<Like> likes;
  List<Comment> comments;

  Post(
      {this.id,
      this.content,
      this.posts_imgs,
      this.user,
      this.likes,
      this.comments});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      content: json["content"],
      user: User.fromJson(json["user"]),
      // ignore: prefer_null_aware_operators
      posts_imgs: json['posts_imgs'] != null
          ? json['posts_imgs']
              .map<Images>((json) => Images.fromJson(json))
              .toList()
          : null,
      // ignore: prefer_null_aware_operators
      likes: json['likes'] != null
          ? json['likes'].map<Like>((json) => Like.fromJson(json)).toList()
          : null,
      // ignore: prefer_null_aware_operators
      comments: json['posts_Cmts'] != null
          ? json['posts_Cmts']
              .map<Comment>((json) => Comment.fromJson(json))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["content"] = this.content;
    data["posts_imgs"] = this.posts_imgs;
    data["posts_Cmts"] = this.comments;
  }
}

class Images {
  int id;
  String name;

  Images({
    this.id,
    this.name,
  });

  factory Images.fromJson(Map<String, dynamic> json) {
    return Images(
      id: json['id'],
      name: json['name'],
    );
  }
}

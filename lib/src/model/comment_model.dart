import 'package:health_app/src/model/user_model.dart';

class Comment {
  int id;
  String content;
  User user;

  Comment({this.id, this.content, this.user});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      content: json['content'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['user'] = this.user;
  }
}

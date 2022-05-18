class Post {
  int id;
  String content;

  List<Images> posts_imgs;

  Post({
    this.id,
    this.content,
    this.posts_imgs,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      content: json["content"],
      // ignore: prefer_null_aware_operators
      posts_imgs: json['posts_imgs'] != null
          ? json['posts_imgs']
              .map<Images>((json) => Images.fromJson(json))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["content"] = this.content;
    data["posts_imgs"] = this.posts_imgs;
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

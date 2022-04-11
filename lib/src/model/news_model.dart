class News {
  int id;
  String title;
  String content;
  String keyword;
  bool enabled;

  List<Categories> categories;
  List<Images> news_Imgs;

  News({
    this.id,
    this.title,
    this.content,
    this.keyword,
    this.enabled,
    this.categories,
    this.news_Imgs,
  });

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    keyword = json['keyword'];
    enabled = json['enabled'];
    if (json['categories'] != null) {
      List<Categories> categories = [];
      json['images'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }

    if (json['news_Imgs'] != null) {
      List<Images> news_Imgs = [];
      json['news_Imgs'].forEach((v) {
        news_Imgs.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
  }
}

class Categories {
  int id;
  String name;
  bool enabled;

  Categories({this.id, this.name, this.enabled});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['id'],
      name: json['name'],
      enabled: json['enabled'],
    );
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

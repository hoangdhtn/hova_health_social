class Category {
  String name;

  Category({this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(name: json['name']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
  }
}

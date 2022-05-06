class Medical {
  int id;
  int id_user;
  String name;
  String info;
  bool enabled;
  String created_at;
  String updated_at;
  List<Images> listImg;

  Medical({
    this.id,
    this.id_user,
    this.name,
    this.info,
    this.enabled,
    this.created_at,
    this.updated_at,
    this.listImg,
  });

  factory Medical.fromJson(Map<String, dynamic> json) {
    return Medical(
      id: json["id"],
      id_user: json["id_user"],
      name: json["name"],
      info: json["info"],
      enabled: json["enabled"],
      created_at: json["created_at"],
      updated_at: json["updated_at"],
      // ignore: prefer_null_aware_operators
      listImg: json["listImg"] != null
          ? json["listImg"]
              .map<Images>((json) => Images.fromJson(json))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["id_user"] = this.id_user;
    data["name"] = this.name;
    data["info"] = this.info;
    data["enabled"] = this.enabled;
    data["created_at"] = this.created_at;
    data["updated_at"] = this.updated_at;
    data["listImg"] = this.listImg;
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

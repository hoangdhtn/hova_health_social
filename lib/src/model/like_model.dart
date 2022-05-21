class Like {
  int id_user;

  Like({
    this.id_user,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id_user: json["id_user"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id_user"] = this.id_user;
  }
}

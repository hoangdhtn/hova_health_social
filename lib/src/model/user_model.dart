class User {
  int id;
  String username;
  String password;
  String email;
  String full_name;
  int height;
  int weight;
  String avatar_url;
  bool is_active;
  String work_at;
  String location;
  String date;
  String token;

  User({
    this.id,
    this.username,
    this.password,
    this.email,
    this.full_name,
    this.height,
    this.weight,
    this.avatar_url,
    this.is_active,
    this.work_at,
    this.location,
    this.date,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      email: json['email'],
      full_name: json['full_name'],
      height: json['height'],
      weight: json['weight'],
      avatar_url: json['avatar_url'],
      is_active: json['is_active'],
      work_at: json['work_at'],
      location: json['location'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['full_name'] = this.full_name;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['avatar_url'] = this.avatar_url;
    data['is_active'] = this.is_active;
    data['work_at'] = this.work_at;
    data['location'] = this.location;
    data['date'] = this.date;
  }
}

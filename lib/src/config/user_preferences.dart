import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';

class UserPreferences {
  Future<bool> saveUser(User user, String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user.id);
    prefs.setString("username", user.username);
    prefs.setString("password", user.password);
    prefs.setString("email", user.email);
    prefs.setString("full_name", user.full_name);
    prefs.setInt("height", user.height);
    prefs.setInt("weight", user.weight);
    prefs.setString("avatar_url", user.avatar_url);
    prefs.setBool("is_active", user.is_active);
    prefs.setString("work_at", user.work_at);
    prefs.setString("location", user.location);
    user.data_of_birth != null
        ? prefs.setString("date", user.data_of_birth)
        : prefs.setString("date", "1969-07-20");
    prefs.setString("token", token);

    print("object prefere");

    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("id");
    String username = prefs.getString("username");
    String password = prefs.getString("password");
    String email = prefs.getString("email");
    String full_name = prefs.getString("full_name");
    int height = prefs.getInt("height");
    int weight = prefs.getInt("weight");
    String avatar_url = prefs.getString("avatar_url");
    bool is_active = prefs.getBool("is_active");
    String work_at = prefs.getString("work_at");
    String location = prefs.getString("location");
    String date = prefs.getString("date");
    String token = prefs.getString("token");

    return User(
      id: id,
      username: username,
      password: password,
      email: email,
      full_name: full_name,
      height: height,
      weight: weight,
      avatar_url: avatar_url,
      is_active: is_active,
      work_at: work_at,
      location: location,
      data_of_birth: date,
      token: token,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("id");
    prefs.remove("username");
    prefs.remove("password");
    prefs.remove("email");
    prefs.remove("full_name");
    prefs.remove("height");
    prefs.remove("weight");
    prefs.remove("avatar_url");
    prefs.remove("is_active");
    prefs.remove("work_at");
    prefs.remove("location");
    prefs.remove("data_of_birth");
    prefs.remove("token");
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    print("token " + token.toString());
    return token;
  }
}

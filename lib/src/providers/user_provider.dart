import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';
import '../model/user_model.dart';

enum StatusUser {
  NotUpdated,
  Updating,
  Updated,
}

class UserProvider with ChangeNotifier {
  User _user = new User();
  StatusUser _updatedInStatus = StatusUser.NotUpdated;

  User get user => _user;
  StatusUser get updatedInStatus => _updatedInStatus;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  updateUser(String fullname, String height, String weight, XFile fileImg,
      String work, String location, String data_of_birth) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    FormData formData = FormData.fromMap({
      "fullname": fullname,
      "height": height,
      "weight": weight,
      "work_at": work,
      "location": location,
      "data_of_birth": data_of_birth,
      "files": fileImg != null ? fileImg : null,
    });

    _updatedInStatus = StatusUser.Updating;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().put(
        API_URL.users,
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "${tokenA}",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        var userData = response.data;
        User authUser = User.fromJson(userData);
        UserPreferences().saveUser(authUser, tokenA);
        _updatedInStatus = StatusUser.Updated;
        notifyListeners();
        result = true;
      } else {
        _updatedInStatus = StatusUser.NotUpdated;
        notifyListeners();
        result = false;
      }
    } on DioError catch (e) {
      _updatedInStatus = StatusUser.NotUpdated;
      notifyListeners();
      result = false;
    }

    return result;
  }
}

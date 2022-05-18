import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/post_model.dart';
import 'package:image_picker/image_picker.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

enum Status {
  NotCreated,
  Creating,
  Created,
}

class PostProvider extends ChangeNotifier {
  Status _createInStatus = Status.NotCreated;
  Status get createInStatus => _createInStatus;

  getPosts(int pos, int pagesize) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;

    List<Post> listPost = [];

    try {} on DioError catch (e) {}
  }

  addPost(String content, List<XFile> listFiles) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    FormData formData = FormData.fromMap({
      "content": content,
    });
    if (listFiles != null) {
      for (var file in listFiles) {
        formData.files.addAll([
          MapEntry("files",
              await MultipartFile.fromFile(file.path, filename: file.name)),
        ]);
      }
    }

    _createInStatus = Status.Creating;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.post,
        data: formData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "multipart/form-data",
            HttpHeaders.authorizationHeader: "${tokenA}",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        result = true;
        _createInStatus = Status.Created;
        notifyListeners();
      } else {
        result = false;
        _createInStatus = Status.NotCreated;
        notifyListeners();
      }
    } on DioError catch (e) {
      print(e.message);
      result = false;
      _createInStatus = Status.NotCreated;
      notifyListeners();
    }

    return result;
  }
}

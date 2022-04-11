import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/src/model/news_model.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';
import '../model/user_model.dart';

enum Status {
  NotGetNews,
  GetNewsing,
  GetNewsed,
}

class NewsProvider extends ChangeNotifier {
  Status _getnewsInStatus = Status.NotGetNews;

  Status get getnewsInStatus => _getnewsInStatus;

  Future<Map<String, dynamic>> getNews(int position, int pageSize) async {
    var result;
    Future<String> token = UserPreferences().getToken();

    // _getnewsInStatus = Status.GetNewsing;
    // notifyListeners();

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.news + position.toString() + "/" + pageSize.toString(),
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: token.toString(),
          },
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          },
        ),
      );

      print("URL : " +
          API_URL.news +
          position.toString() +
          "/" +
          pageSize.toString());
      // print("====> DATA NEWS : " + response.data.toString());

      if (response.statusCode == 200) {
        result = {
          "status": true,
          "news": response.data,
        };

        print("====> DATA NEWS : " + result.toString());

        // _getnewsInStatus = Status.GetNewsed;
        // notifyListeners();
      } else {
        result = {
          "status": false,
          "news": [],
        };

        print("====> DATA NEWS : " + result.toString());

        // _getnewsInStatus = Status.NotGetNews;
        // notifyListeners();
      }
    } on DioError catch (e) {
      print(e.message);
      // _getnewsInStatus = Status.NotGetNews;
      // notifyListeners();
    }
    return result;
  }
}

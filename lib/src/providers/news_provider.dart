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
  // Status _getnewsInStatus = Status.NotGetNews;

  // Status get getnewsInStatus => _getnewsInStatus;

  getNews(int position, int pageSize) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<News> listNews = [];
    // _getnewsInStatus = Status.GetNewsing;
    // notifyListeners();

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.news + position.toString() + "/" + pageSize.toString(),
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
        final data = response.data;
        listNews.addAll(
          data.map<News>(
            (json) => News.fromJson(json),
          ),
        );
        // _getnewsInStatus = Status.GetNewsed;
        // notifyListeners();
      } else {
        listNews = null;
        // _getnewsInStatus = Status.NotGetNews;
        // notifyListeners();
      }
    } on DioError catch (e) {
      print(e.message);
      // _getnewsInStatus = Status.NotGetNews;
      // notifyListeners();
    }
    print(listNews);
    print(listNews.length);
    return listNews;
  }

  getNewsByCate(int id_cate, int position, int pageSize) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<News> listNews = [];
    // _getnewsInStatus = Status.GetNewsing;
    // notifyListeners();

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.news +
            id_cate.toString() +
            "/" +
            position.toString() +
            "/" +
            pageSize.toString(),
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
        final data = response.data;
        listNews.addAll(
          data.map<News>(
            (json) => News.fromJson(json),
          ),
        );
        // _getnewsInStatus = Status.GetNewsed;
        // notifyListeners();
      } else {
        listNews = null;
        // _getnewsInStatus = Status.NotGetNews;
        // notifyListeners();
      }
    } on DioError catch (e) {
      print(e.message);
      // _getnewsInStatus = Status.NotGetNews;
      // notifyListeners();
    }
    print("LIST NEWS BY ID" + listNews.toString());
    print("LIST NEWS BY ID" + listNews.length.toString());
    return listNews;
  }
}

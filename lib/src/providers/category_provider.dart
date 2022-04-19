import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';
import '../model/category_model.dart';
import '../model/news_model.dart';

class CategoryProvider extends ChangeNotifier {
  getCategory() async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<Category> cateList = [];

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.category,
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
        cateList.addAll(
          data.map<Category>(
            (json) => Category.fromJson(json),
          ),
        );
      } else {
        cateList = null;
      }
    } on DioError catch (e) {
      e.message;
    }
    print("Cate list : " + cateList.toString());
    return cateList;
  }

  getNewsByIdCate(int id, int pos, int pagesize) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;

    List<News> listNews = [];

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.news +
            id.toString() +
            "/" +
            pos.toString() +
            "/" +
            pagesize.toString(),
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
        // listNews = data.addAll(
        //   data.map<News>(
        //     (json) => News.fromJson(json[0]),
        //   ),
        // );
        data.forEach((element) {
          listNews.add(News.fromJson(element[0]));
        });
      } else {
        listNews = null;
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return listNews;
  }
}

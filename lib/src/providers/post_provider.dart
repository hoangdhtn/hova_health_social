import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/comment_model.dart';
import 'package:health_app/src/model/like_model.dart';
import 'package:health_app/src/model/post_model.dart';
import 'package:image_picker/image_picker.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

enum Status {
  NotCreated,
  Creating,
  Created,
  NotDetele,
  Deleting,
  Deleted,
  NotGetComment,
  GetCommenting,
  GetCommented,
  NotComment,
  Commenting,
  Commented,
}

class PostProvider extends ChangeNotifier {
  Status _createInStatus = Status.NotCreated;
  Status get createInStatus => _createInStatus;

  Status _deleteInStatus = Status.NotDetele;
  Status get deleteInStatus => _deleteInStatus;

  Status _getCmtInStatus = Status.NotGetComment;
  Status get getCmtInStatus => _getCmtInStatus;

  Status _cmtInStatus = Status.NotComment;
  Status get cmtInStatus => _cmtInStatus;

  // lấy post của tất cả user
  getPosts(int pos, int pagesize) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;

    List<Post> listPost = [];
    var result;

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.post + "/" + pos.toString() + "/" + pagesize.toString(),
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
        data.forEach((e) {
          listPost.add(Post.fromJson(e));
        });
        result = {
          'status': true,
          'message': 'Successful',
          'listPost': listPost
        };
      } else {
        result = {'status': true, 'message': 'Successful', 'listPost': null};
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return result;
  }

  // Lấy post của user
  getUserPosts(int pos, int pagesize) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    Future<String> id_user = UserPreferences().getId();
    String id_userA = await id_user;

    List<Post> listPost = [];
    var result;

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.post +
            "/user/" +
            id_userA +
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
        data.forEach((e) {
          listPost.add(Post.fromJson(e));
        });
        result = {
          'status': true,
          'message': 'Successful',
          'listPost': listPost
        };
      } else {
        result = {'status': true, 'message': 'Successful', 'listPost': null};
      }
    } on DioError catch (e) {
      print(e.message);
    }

    return result;
  }

  getLikePost(int id_post) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<Like> list = [];

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.like + "/" + id_post.toString(),
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
        data.forEach((e) {
          list.add(Like.fromJson(e));
        });
      } else {
        list = [];
      }
    } on DioError catch (e) {
      print(e.message);
    }
    return list;
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

  deletePost(int id_post) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    _deleteInStatus = Status.Deleting;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().delete(
        API_URL.post + "/${id_post}",
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
        result = true;
        _deleteInStatus = Status.Deleted;
        notifyListeners();
      } else {
        result = false;
        _deleteInStatus = Status.NotDetele;
        notifyListeners();
      }
    } on DioError catch (e) {
      result = false;

      _deleteInStatus = Status.NotDetele;
      notifyListeners();
    }

    return result;
  }

  likePost(int id_post) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.like + "/${id_post}",
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
        result = true;
      } else {
        result = false;
      }
    } on DioError catch (e) {
      result = false;
      print(e.message);
    }
    return result;
  }

  unlikePost(int id_post) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    try {
      var response = Response();
      response = await Dio().delete(
        API_URL.like + "/${id_post}",
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
        result = true;
      } else {
        result = false;
      }
    } on DioError catch (e) {
      result = false;
      print(e.message);
    }
    return result;
  }

  getComment(int id_post) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;
    List<Comment> list = [];

    _getCmtInStatus = Status.GetCommenting;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.comment + "/${id_post}",
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
        var data = response.data;
        data.map((e) {
          list.add(Comment.fromJson(e));
        });
      } else {
        list = [];
      }
    } on DioError catch (e) {
      list = [];
    }

    return list;
  }

  commentPost(int id_post, String content) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;
    var form = {
      "content": content,
    };

    _cmtInStatus = Status.Commenting;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.comment + "/${id_post}",
        data: form,
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
        result = true;
        _cmtInStatus = Status.Commented;
        notifyListeners();
      } else {
        _cmtInStatus = Status.NotComment;
        notifyListeners();
      }
    } on DioError catch (e) {
      _cmtInStatus = Status.NotComment;
      notifyListeners();
    }

    return result;
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/src/config/user_preferences.dart';
import 'package:image_picker/image_picker.dart';

import '../config/api_url.dart';
import '../model/user_model.dart';
// import 'package:http/http.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut,
  NotSentMail,
  SentMailing,
  SentMail,
  NotResetPassword,
  ResetPasswording,
  ResetPassworded
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;
  Status _sentmailInStatus = Status.NotSentMail;
  Status _resetpassInStatus = Status.NotResetPassword;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;
  Status get sentmailInStatus => _sentmailInStatus;
  Status get resetpassInStatus => _resetpassInStatus;

  Future<Map<String, dynamic>> login(String username, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'username': username,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.login,
        data: loginData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          },
        ),
      );

      print("RES" + response.toString());
      if (response.statusCode == 200) {
        // print("TOKEN " + token.toString());
        // print("User " + response.data['user'].toString());

        var userData = response.data['user'];
        String token = response.data['token'];
        User authUser = User.fromJson(userData);
        UserPreferences().saveUser(authUser, token);

        _loggedInStatus = Status.LoggedIn;
        notifyListeners();

        result = {'status': true, 'message': 'Successful', 'user': authUser};
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {
          'status': false,
          'message': 'Tài khoản hoặc mật khẩu không đúng!'
        };
      }
    } catch (e) {
      print("ERROR" + e.message);
    }
    print(result);
    return result;
  }

  Future<Map<String, dynamic>> register(
      String email, String username, String password) async {
    var result;

    final Map<String, dynamic> registerData = {
      'email': email,
      'username': username,
      'password': password
    };

    _registeredInStatus = Status.Registering;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.signup,
        data: registerData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        result = {
          'status': true,
          'message': 'Đăng kí thành công, mời bạn đăng nhập'
        };
        _registeredInStatus = Status.Registered;
        notifyListeners();
      } else {
        result = {
          'status': false,
          'message': 'Tài khoản hoặc email đã có người sử dụng'
        };
        _registeredInStatus = Status.NotRegistered;
        notifyListeners();
      }
    } catch (e) {
      print("ERROR " + e.toString());
      _registeredInStatus = Status.NotRegistered;
      notifyListeners();
    }
    print("AAAAA" + registerData.toString());
    return result;
  }

  Future<Map<String, dynamic>> sentMail(String email) async {
    var result;

    final Map<String, dynamic> sentmailData = {
      'email': email,
    };

    _sentmailInStatus = Status.SentMailing;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.sentmail,
        data: sentmailData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        result = {
          "status": true,
          "message": "Gửi mail thành công, vui lòng kiểm tra email"
        };

        _sentmailInStatus = Status.SentMail;
        notifyListeners();
      } else {
        result = {
          "status": false,
          "message": "Gửi mail thất bại, vui lòng kiểm tra email"
        };

        _sentmailInStatus = Status.NotSentMail;
        notifyListeners();
      }
    } on DioError catch (e) {
      print(e.message);
      _sentmailInStatus = Status.NotSentMail;
      notifyListeners();
    }

    return result;
  }

  Future<Map<String, dynamic>> ressetPass(
      String email, String keyMail, String pass) async {
    var result;

    final Map<String, dynamic> resetPassData = {
      "key": keyMail,
      "email": email,
      "passwordNew": pass
    };

    _resetpassInStatus = Status.ResetPasswording;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.resetpassword,
        data: resetPassData,
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
          followRedirects: false,
          validateStatus: (status) {
            return status <= 500;
          },
        ),
      );

      if (response.statusCode == 200) {
        result = {
          "status": true,
          "message": "Đổi mật khẩu thành công, mời đăng nhập"
        };

        _resetpassInStatus = Status.ResetPassworded;
        notifyListeners();
      } else {
        result = {"status": false, "message": "Đổi mật khẩu thất bại"};

        _resetpassInStatus = Status.NotResetPassword;
        notifyListeners();
      }
    } on DioError catch (e) {
      print(e.message);
      _resetpassInStatus = Status.NotResetPassword;
      notifyListeners();
    }

    return result;
  }

  // updateUser(String fullname, String height, String weight, XFile fileImg,
  //     String work, String location, String data_of_birth) async {
  //   Future<String> token = UserPreferences().getToken();
  //   String tokenA = await token;
  //   bool result;

  //   FormData formData = FormData.fromMap({
  //     "fullname": fullname,
  //     "height": height,
  //     "weight": weight,
  //     "work_at": work,
  //     "location": location,
  //     "data_of_birth": data_of_birth,
  //   });
  //   if (fileImg != null) {
  //     formData.files.addAll([
  //       MapEntry("files",
  //           await MultipartFile.fromFile(fileImg.path, filename: fileImg.name)),
  //     ]);
  //   }

  //   _updatedInStatus = Status.Updating;
  //   notifyListeners();

  //   try {
  //     var response = Response();
  //     response = await Dio().put(
  //       API_URL.users,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           HttpHeaders.contentTypeHeader: "application/json",
  //         },
  //         followRedirects: false,
  //         validateStatus: (status) {
  //           return status <= 500;
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       var userData = response.data;
  //       User authUser = User.fromJson(userData);
  //       UserPreferences().saveUser(authUser, tokenA);
  //       _updatedInStatus = Status.Updated;
  //       notifyListeners();
  //       result = true;
  //     } else {
  //       _updatedInStatus = Status.NotUpdated;
  //       notifyListeners();
  //       result = false;
  //     }
  //   } on DioError catch (e) {
  //     _updatedInStatus = Status.NotUpdated;
  //     notifyListeners();
  //     result = false;
  //   }

  //   return result;
  // }
}

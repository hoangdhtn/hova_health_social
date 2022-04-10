import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/src/config/user_preferences.dart';

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
  LoggedOut
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredInStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredInStatus => _registeredInStatus;

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
        String token = response.data['token'];
        // print("TOKEN " + token.toString());
        // print("User " + response.data['user'].toString());

        var userData = response.data['user'];
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
        result = {'status': true, 'message': 'Successful'};
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
}

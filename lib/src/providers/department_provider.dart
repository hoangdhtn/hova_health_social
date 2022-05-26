import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/department_model.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

class DepartmentProvider extends ChangeNotifier {
  getDepartment() async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<Department> departmentList = [];

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.departments,
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
        departmentList.addAll(
          data.map<Department>(
            (json) => Department.fromJson(json),
          ),
        );
      } else {
        departmentList = null;
      }
    } on DioError catch (e) {
      e.message;
    }
    print("Department list : " + departmentList.toString());
    return departmentList;
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/doctor_model.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

class DoctorProvider extends ChangeNotifier {
  getListDoctor(int id_department) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<Doctor> doctorList = [];

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.doctors + "/${id_department}",
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
        doctorList.addAll(
          data.map<Doctor>(
            (json) => Doctor.fromJson(json),
          ),
        );
      } else {
        doctorList = null;
      }
    } on DioError catch (e) {
      e.message;
    }
    print("doctor list : " + doctorList.toString());
    return doctorList;
  }
}

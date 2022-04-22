import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/src/model/medical_model.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

class MedicalProvider extends ChangeNotifier {
  getMedical(int pos, int pagesize) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;

    List<Medical> listMedical = [];

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.medical + "/" + pos.toString() + "/" + pagesize.toString(),
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
          listMedical.add(Medical.fromJson(e));
        });
      } else {
        listMedical = null;
      }
    } on DioError catch (e) {
      print(e.message);
      listMedical = null;
    }
    print("MEDICAL : " + listMedical.toString());
    print("MEDICAL : " + listMedical.length.toString());
    return listMedical;
  }

  getDetailMedical(int id) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;

    Medical result = new Medical();

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.medical + "/" + id.toString(),
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
        result = response.data;
      } else {
        result = null;
      }
    } on DioError catch (e) {
      print(e.message);
      result = null;
    }

    return result;
  }
}

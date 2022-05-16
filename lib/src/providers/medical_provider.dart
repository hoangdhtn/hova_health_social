import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:health_app/src/model/medical_model.dart';
import 'package:image_picker/image_picker.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

enum Status {
  NotUpdated,
  Updating,
  Updated,
  NotDelete,
  Deleting,
  Deleted,
  NotCreated,
  Creating,
  Created,
}

class MedicalProvider extends ChangeNotifier {
  Status _updateInStatus = Status.NotUpdated;
  Status get updateInStatus => _updateInStatus;

  Status _deleteInStatus = Status.NotDelete;
  Status get deleteInStatus => _deleteInStatus;

  Status _createInStatus = Status.NotCreated;
  Status get createInStatus => _createInStatus;

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

  updateMedical(String id, String name, String info, String created,
      String updated) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;

    Medical result;

    final Map<String, dynamic> medicalData = {
      'id': id,
      'name': name,
      'info': info,
      'created_at': created,
      'updated_at': updated
    };

    _updateInStatus = Status.Updating;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().put(
        API_URL.medical,
        data: medicalData,
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
        result = Medical.fromJson(response.data);

        _updateInStatus = Status.Updated;
        notifyListeners();
      } else {
        result = null;
        _updateInStatus = Status.NotUpdated;
        notifyListeners();
      }
    } on DioError catch (e) {
      result = null;
      _updateInStatus = Status.NotUpdated;
      notifyListeners();
      print(e.message);
    }

    return result;
  }

  deleteMedical(String id) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;

    bool result = true;

    _deleteInStatus = Status.Deleting;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().delete(
        API_URL.medical + "/${id}",
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
        debugPrint("Â" + response.statusCode.toString());
        _deleteInStatus = Status.Deleted;
        notifyListeners();
        result = true;
      } else {
        _deleteInStatus = Status.NotDelete;
        notifyListeners();
        result = false;
      }
    } on DioError catch (e) {
      _deleteInStatus = Status.NotDelete;
      notifyListeners();
      result = false;
      print(e.message);
    }

    return result;
  }

  createMedical(String name, String info, String created, String updated,
      List<XFile> listFiles) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    FormData formData = FormData.fromMap({
      "name": name,
      "info": info,
      "created_at": created,
      "updated_at": updated,
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
        API_URL.medical,
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
        print("Add thành công");
        _createInStatus = Status.Created;
        notifyListeners();
        result = true;
      } else {
        print("Add thất bại");
        _createInStatus = Status.NotCreated;
        notifyListeners();
        result = false;
      }
    } on DioError catch (e) {
      print(e.message);
      result = false;
    }

    return result;
  }
}

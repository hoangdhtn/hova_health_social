import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/slots_vailable.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

enum Status {
  NotGetBooking,
  GetBooking,
  GetBooked,
}

class BookingProvider extends ChangeNotifier {
  Status _bookingInStatus = Status.NotGetBooking;
  Status get bookingInStatus => _bookingInStatus;

  getListBookingAvai(int id_doctor, String date) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<SlotsAvailable> slotsAvaiList = [];

    FormData formData = FormData.fromMap({
      "date": date,
    });

    _bookingInStatus = Status.GetBooking;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.slots + "/available/${id_doctor}",
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
        final data = response.data;
        slotsAvaiList.addAll(
          data.map<SlotsAvailable>(
            (json) => SlotsAvailable.fromJson(json),
          ),
        );

        _bookingInStatus = Status.GetBooked;
        notifyListeners();
      } else {
        slotsAvaiList = null;
        _bookingInStatus = Status.GetBooked;
        notifyListeners();
      }
    } on DioError catch (e) {
      _bookingInStatus = Status.NotGetBooking;
      notifyListeners();
      e.message;
    }
    print("slotsAvaiList list : " + slotsAvaiList.toString());
    return slotsAvaiList;
  }
}

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/booking_model.dart';
import 'package:health_app/src/model/slots_vailable.dart';

import '../config/api_url.dart';
import '../config/user_preferences.dart';

enum Status {
  NotGetBooking,
  GetBooking,
  GetBooked,
  NotBooking,
  Booking,
  Booked,
}

class BookingProvider extends ChangeNotifier {
  Status _bookingInStatus = Status.NotGetBooking;
  Status get bookingInStatus => _bookingInStatus;

  Status _addbookingInStatus = Status.NotBooking;
  Status get addbookingInStatus => _addbookingInStatus;

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
    //print("slotsAvaiList list : " + slotsAvaiList.toString());
    return slotsAvaiList;
  }

  getListBookingUser() async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    List<Booking> bookingList = [];
    var result;

    try {
      var response = Response();
      response = await Dio().get(
        API_URL.slots + "/user",
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
        bookingList.addAll(
          data.map<Booking>(
            (json) => Booking.fromJson(json),
          ),
        );
      } else {
        bookingList = null;
      }
    } on DioError catch (e) {
      bookingList = null;
      e.message;
    }
    //print("slotsAvaiList list : " + slotsAvaiList.toString());
    return bookingList;
  }

  bookingSlot(String date, String begin_at, String end_at, String index_day,
      String order_info, String doctor_id) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    final Map<String, dynamic> bookingData = {
      'date': date,
      'begin_at': begin_at,
      'end_at': end_at,
      'index_day': index_day,
      'order_info': order_info,
      "doctor": {"id": doctor_id}
    };

    _addbookingInStatus = Status.GetBooking;
    notifyListeners();

    try {
      var response = Response();
      response = await Dio().post(
        API_URL.slots,
        data: bookingData,
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
        _addbookingInStatus = Status.Booked;
        notifyListeners();
      } else {
        result = false;
        _addbookingInStatus = Status.NotBooking;
        notifyListeners();
      }
    } on DioError catch (e) {
      result = false;
      _addbookingInStatus = Status.NotBooking;
      notifyListeners();
      e.message;
    }
    //print("slotsAvaiList list : " + slotsAvaiList.toString());
    return result;
  }

  deleteBookingUser(int id_booking) async {
    Future<String> token = UserPreferences().getToken();
    String tokenA = await token;
    bool result;

    try {
      var response = Response();
      response = await Dio().delete(
        API_URL.slots + "/${id_booking}",
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
      e.message;
    }
    //print("slotsAvaiList list : " + slotsAvaiList.toString());
    return result;
  }
}

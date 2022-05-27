import 'package:health_app/src/model/doctor_model.dart';

class Booking {
  int id;
  String date;
  int index;
  String begin_at;
  String end_at;
  bool enabled;
  bool payment_status;
  Doctor doctor;

  Booking(
      {this.id,
      this.index,
      this.begin_at,
      this.end_at,
      this.date,
      this.doctor,
      this.enabled,
      this.payment_status});

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      date: json['date'],
      index: json['index'],
      begin_at: json['begin_at'],
      end_at: json['end_at'],
      enabled: json['enabled'],
      payment_status: json['payment_status'],
      doctor: Doctor.fromJson(json['doctor']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['index'] = this.index;
    data['begin_at'] = this.begin_at;
    data['end_at'] = this.end_at;
    data['enabled'] = this.enabled;
    data['payment_status'] = this.payment_status;
    data['doctor'] = this.doctor;
  }
}

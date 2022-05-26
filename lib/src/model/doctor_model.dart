import 'package:health_app/src/model/department_model.dart';

import 'department_model.dart';

class Doctor {
  int id;
  String name;
  String phone;
  String email;
  String ava_url;
  String description;
  int duration;
  int price;
  int rating;
  Department departments;

  Doctor({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.ava_url,
    this.description,
    this.duration,
    this.price,
    this.rating,
    this.departments,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      ava_url: json['ava_url'] != null ? json['ava_url'] : null,
      description: json['description'],
      duration: json['duration'],
      price: json['price'],
      rating: json['rating'],
      departments: Department.fromJson(json['departments']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['ava_url'] = this.ava_url;
    data['description'] = this.description;
    data['duration'] = this.duration;
    data['price'] = this.price;
    data['rating'] = this.rating;
    data['departments'] = this.departments;
  }
}

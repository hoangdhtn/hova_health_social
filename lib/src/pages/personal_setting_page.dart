import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/src/widgets/navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../config/api_url.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';

class PersonalSettingPage extends StatefulWidget {
  const PersonalSettingPage({Key key}) : super(key: key);

  @override
  State<PersonalSettingPage> createState() => _PersonalSettingPageState();
}

class _PersonalSettingPageState extends State<PersonalSettingPage> {
  final ImagePicker imgpicker = ImagePicker();
  XFile imagefiles;
  DateTime selectedDate = DateTime.now();

  String date;

  final _nameController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _workController = TextEditingController();
  final _locationController = TextEditingController();

  // _selectDate(BuildContext context) async {
  //   final DateTime picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //       date = DateFormat('yyyy-MM-dd').format(picked);
  //     });
  // }

  // Trả về ngày
  DateTime stringToDate(String date) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
    return tempDate;
  }

  // Mở Camera
  getCamera() async {
    try {
      var imagee = await imgpicker.pickImage(source: ImageSource.camera);
      if (imagee != null) {
        setState(() {
          imagefiles = imagee;
          print(imagefiles.toString());
        });
      } else {
        print("No image is selected.");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  updateUser(String fullname, String height, String weight, XFile fileImg,
      String work, String location, String data_of_birth) async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    bool result = await userProvider.updateUser(
        fullname, height, weight, fileImg, work, location, data_of_birth);
    if (result) {
      Flushbar(
        title: "Thông báo",
        message: "Thay đổi thành công",
        duration: Duration(seconds: 2),
      ).show(context);
    } else {
      Flushbar(
        title: "Thông báo",
        message: "Thay đổi thất bại",
        duration: Duration(seconds: 2),
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;
    _nameController.text = user.full_name;
    _heightController.text = user.height.toString();
    _weightController.text = user.weight.toString();
    _workController.text = user.work_at;
    _locationController.text = user.location;

    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          date = DateFormat('yyyy-MM-dd').format(picked);
        });
    }

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            children: [
              Column(children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          color: Colors.black54,
                          size: 36.0,
                        ),
                        Text(
                          " Quay về ",
                          style: GoogleFonts.nunito(
                              textStyle: TextStyle(fontSize: 20)),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 300,
                  width: 400,
                  child: Stack(
                    children: [
                      Positioned(
                        left: (MediaQuery.of(context).size.width / 2) - 60,
                        top: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: imagefiles != null
                              ? Image.file(
                                  File(imagefiles.path),
                                  height: 120,
                                  width: 120,
                                )
                              : Image.network(
                                  API_URL.getImage + user.avatar_url,
                                  height: 120,
                                  width: 120,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getCamera();
                  },
                  child: Text("Thay đổi ảnh"),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Họ và tên"),
                      TextFormField(
                        controller: _nameController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Chiều cao"),
                      TextFormField(
                        controller: _heightController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Căng nặng"),
                      TextFormField(
                        controller: _weightController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Làm việc tại"),
                      TextFormField(
                        controller: _workController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Địa chỉ"),
                      TextFormField(
                        controller: _locationController,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text("Ngày sinh: "),
                          Text(
                            date == null ? user.data_of_birth : date,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _selectDate(context);
                        },
                        child: Text("Chọn ngày sinh"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            updateUser(
                                _nameController.text,
                                _heightController.text,
                                _weightController.text,
                                imagefiles,
                                _workController.text,
                                _locationController.text,
                                date);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 30, right: 30),
                            child: Text("Cập nhật"),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

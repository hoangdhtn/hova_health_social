import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/medical_today_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/const.dart';
import '../widgets/custom_clipper.dart';

class MedicalTodayAddPage extends StatefulWidget {
  const MedicalTodayAddPage({Key key}) : super(key: key);

  @override
  State<MedicalTodayAddPage> createState() => _MedicalTodayAddPageState();
}

class _MedicalTodayAddPageState extends State<MedicalTodayAddPage> {
  TimeOfDay selectedTime = TimeOfDay.now();
  SharedPreferences sharedPreferences;
  List<MedicalToday> list = [];

  final _nameController = TextEditingController();
  final _infoController = TextEditingController();

  @override
  void initState() {
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void loadData() {
    List<String> listString =
        sharedPreferences.getStringList('listMedicalToday');
    if (listString != null) {
      list = listString
          .map((item) => MedicalToday.fromMap(json.decode(item)))
          .toList();
      setState(() {
        list = list;
      });
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('listMedicalToday', stringList);
  }

  bool addItem(MedicalToday item) {
    // Insert an item into the top of our list, on index zero
    try {
      list.insert(0, item);
      saveData();
      loadData();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    _selectTime(BuildContext context) async {
      final TimeOfDay timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
      );
      if (timeOfDay != null && timeOfDay != selectedTime) {
        setState(() {
          selectedTime = timeOfDay;
        });
      }
    }

    void backPage() {
      Navigator.pushNamed(context, "/MedicalTodayPage");
    }

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              ClipPath(
                clipper: MyCustomClipper(clipType: ClipType.bottom),
                child: Container(
                  color: Theme.of(context).accentColor,
                  height: Constants.headerHeight + statusBarHeight - 30,
                ),
              ),
              Positioned(
                right: -45,
                top: -30,
                child: ClipOval(
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                    height: 220,
                    width: 220,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(Constants.paddingSide),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        BackButton(
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const Center(
                      child: Text(
                        "THÊM ĐƠN THUỐC TRONG NGÀY",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Info Medical
                    SizedBox(height: 70),
                    TextField(
                      controller: _nameController,
                      minLines:
                          6, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Tên thuốc',
                          hintText: "Điền tên thuốc",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          labelStyle: TextStyle(fontSize: 25)),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _infoController,
                      minLines:
                          6, // any number you need (It works as the rows for the textarea)
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          labelText: 'Thông tin',
                          hintText: "Điền thông tin",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          fillColor: Color.fromARGB(255, 255, 255, 255),
                          filled: true,
                          labelStyle: TextStyle(fontSize: 25)),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Thời gian dùng: ${selectedTime.hour}:${selectedTime.minute}",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectTime(context);
                      },
                      child: Text("CHỌN THỜI GIAN SỬ DỤNG"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (addItem(
                              MedicalToday(
                                name: _nameController.text,
                                info: _infoController.text,
                                time:
                                    "${selectedTime.hour}:${selectedTime.minute}",
                                completed: false,
                              ),
                            ) ==
                            true) {
                          Flushbar(
                            title: "Tạo thành công",
                            message: "Vui lòng kiểm tra",
                            duration: const Duration(seconds: 10),
                          ).show(context);
                          Navigator.pushNamed(context, "/MedicalTodayPage");
                        } else {
                          Flushbar(
                            title: "Tạo thất bại",
                            message: "Mời bạn tạo lại",
                            duration: const Duration(seconds: 10),
                          ).show(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0),
                        ),
                        padding: const EdgeInsets.all(0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: 100,
                        child: Text("LƯU"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/providers/medical_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../theme/const.dart';
import '../widgets/custom_clipper.dart';

class MedicalAddPage extends StatefulWidget {
  const MedicalAddPage({Key key}) : super(key: key);

  @override
  State<MedicalAddPage> createState() => _MedicalAddPageState();
}

class _MedicalAddPageState extends State<MedicalAddPage> {
  DateTime selectedDate = DateTime.now();
  final ImagePicker imgpicker = ImagePicker();
  List<XFile> imagefiles = [];

  String timeCreated_at;
  String timeUpdated_at;
  final _tenbenhController = TextEditingController();
  final _ttbenhController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;

    // Trả về ngày
    DateTime stringToDate(String date) {
      DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
      return tempDate;
    }

    // Khoản cách giữa 2 ngày
    int dateBetween(DateTime from, DateTime to) {
      return (to.difference(from).inHours / 24).round();
    }

    // Chọn ngày bắt đầu

    _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2999),
      );
      if (picked != null && picked != selectedDate)
        setState(() {
          selectedDate = picked;
          timeCreated_at = DateFormat('yyyy-MM-dd').format(picked);
        });
    }

    // Chọn ngày hêt
    _selectDateUpdate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2999),
      );
      if (picked != null &&
          picked != selectedDate &&
          picked.isAfter(selectedDate)) {
        setState(() {
          timeUpdated_at = DateFormat('yyyy-MM-dd').format(picked);
        });
        debugPrint("Time " + timeUpdated_at.toString());
      }
    }

    // Upload hình ảnh
    openImages() async {
      try {
        var pickedfiles = await imgpicker.pickMultiImage();
        //you can use ImageCourse.camera for Camera capture
        if (pickedfiles != null) {
          imagefiles = pickedfiles;
          setState(() {
            imagefiles = pickedfiles;
            print(imagefiles.toString());
          });
        } else {
          print("No image is selected.");
        }
      } catch (e) {
        print(e.toString());
      }
    }

    // Tạo mới bệnh án
    MedicalProvider medicalProvider = Provider.of<MedicalProvider>(context);
    void doAddMedical(String name, String info, String created, String updated,
        List<XFile> listFiles) async {
      bool result = await medicalProvider.createMedical(
          name, info, created, updated, listFiles);

      if (result) {
        Flushbar(
          title: "Thông báo",
          message: "Thêm thành công",
          duration: Duration(seconds: 2),
        ).show(context);
      } else {
        Flushbar(
          title: "Thông báo",
          message: "Thêm thất bại",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    var loading = Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 20,
          ),
          Text(" Đang xử lý ...")
        ],
      ),
    );

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        "THÊM LỊCH SỬ BỆNH",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Info Medical
                    SizedBox(height: 120),
                    TextField(
                      controller: _tenbenhController,
                      maxLines: null,
                      minLines: 6,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: 'Tên bệnh',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        labelStyle: TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _ttbenhController,
                      maxLines: null,
                      minLines: 6,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: 'Thông tin bệnh',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        fillColor: Color.fromARGB(255, 255, 255, 255),
                        filled: true,
                        labelStyle: TextStyle(fontSize: 25),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Thời gian bắt đầu bị:   ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(timeCreated_at != null ? "${timeCreated_at}" : "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text("CHỌN THỜI GIAN BẮT ĐẦU"),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "Thời gian hết bệnh:   ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(timeUpdated_at != null ? "${timeUpdated_at}" : "",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _selectDateUpdate(context);
                      },
                      child: Text("CHỌN THỜI GIAN KẾT THÚC"),
                    ),
                    SizedBox(height: 20),
                    const Text(
                      "Hình ảnh đơn thuốc - chịu chứng",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(20),
                      child: Column(
                        children: [
                          //open button ----------------
                          ElevatedButton(
                              onPressed: () {
                                openImages();
                              },
                              child: Text("Mở hình ảnh")),

                          Divider(),
                          Text("Ảnh đã chọn:"),
                          Divider(),

                          imagefiles != null
                              ? Wrap(
                                  children: imagefiles.map((imageone) {
                                    return Container(
                                        child: Card(
                                      child: Container(
                                        height: 100,
                                        width: 100,
                                        child: Image.file(File(imageone.path)),
                                      ),
                                    ));
                                  }).toList(),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Center(
                      child: medicalProvider.createInStatus == Status.Creating
                          ? loading
                          : ElevatedButton(
                              onPressed: () {
                                doAddMedical(
                                    _tenbenhController.text,
                                    _ttbenhController.text,
                                    timeCreated_at,
                                    timeUpdated_at,
                                    imagefiles);
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
                                width: 200,
                                child: Text("LƯU"),
                              ),
                            ),
                    )
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

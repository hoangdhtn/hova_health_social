import 'package:another_flushbar/flushbar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/model/medical_model.dart';
import 'package:health_app/src/providers/medical_provider.dart';
import 'package:health_app/src/theme/const.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../config/api_url.dart';
import '../theme/const.dart';
import '../widgets/custom_clipper.dart';

class MedicalDetailPage extends StatefulWidget {
  MedicalDetailPage({Key key}) : super(key: key);

  @override
  State<MedicalDetailPage> createState() => _MedicalDetailPageState();
}

class _MedicalDetailPageState extends State<MedicalDetailPage> {
  DateTime selectedDate = DateTime.now();
  bool enabled = true;

  bool _submitted = true;
  final nameMedical = TextEditingController();
  final infoMedical = TextEditingController();
  String timeCreated_at;
  String timeUpdated_at;

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

  String _errText() {
    final text = nameMedical.text;

    if (text.isEmpty) {
      return "Không được để trống";
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    Medical model = ModalRoute.of(context).settings.arguments;
    MedicalProvider medicalProvider = Provider.of<MedicalProvider>(context);

    double statusBarHeight = MediaQuery.of(context).padding.top;
    Size size = MediaQuery.of(context).size;

    var loading = Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            width: 20,
          ),
          Text(" Đang xử lý ...")
        ],
      ),
    );

    void _doUpdate(String id, String name, String info, String created,
        String updated) async {
      if (_errText() == null) {
        setState(() {
          _submitted = true;
        });

        var dataMedical = await medicalProvider.updateMedical(
            id, name, info, created, updated);
        if (dataMedical != null) {
          setState(() {
            model = dataMedical;
          });
          Flushbar(
            title: "Thông báo",
            message: "Chỉnh sửa thành công",
            duration: Duration(seconds: 2),
          ).show(context);
        } else {
          Flushbar(
            title: "Thông báo",
            message: "Chỉnh sửa thất bại",
            duration: Duration(seconds: 2),
          ).show(context);
        }
      }
    }

    void _doDelete(String id) async {
      bool result = await medicalProvider.deleteMedical(id);
      if (result == true) {
        Navigator.pop(context, true);
      } else {
        Flushbar(
          title: "Thông báo",
          message: "Xóa thất bại",
          duration: Duration(seconds: 2),
        ).show(context);
      }
    }

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Theme.of(context).accentColor,
              height: Constants.headerHeight + statusBarHeight,
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
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BackButton(color: Colors.white),
                  ],
                ),
                Center(
                  child: Text(
                    "CHỈNH SỬA THÔNG TIN BỆNH",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 50),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextField(
                        controller: nameMedical,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Tên bệnh',
                            hintText: model.name,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                            filled: true,
                            errorText: !_submitted ? _errText() : null),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: infoMedical,
                        minLines:
                            6, // any number you need (It works as the rows for the textarea)
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            labelText: 'Chịu chứng',
                            hintText: model.info,
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            fillColor: Color.fromARGB(255, 255, 255, 255),
                            filled: true,
                            errorText: !_submitted ? _errText() : null),
                      ),
                    ],
                  ),
                ),
                //  Text(
                //   "Trạng thái",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Flexible(
                //       child: ListTile(
                //         title: Text("Hiện"),
                //         leading: Radio(
                //           value: true,
                //           groupValue: enabled,
                //           onChanged: (value) {
                //             setState(() {
                //               enabled = value;
                //             });
                //           },
                //           activeColor: Colors.green,
                //         ),
                //       ),
                //     ),
                //     Flexible(
                //       child: ListTile(
                //         title: Text("Ẩn"),
                //         leading: Radio(
                //           value: false,
                //           groupValue: enabled,
                //           onChanged: (value) {
                //             setState(() {
                //               enabled = value;
                //             });
                //           },
                //           activeColor: Colors.green,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Thời gian bắt đầu bị:   ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        timeCreated_at == null
                            ? model.created_at == null
                                ? ""
                                : model.created_at
                            : timeCreated_at,
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        timeUpdated_at == null
                            ? model.updated_at == null
                                ? ""
                                : model.updated_at
                            : timeUpdated_at,
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
                Text(
                  "Hình ảnh đơn thuốc - chịu chứng",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                model.listImg != null && model.listImg.isNotEmpty
                    ? CarouselSlider(
                        options: CarouselOptions(height: 300.0),
                        items: model.listImg.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.symmetric(horizontal: 5.0),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255)),
                                child: i != null && i.name != null
                                    ? Image.network(API_URL.getImage + i.name)
                                    : SizedBox(),
                              );
                            },
                          );
                        }).toList(),
                      )
                    : SizedBox(),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    medicalProvider.updateInStatus == Status.Updating
                        ? loading
                        : ElevatedButton(
                            onPressed: () {
                              _doUpdate(
                                model.id.toString(),
                                nameMedical.text,
                                infoMedical.text,
                                timeCreated_at,
                                timeUpdated_at,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              padding: EdgeInsets.all(0),
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                              child: Text(
                                "Cập nhật",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                    medicalProvider.deleteInStatus == Status.Deleting
                        ? loading
                        : ElevatedButton(
                            onPressed: () {
                              _doDelete(model.id.toString());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(80.0),
                              ),
                              padding: EdgeInsets.all(0),
                              primary: Colors.redAccent,
                            ),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(50, 5, 50, 5),
                              child: Text(
                                "Xóa",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

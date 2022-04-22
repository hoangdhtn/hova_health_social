import 'package:flutter/material.dart';
import 'package:health_app/src/model/medical_model.dart';

import '../theme/const.dart';
import '../widgets/custom_clipper.dart';

class MedicalDetailPage extends StatefulWidget {
  const MedicalDetailPage({Key key}) : super(key: key);

  @override
  State<MedicalDetailPage> createState() => _MedicalDetailPageState();
}

class _MedicalDetailPageState extends State<MedicalDetailPage> {
  final _nameMedical = TextEditingController();
  bool enabled = true;

  @override
  Widget build(BuildContext context) {
    Medical model = ModalRoute.of(context).settings.arguments;
    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(children: <Widget>[
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
                children: const [
                  BackButton(color: Colors.white),
                ],
              ),
              const Center(
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
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        labelText: 'Tên bệnh',
                        hintText: model.name,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
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
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: ListTile(
                      title: Text("Hiện"),
                      leading: Radio(
                        value: true,
                        groupValue: enabled,
                        onChanged: (value) {
                          setState(() {
                            enabled = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text("Ẩn"),
                      leading: Radio(
                        value: false,
                        groupValue: enabled,
                        onChanged: (value) {
                          setState(() {
                            enabled = value;
                          });
                        },
                        activeColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}

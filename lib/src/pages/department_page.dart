import 'package:flutter/material.dart';
import 'package:health_app/src/theme/light_color.dart';

import '../widgets/CardSelect.dart';
import '../widgets/user_info.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({Key key}) : super(key: key);

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: const Text('Danh sách lịch hẹn của bạn'),
          backgroundColor: Colors.green,
          icon: const Icon(Icons.list),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              UserIntro(
                name: "Huy Hoàng",
              ),
              SizedBox(
                height: 20,
              ),
              CardSelect(
                title: "Nội khoa",
                onTap: () {
                  Navigator.pushNamed(context, "/ListDoctorPage");
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

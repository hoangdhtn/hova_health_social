import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:health_app/src/model/department_model.dart';
import 'package:health_app/src/providers/department_provider.dart';
import 'package:health_app/src/theme/light_color.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/CardSelect.dart';
import '../widgets/user_info.dart';

class DepartmentPage extends StatefulWidget {
  const DepartmentPage({Key key}) : super(key: key);

  @override
  State<DepartmentPage> createState() => _DepartmentPageState();
}

class _DepartmentPageState extends State<DepartmentPage> {
  List<Department> listDepartment = [];

  @override
  void initState() {
    // id = widget.id;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getDepartmentList();
      });
    }
    super.initState();
  }

  getDepartmentList() async {
    var fetchedDepartment =
        await Provider.of<DepartmentProvider>(context, listen: false)
            .getDepartment() as List<Department>;
    setState(() {
      listDepartment = fetchedDepartment;
    });
    print("Department list view : " + fetchedDepartment.toString());
  }

  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;

    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.pushNamed(context, "/ListBookingPage");
          },
          label: const Text('Danh sách lịch hẹn của bạn'),
          backgroundColor: Colors.green,
          icon: const Icon(Icons.list),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: ListView(
            children: [
              // Container(
              //   child: UserIntro(
              //     name: user.full_name,
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: listDepartment != null ? listDepartment.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return CardSelect(
                      title: listDepartment[index].name,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          "/ListDoctorPage",
                          arguments: listDepartment[index],
                        );
                      },
                    );
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_app/src/model/department_model.dart';
import 'package:health_app/src/model/doctor_model.dart';
import 'package:health_app/src/providers/doctor_provider.dart';
import 'package:health_app/src/theme/light_color.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/doctor_cart.dart';

class ListDoctorPage extends StatefulWidget {
  const ListDoctorPage({Key key}) : super(key: key);

  @override
  State<ListDoctorPage> createState() => _ListDoctorPageState();
}

class _ListDoctorPageState extends State<ListDoctorPage> {
  int id_doctor;
  List<Doctor> listDoctors;

  @override
  void initState() {
    // id = widget.id;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getDoctorsByDepart(id_doctor);
      });
    }
    super.initState();
  }

  getDoctorsByDepart(int id_doctor) async {
    var fetchedDoctors =
        await Provider.of<DoctorProvider>(context, listen: false)
            .getListDoctor(id_doctor);
    setState(() {
      listDoctors = fetchedDoctors;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Data param
    Department department = ModalRoute.of(context).settings.arguments;
    setState(() {
      id_doctor = department.id;
    });
    return Scaffold(
      body: ListView(
        children: [
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
                    style:
                        GoogleFonts.nunito(textStyle: TextStyle(fontSize: 20)),
                  )
                ],
              ),
            ),
          ),
          Column(
            children: [
              ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: listDoctors != null ? listDoctors.length : 0,
                  itemBuilder: (BuildContext context, int index) {
                    return DoctorCard(
                      department: listDoctors[index].departments.name,
                      doctorName: listDoctors[index].name,
                      doctorTitle: "",
                      price: NumberFormat.simpleCurrency(
                              locale: 'vi', decimalDigits: 0)
                          .format(
                              int.parse(listDoctors[index].price.toString()))
                          .toString(),
                      img: listDoctors[index].ava_url,
                      onTap: () {
                        Navigator.pushNamed(context, "/DoctorDetailPage",
                            arguments: listDoctors[index]);
                      },
                    );
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

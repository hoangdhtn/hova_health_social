import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/doctor_cart.dart';

class ListDoctorPage extends StatefulWidget {
  const ListDoctorPage({Key key}) : super(key: key);

  @override
  State<ListDoctorPage> createState() => _ListDoctorPageState();
}

class _ListDoctorPageState extends State<ListDoctorPage> {
  @override
  Widget build(BuildContext context) {
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
              DoctorCard(
                img: "assets/doctor_1.png",
                doctorName: "Huy",
                doctorTitle: "TTTT",
                price: "1000000",
                onTap: () {
                  Navigator.pushNamed(context, '/DoctorDetailPage');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/doctor_cart.dart';

class ListBookingPage extends StatefulWidget {
  const ListBookingPage({Key key}) : super(key: key);

  @override
  State<ListBookingPage> createState() => _ListBookingPageState();
}

class _ListBookingPageState extends State<ListBookingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, "/BottomNavigation", (route) => false);
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
                ],
              ),
            ),
          ),
          Column(
            children: [
              Center(
                child: Text(
                  "Danh sách lịch hẹn của bạn",
                  style: GoogleFonts.nunito(textStyle: TextStyle(fontSize: 20)),
                ),
              ),
              DoctorCard(
                img: "assets/doctor_1.png",
                doctorName: "Huy",
                doctorTitle: "TTTT",
                price: "1000000",
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

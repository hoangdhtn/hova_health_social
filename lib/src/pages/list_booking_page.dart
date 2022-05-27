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
              Container(
                padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // CircleAvatar(
                        //   backgroundColor: Color(0xFFD9D9D9),
                        //   backgroundImage: NetworkImage(USER_IMAGE),
                        //   radius: 36.0,
                        // ),
                        RichText(
                          text: TextSpan(
                            text: 'Dr Dan MlayahFX',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '\nSunday,May 5th at 8:00 PM',
                                style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15,
                                ),
                              ),
                              TextSpan(
                                text:
                                    '\n570 Kyemmer Stores \nNairobi Kenya C -54 Drive',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Divider(
                      color: Colors.grey[200],
                      height: 3,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _iconBuilder(Icons.abc, 'Check-in'),
                        _iconBuilder(Icons.abc, 'Cancel'),
                      ],
                    )
                  ],
                ),
              ),
              DoctorCard(
                img: "",
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

  Column _iconBuilder(icon, title) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          size: 28,
          color: Colors.black,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

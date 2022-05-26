import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:health_app/src/config/api_url.dart';
import 'package:health_app/src/theme/light_color.dart';

class DoctorCard extends StatelessWidget {
  String img;
  String doctorName;
  String doctorTitle;
  String department;
  String price;
  final void Function() onTap;

  DoctorCard(
      {this.img,
      this.doctorName,
      this.doctorTitle,
      this.price,
      this.onTap,
      this.department});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
        margin: EdgeInsets.only(
          bottom: 20.0,
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1.0,
                blurRadius: 6.0,
              ),
            ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // CircleAvatar(
                  //   backgroundColor: Color(0xFFD9D9D9),
                  //   backgroundImage: NetworkImage(USER_IMAGE),
                  //   radius: 36.0,NetworkImage(API_URL.getImage + img)
                  // ),
                  CircleAvatar(
                    backgroundColor: Color(0xFFD9D9D9),
                    backgroundImage: img == null || img == ""
                        ? AssetImage("assets/doctor_user.png")
                        : NetworkImage(API_URL.getImage + img),
                    radius: 36.0,
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${department}\n',
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        'Bs. ${doctorName}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      // SizedBox(
                      //   child: Text(
                      //     '\n${doctorTitle}',
                      //     style: TextStyle(
                      //       color: Colors.black45,
                      //       fontWeight: FontWeight.w400,
                      //       fontSize: 15,
                      //     ),
                      //   ),
                      // ),
                      Text(
                        '\nChi phí: ${price}',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(
                        height: 6.0,
                      ),
                      RaisedButton(
                        onPressed: onTap,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        padding: const EdgeInsets.all(0.0),
                        child: Ink(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 113, 124, 244),
                                Color.fromARGB(255, 47, 42, 155),
                                Color.fromARGB(255, 67, 22, 231)
                              ],
                              stops: [0.0, 0.5, 1.0],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(80.0)),
                          ),
                          child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0,
                                minHeight:
                                    36.0), // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: const Text(
                              'Chi tiết',
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 15,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Icon(
                Icons.favorite,
                color: Color(0xFFA52C4D),
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

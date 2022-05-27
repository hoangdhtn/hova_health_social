import 'package:flutter/material.dart';

import '../config/api_url.dart';

class BookingItem extends StatefulWidget {
  String img;
  String doctorName;
  String date;
  String time;
  String department;
  String price;
  bool enabled;
  bool payment;
  void Function() onTapCancel;

  BookingItem({
    Key key,
    this.department,
    this.doctorName,
    this.date,
    this.time,
    this.img,
    this.price,
    this.enabled,
    this.payment,
    this.onTapCancel,
  }) : super(key: key);

  @override
  State<BookingItem> createState() => _BookingItemState();
}

class _BookingItemState extends State<BookingItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 18.0),
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
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xFFD9D9D9),
                  backgroundImage: widget.img == null || widget.img == ""
                      ? AssetImage("assets/doctor_user.png")
                      : NetworkImage(API_URL.getImage + widget.img),
                  radius: 36.0,
                ),
                RichText(
                  text: TextSpan(
                    text: widget.doctorName,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: "\nNgày: " + widget.date,
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: "\nThời gian: " + widget.time,
                        style: TextStyle(
                          color: Colors.black45,
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      TextSpan(
                        text: '\nThông tin phòng vui lòng \nkiểm tra email\n',
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: "Khoa: " + widget.department,
                        style: TextStyle(
                          color: Colors.black38,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                        ),
                      ),
                      TextSpan(
                        text: "\nPhí: " + widget.price,
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
                    Icons.info,
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
                widget.enabled == true
                    ? _iconBuilder(
                        Icons.check_circle, Colors.green, 'Trạng thái')
                    : _iconBuilder(
                        Icons.check_circle, Colors.black, 'Trạng thái'),
                widget.payment == true
                    ? _iconBuilder(Icons.paid, Colors.green, 'Thanh toán')
                    : _iconBuilder(Icons.paid, Colors.black, 'Thanh toán'),
                GestureDetector(
                    onTap: widget.onTapCancel,
                    child: _iconBuilder(Icons.cancel, Colors.redAccent, 'Hủy')),
              ],
            )
          ],
        ),
      ),
    );
  }

  Column _iconBuilder(icon, icon_color, title) {
    return Column(
      children: <Widget>[
        Icon(
          icon,
          size: 28,
          color: icon_color != null ? icon_color : Colors.black,
        ),
        SizedBox(
          height: 8.0,
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: icon_color != null ? icon_color : Colors.black,
          ),
        ),
      ],
    );
  }
}

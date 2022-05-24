import 'package:flutter/material.dart';
import 'package:health_app/src/theme/light_color.dart';

class DoctorCard extends StatelessWidget {
  String img;
  String doctorName;
  String doctorTitle;
  String price;
  final void Function() onTap;

  DoctorCard(
      {this.img, this.doctorName, this.doctorTitle, this.price, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Color(LightColor.grey01),
                  child: Image(
                    width: 100,
                    image: AssetImage(img),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorName,
                    style: TextStyle(
                      color: Color(LightColor.header01),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    doctorTitle,
                    style: TextStyle(
                      color: Color(LightColor.grey02),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.star,
                        color: Color(LightColor.yellow02),
                        size: 18,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "Phí " + price + " VNĐ",
                        style: TextStyle(color: Color(LightColor.grey02)),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

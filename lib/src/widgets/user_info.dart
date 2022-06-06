import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserIntro extends StatelessWidget {
  final String name;
  const UserIntro({
    Key key,
    this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Xin chào',
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
            Flexible(
              child: Text('${name} 👋',
                  style: GoogleFonts.nunito(
                    textStyle:
                        TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  )),
            ),
            Text(
              'Mời bạn lựa chọn',
              style: GoogleFonts.lato(
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PostAdd extends StatefulWidget {
  const PostAdd({Key key}) : super(key: key);

  @override
  State<PostAdd> createState() => _PostAddState();
}

class _PostAddState extends State<PostAdd> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(140),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(140)),
                height: 58,
                width: 60,
                child: Stack(
                  children: <Widget>[
                    Container(
                        height: 78,
                        width: 74,
                        margin: const EdgeInsets.only(
                            left: 0.0, right: 0, top: 0, bottom: 0),
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(140)),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://storage.googleapis.com/multibhashi-website/website-media/2017/12/person.jpg',
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Text(
            'Bạn đang nghĩ gì?',
            style: GoogleFonts.roboto(
                color: Colors.grey[700],
                fontSize: 16,
                letterSpacing: 1,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: const Icon(
              Icons.collections,
              color: Colors.greenAccent,
              size: 36.0,
            ),
          ),
        ],
      ),
    );
  }
}

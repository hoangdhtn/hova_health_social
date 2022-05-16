import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/post_add.dart';
import '../widgets/post_item.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFE8E8E8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: (() {
                      print("cccc");
                      Navigator.pushNamed(context, '/SocialAddPostPage');
                    }),
                    child: PostAdd()),
                PostItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

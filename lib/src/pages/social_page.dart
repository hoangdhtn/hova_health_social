import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../widgets/post_add.dart';
import '../widgets/post_item.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({Key key}) : super(key: key);

  @override
  State<SocialPage> createState() => _SocialPageState();
}

var urls = <String>[
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
  'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
];

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xFFE8E8E8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
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
                      child: PostAdd(
                        ava: user.avatar_url,
                      )),
                  PostItem(
                      user: user,
                      name: "ccc",
                      content: "ccccc",
                      imageUrls: urls,
                      like: "40",
                      cmt: "41"),
                  PostItem(
                      user: user,
                      name: "ccc",
                      content: "ccccc",
                      imageUrls: urls,
                      like: "40",
                      cmt: "41"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

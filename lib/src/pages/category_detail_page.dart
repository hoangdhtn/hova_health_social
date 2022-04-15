import 'package:flutter/material.dart';
import 'package:health_app/src/theme/extention.dart';
import 'package:provider/provider.dart';

import '../config/api_url.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../theme/light_color.dart';

class CategoryDetailPage extends StatefulWidget {
  CategoryDetailPage({Key key, this.id}) : super(key: key);
  final id;
  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  int id = 1;

  @override
  void initState() {
    id = widget.id;
    super.initState();
  }

  Widget _appBar(String userIMG) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: const Icon(
        Icons.short_text,
        size: 30,
        color: Colors.black,
      ),
      actions: <Widget>[
        const Icon(
          Icons.notifications_none,
          size: 30,
          color: LightColor.grey,
        ),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(13)),
          child: Container(
            // height: 40,
            // width: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: userIMG != null
                ? Image.network(API_URL.getImage + userIMG, fit: BoxFit.fill)
                : Image.asset("assets/user.png", fit: BoxFit.fill),
          ),
        ).p(8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    int id = ModalRoute.of(context).settings.arguments;
    User user;
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            _appBar(user.avatar_url),
            Text("ID cate ${id}"),
          ],
        ),
      ),
    );
  }
}

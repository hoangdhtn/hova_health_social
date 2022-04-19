import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:health_app/src/model/category_model.dart';
import 'package:health_app/src/providers/category_provider.dart';
import 'package:health_app/src/providers/news_provider.dart';
import 'package:health_app/src/theme/extention.dart';
import 'package:provider/provider.dart';

import '../config/api_url.dart';
import '../model/news_model.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';

class CategoryDetailPage extends StatefulWidget {
  const CategoryDetailPage({Key key, this.model}) : super(key: key);
  final Category model;

  @override
  State<CategoryDetailPage> createState() => _CategoryDetailPageState();
}

class _CategoryDetailPageState extends State<CategoryDetailPage> {
  int id;
  int position = 0;
  int pageSize = 5;
  List<News> listNews = [];
  List<Images> imgNews = [];

  @override
  void initState() {
    // id = widget.id;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getNewsByCate(id, position, pageSize);
      });
    }
    super.initState();
  }

  getNewsByCate(int id_cate, int position, int pageSize) async {
    var fetchedNews =
        await Provider.of<CategoryProvider>(context, listen: false)
            .getNewsByIdCate(id_cate, position, pageSize);
    setState(() {
      listNews = fetchedNews;
    });
  }

  @override
  Widget _appbar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        BackButton(color: Theme.of(context).primaryColor),
        // IconButton(
        //     icon: Icon(
        //       model.isfavourite ? Icons.favorite : Icons.favorite_border,
        //       color: model.isfavourite ? Colors.red : LightColor.grey,
        //     ),
        //     onPressed: () {
        //       setState(() {
        //         model.isfavourite = !model.isfavourite;
        //       });
        //     })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Category idaa = ModalRoute.of(context).settings.arguments;
    setState(() {
      id = idaa.id.toInt();
    });
    User user;
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: listNews == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  _appbar(),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, right: 16, left: 16, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Danh mục: ${idaa.name}",
                            style: TextStyles.title.bold),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: listNews.length ?? null,
                      itemBuilder: (BuildContext context, int index) {
                        return _listNewsWidget(listNews, index, context);
                      }),
                ],
              ),
      ),
    );
  }

  Container _listNewsWidget(List<News> data, int index, BuildContext context) {
    imgNews = data[index].news_Imgs as List;
    // if (imgNews != null && imgNews.length > 0) {
    //   print(" Hinh anh 1 : " + imgNews[0].name.toString());
    // }
    return Container(
      height: 100,
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: const Offset(4, 4),
              blurRadius: 10,
              color: LightColor.grey.withOpacity(.2),
            ),
            BoxShadow(
              offset: const Offset(-3, 0),
              blurRadius: 15,
              color: LightColor.grey.withOpacity(.1),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(13)),
              child: Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: randomColor(),
                ),
                child: imgNews != null && imgNews.isNotEmpty
                    ? Image.network(
                        API_URL.getImage + imgNews[0].name.toString(),
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        'assets/user.png',
                        height: 50,
                        width: 50,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            title: Text(data[index].title ?? "", style: TextStyles.title.bold),
            subtitle: Text(
              data[index].keyword ?? "",
              style: TextStyles.bodySm.subTitleColor.bold,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              size: 30,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ).ripple(() {
          Navigator.pushNamed(context, "/DetailPage", arguments: data[index]);
        }, borderRadius: const BorderRadius.all(Radius.circular(20))),
      ),
    );
  }

  Color randomColor() {
    var random = Random();
    final colorList = [
      Theme.of(context).primaryColor,
      LightColor.orange,
      LightColor.green,
      LightColor.grey,
      LightColor.lightOrange,
      LightColor.skyBlue,
      LightColor.titleTextColor,
      Colors.red,
      Colors.brown,
      LightColor.purpleExtraLight,
      LightColor.skyBlue,
    ];
    var color = colorList[random.nextInt(colorList.length)];
    return color;
  }
}

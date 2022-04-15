import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:health_app/src/config/api_url.dart';
import 'package:health_app/src/model/category_model.dart';
import 'package:health_app/src/model/news_model.dart';
import 'package:health_app/src/providers/category_provider.dart';
import 'package:health_app/src/providers/news_provider.dart';
import 'package:health_app/src/theme/extention.dart';
import 'package:provider/provider.dart';

import '../model/dactor_model.dart';
import '../model/data.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<News> futureData;
  List<Images> imgNews = [];
  List<News> newsMore;
  List<Category> categoryData;
  ScrollController controller;
  int position = 0;
  int pageSize = 5;
  bool isLoadingTop = false;
  bool isLoadingBot = false;

  @override
  void initState() {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getNewsList();
        getCateList();
      });
    }
    super.initState();
    controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  void getNewsList() async {
    var fetchedNews = await Provider.of<NewsProvider>(context, listen: false)
        .getNews(position, pageSize) as List<News>;
    setState(() {
      futureData = fetchedNews;
    });
  }

  void getCateList() async {
    var fetchedCate =
        await Provider.of<CategoryProvider>(context, listen: false)
            .getCategory() as List<Category>;
    setState(() {
      categoryData = fetchedCate;
    });
    print("Cate list view : " + categoryData.toString());
  }

  void _scrollListener() async {
    print(controller.position.extentAfter);
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      var fetchedNews = await Provider.of<NewsProvider>(context, listen: false)
          .getNews(position + 5, pageSize + 5) as List<News>;
      setState(() {});
      if (fetchedNews != null &&
          fetchedNews.isNotEmpty &&
          fetchedNews.length > 0) {
        setState(() {
          futureData = futureData + fetchedNews;
          position += 5;
          pageSize += 5;
        });
      }

      print("AAAAA => " + position.toString() + "  -  " + pageSize.toString());
    }

    if (controller.position.pixels == controller.position.minScrollExtent) {
      setState(() {
        position = 0;
        pageSize = 5;
      });

      var fetchedNews = await Provider.of<NewsProvider>(context, listen: false)
          .getNews(position, pageSize) as List<News>;
      if (fetchedNews != null &&
          fetchedNews.isNotEmpty &&
          fetchedNews.length > 0) {
        setState(() {
          futureData = fetchedNews;
        });
      }
    }
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

  Widget _header(String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Xin chào,", style: TextStyles.title.subTitleColor),
        Text(name, style: TextStyles.h1Style),
      ],
    ).p16;
  }

  Widget _searchField() {
    return Container(
      height: 55,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(13)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: LightColor.grey.withOpacity(.3),
            blurRadius: 15,
            offset: Offset(5, 5),
          )
        ],
      ),
      child: TextField(
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: InputBorder.none,
          hintText: "Tìm kiếm",
          hintStyle: TextStyles.body.subTitleColor,
          suffixIcon: SizedBox(
              width: 50,
              child: Icon(Icons.search, color: LightColor.purple)
                  .alignCenter
                  .ripple(() {}, borderRadius: BorderRadius.circular(13))),
        ),
      ),
    );
  }

  Widget _category(List<Category> categoryData) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Danh mục", style: TextStyles.title.bold),
                Text(
                  "Tất cả",
                  style: TextStyles.titleNormal
                      .copyWith(color: Theme.of(context).primaryColor),
                ).p(8).ripple(() {})
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              children: [
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  alignment: Alignment.center,
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          categoryData != null ? categoryData.length : null,
                      itemBuilder: (BuildContext context, int index) {
                        if (categoryData != null && categoryData.length > 0) {
                          return Container(
                            child: _categoryCard(categoryData[index].name, "",
                                color: LightColor.skyBlue,
                                lightColor: Color.fromARGB(255, 199, 199, 235)),
                          ).ripple(() {
                            Navigator.pushNamed(context, "/CategoryDetailPage",
                                arguments: categoryData[index].id);
                          });
                        }
                      }),
                )
              ],
              // children: <Widget>[
              //   itemBuilder: (BuildContext context, int index)"Chemist & Drugist", "350 + Stores",
              //       color: LightColor.green, lightColor: LightColor.lightGreen)],
              // ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryCard(String title, String subtitle,
      {Color color, Color lightColor}) {
    TextStyle titleStyle = TextStyles.title.bold.white;
    TextStyle subtitleStyle = TextStyles.body.bold.white;
    if (AppTheme.fullWidth(context) < 392) {
      titleStyle = TextStyles.body.bold.white;
      subtitleStyle = TextStyles.bodySm.bold.white;
    }
    return AspectRatio(
      aspectRatio: 6 / 8,
      child: Container(
        height: 280,
        width: AppTheme.fullWidth(context) * .3,
        margin: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: lightColor.withOpacity(.8),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Container(
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: -20,
                  left: -20,
                  child: CircleAvatar(
                    backgroundColor: lightColor,
                    radius: 30,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Text(title,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ).p16
              ],
            ),
          ),
        ).ripple(() {}, borderRadius: BorderRadius.all(Radius.circular(20))),
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

  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: _appBar(user.avatar_url != null ? user.avatar_url : null),
      backgroundColor: Theme.of(context).backgroundColor,
      body: futureData == null || futureData.length < 0
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView(
                controller: controller,
                physics: BouncingScrollPhysics(),
                children: [
                  _header(user.full_name),
                  _searchField(),
                  _category(categoryData),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 8, right: 16, left: 16, bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Bài viết", style: TextStyles.title.bold),
                        Text(
                          "Tất cả",
                          style: TextStyles.titleNormal
                              .copyWith(color: Theme.of(context).primaryColor),
                        ).p(8).ripple(() {})
                      ],
                    ),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: futureData.length ?? null,
                      itemBuilder: (BuildContext context, int index) {
                        return _listNewsWidget(futureData, index, context);
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
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              offset: Offset(4, 4),
              blurRadius: 10,
              color: LightColor.grey.withOpacity(.2),
            ),
            BoxShadow(
              offset: Offset(-3, 0),
              blurRadius: 15,
              color: LightColor.grey.withOpacity(.1),
            )
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
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
            title: Text(data[index].title, style: TextStyles.title.bold),
            subtitle: Text(
              data[index].keyword,
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
}

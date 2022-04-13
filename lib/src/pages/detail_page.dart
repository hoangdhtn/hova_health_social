import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:health_app/src/model/category_model.dart';
import 'package:health_app/src/model/news_model.dart';
import 'package:health_app/src/theme/extention.dart';

import '../model/dactor_model.dart';
import '../theme/light_color.dart';
import '../theme/text_styles.dart';
import '../theme/theme.dart';
import '../widgets/progress_widget.dart';
import '../widgets/rating_start.dart';

class DetailPage extends StatefulWidget {
  DetailPage({Key key, this.model}) : super(key: key);
  final News model;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  News model;
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
  void initState() {
    model = widget.model;
    super.initState();
  }

  List<Categories> cateList = [];
  @override
  Widget build(BuildContext context) {
    cateList = model.categories as List;
    TextStyle titleStyle = TextStyles.title.copyWith(fontSize: 25).bold;
    if (AppTheme.fullWidth(context) < 393) {
      titleStyle = TextStyles.title.copyWith(fontSize: 23).bold;
    }
    return Scaffold(
      backgroundColor: LightColor.extraLightBlue,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: <Widget>[
            Image.asset('assets/doctor.png'),
            DraggableScrollableSheet(
              maxChildSize: .8,
              initialChildSize: .6,
              minChildSize: .6,
              builder: (context, scrollController) {
                return Container(
                  height: AppTheme.fullHeight(context) * .5,
                  padding: const EdgeInsets.only(
                      left: 19,
                      right: 19,
                      top: 16), //symmetric(horizontal: 19, vertical: 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30)),
                    color: Colors.white,
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    controller: scrollController,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                model.title,
                                style: titleStyle,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Icon(Icons.check_circle,
                                  size: 18,
                                  color: Theme.of(context).primaryColor),
                              Spacer(),
                              // RatingStar(
                              //   rating: model.rating,
                              // )
                            ],
                          ),
                          subtitle: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                height: 20,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount:
                                      cateList.isNotEmpty && cateList != null
                                          ? cateList.length
                                          : null,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder:
                                      ((BuildContext context, int index) {
                                    if (cateList.isNotEmpty &&
                                        cateList != null) {
                                      return Row(
                                        children: [
                                          Text(
                                            cateList[index].name.toString(),
                                            style: TextStyles
                                                .bodySm.subTitleColor.bold,
                                          ),
                                          SizedBox(
                                            width: 5,
                                            child: Text(", "),
                                          ),
                                        ],
                                      );
                                    }
                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        const Divider(
                          thickness: .3,
                          color: LightColor.grey,
                        ),
                        Text("Thông tin", style: titleStyle).vP16,
                        Text(
                          model.content,
                          style: TextStyles.body.subTitleColor,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: LightColor.grey.withAlpha(150)),
                              child: const Icon(
                                Icons.call,
                                color: Colors.white,
                              ),
                            ).ripple(
                              () {},
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: LightColor.grey.withAlpha(150)),
                              child: const Icon(
                                Icons.chat_bubble,
                                color: Colors.white,
                              ),
                            ).ripple(
                              () {},
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FlatButton(
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              onPressed: () {},
                              child: Text(
                                "Make an appointment",
                                style: TextStyles.titleNormal.white,
                              ).p(10),
                            ),
                          ],
                        ).vP16
                      ],
                    ),
                  ),
                );
              },
            ),
            _appbar(),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:health_app/src/pages/medical_detail_page.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../config/api_url.dart';
import '../model/medical_model.dart';
import '../model/user_model.dart';
import '../providers/medical_provider.dart';
import '../providers/user_provider.dart';
import '../theme/const.dart';
import '../widgets/card_items.dart';
import '../widgets/custom_clipper.dart';

class MedicalAllPage extends StatefulWidget {
  const MedicalAllPage({Key key}) : super(key: key);

  @override
  State<MedicalAllPage> createState() => _MedicalAllPageState();
}

class _MedicalAllPageState extends State<MedicalAllPage> {
  List<Medical> listMedical = [];

  @override
  void initState() {
    // id = widget.id;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getMedicalList();
      });
    }
    super.initState();
  }

  getMedicalList() async {
    var fetchedMedical =
        await Provider.of<MedicalProvider>(context, listen: false)
            .getMedical(0, 5) as List<Medical>;
    setState(() {
      listMedical = fetchedMedical;
    });
    print("Medical list view : " + listMedical.toString());
  }

  DateTime stringToDate(String date) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
    return tempDate;
  }

  int dateBetween(DateTime from, DateTime to) {
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget _appbar() {
    return Container(
      child: Row(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;

    double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
        backgroundColor: Constants.backgroundColor,
        body: // BODY
            Stack(children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Theme.of(context).accentColor,
              height: Constants.headerHeight + statusBarHeight - 30,
            ),
          ),
          Positioned(
            right: -45,
            top: -30,
            child: ClipOval(
              child: Container(
                color: Colors.black.withOpacity(0.05),
                height: 220,
                width: 220,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const <Widget>[
                    BackButton(color: Colors.white),
                  ],
                ),
                // Header - Greetings and Avatar
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Lịch sử bệnh của,\n${user.full_name}",
                        style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            color: Colors.white),
                      ),
                    ),
                    CircleAvatar(
                        radius: 26.0,
                        backgroundImage: user.avatar_url == null
                            ? const AssetImage(
                                'assets/icons/profile_picture.png')
                            : NetworkImage(API_URL.getImage + user.avatar_url))
                  ],
                ),

                // Main Cards - Heartbeat and Blood Pressure

                // Info Medical
                SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "",
                      style: TextStyle(
                          color: Constants.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "THÊM",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Container(
                  child: listMedical == null && listMedical.length < 0
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView(
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: <Widget>[
                            ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: listMedical.length < 5
                                    ? listMedical.length
                                    : 5,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        "/MedicalDetailPage",
                                        arguments: listMedical[index],
                                      );
                                    },
                                    child: CardItems(
                                      image: Image.asset(
                                        'assets/icons/history_medical.png',
                                      ),
                                      title: listMedical[index].name,
                                      value: "Thời gian bị",
                                      unit: listMedical[index].created_at !=
                                                  null &&
                                              listMedical[index].updated_at !=
                                                  null
                                          ? dateBetween(
                                                      stringToDate(
                                                          listMedical[index]
                                                              .created_at),
                                                      stringToDate(
                                                          listMedical[index]
                                                              .updated_at))
                                                  .toString() +
                                              " ngày"
                                          : "",
                                      color: Constants.lightYellow,
                                      progress: 100,
                                    ),
                                  );
                                }),
                            // CardItems(
                            //   image: Image.asset(
                            //     'assets/icons/Walking.png',
                            //   ),
                            //   title: "Walking",
                            //   value: "750",
                            //   unit: "steps",
                            //   color: Constants.lightYellow,
                            //   progress: 30,
                            // ),
                            // CardItems(
                            //   image: Image.asset(
                            //     'assets/icons/Swimming.png',
                            //   ),
                            //   title: "Swimming",
                            //   value: "30",
                            //   unit: "mins",
                            //   color: Constants.lightBlue,
                            //   progress: 0,
                            // ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ]));
  }
}

import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:health_app/src/model/medical_model.dart';
import 'package:health_app/src/model/medical_today_model.dart';
import 'package:health_app/src/providers/medical_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_url.dart';
import '../model/user_model.dart';
import '../providers/user_provider.dart';
import '../theme/const.dart';
import '../widgets/card_items.dart';
import '../widgets/card_main.dart';
import '../widgets/card_section.dart';
import '../widgets/custom_clipper.dart';

class MedicalPage extends StatefulWidget {
  const MedicalPage({Key key}) : super(key: key);

  @override
  State<MedicalPage> createState() => _MedicalPageState();
}

class _MedicalPageState extends State<MedicalPage> {
  List<Medical> listMedical = [];
  List<MedicalToday> list;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // id = widget.id;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        getMedicalList();
      });
    }
    loadSharedPreferencesAndData();
    super.initState();
  }

  void loadSharedPreferencesAndData() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  void loadData() {
    List<String> listString =
        sharedPreferences.getStringList('listMedicalToday');
    if (listString != null) {
      list = listString
          .map((item) => MedicalToday.fromMap(json.decode(item)))
          .toList();
      setState(() {
        list = list;
      });
    }
  }

  void saveData() {
    List<String> stringList =
        list.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('listMedicalToday', stringList);
  }

  void editCheckItem(MedicalToday item, bool check) {
    item.completed = check;
    saveData();
    loadData();
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

  String getBMI(int height, int weight) {
    double bmi = weight / ((height / 100) * 2);
    String d1 = bmi.toStringAsPrecision(3);
    return d1;
  }

  String getInFoBMT(String bmi) {
    double a = double.parse(bmi);
    String result = "";
    if (a < 18.5) {
      result = "G???y";
    } else {
      if (a >= 18 && a <= 24.9) {
        result = "B??nh th?????ng";
      } else {
        if (a >= 25 && a <= 29.9) {
          result = "T??ng ca";
        } else {
          if (a >= 30 && a <= 34.9) {
            result = "B??o ph?? c???p ????? 1";
          } else {
            if (a >= 35 && a <= 39.9) {
              result = "B??o ph?? c???p ????? 2";
            } else {
              result = "B??o ph?? c???p ????? 3";
            }
          }
        }
      }
    }

    return result;
  }

  DateTime stringToDate(String date) {
    DateTime tempDate = new DateFormat("yyyy-MM-dd").parse(date);
    return tempDate;
  }

  int dateBetween(DateTime from, DateTime to) {
    return (to.difference(from).inHours / 24).round();
  }

  @override
  Widget build(BuildContext context) {
    User user;
    user = Provider.of<UserProvider>(context).user;

    double statusBarHeight = MediaQuery.of(context).padding.top;

    void _onRefresh() async {
      // monitor network fetch
      var fetchedMedical =
          await Provider.of<MedicalProvider>(context, listen: false)
              .getMedical(0, 5) as List<Medical>;
      setState(() {
        listMedical = fetchedMedical;
      });
      print("Medical_page: " + listMedical.toString());
    }

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: Stack(
        children: <Widget>[
          ClipPath(
            clipper: MyCustomClipper(clipType: ClipType.bottom),
            child: Container(
              color: Theme.of(context).accentColor,
              height: Constants.headerHeight + statusBarHeight,
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

          // BODY
          Padding(
            padding: EdgeInsets.all(Constants.paddingSide),
            child: ListView(
              children: <Widget>[
                // Header - Greetings and Avatar
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "Ch??? s??? s???c kh???e c???a,\n${user.full_name}",
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

                SizedBox(height: 50),

                // Main Cards - Heartbeat and Blood Pressure
                Container(
                  height: 140,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      CardMain(
                        image: AssetImage('assets/icons/heartbeat.png'),
                        title: "Ch??? s??? BMI",
                        value: getBMI(user.height, user.weight),
                        unit: getInFoBMT(getBMI(user.height, user.weight)),
                        color: Constants.lightGreen,
                      ),
                      CardMain(
                          image: AssetImage('assets/icons/blooddrop.png'),
                          title: "Chi???u cao & \nc??n n???ng",
                          value: "${user.height / 100}/${user.weight}",
                          unit: "Meter/Kg",
                          color: Constants.lightYellow)
                    ],
                  ),
                ),

                // Section Cards - Daily Medication
                SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "????N THU???C TRONG NG??Y",
                      style: TextStyle(
                        color: Constants.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/MedicalTodayPage");
                      },
                      child: Text(
                        "T???T C???",
                        style: TextStyle(
                            color: Constants.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Container(
                  height: 125,
                  width: MediaQuery.of(context).size.width,
                  child: list != null && list.length > 0
                      ? ListView(
                          children: <Widget>[
                            Container(
                              height: 125,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: list.length < 5 ? list.length : 5,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CardSection(
                                      image: const AssetImage(
                                          'assets/icons/capsule.png'),
                                      title: list[index].name,
                                      value: list[index].info,
                                      unit: "",
                                      time: list[index].time,
                                      isDone: list[index].completed ?? false,
                                      onPressed: () {
                                        editCheckItem(list[index],
                                            !list[index].completed);
                                      },
                                    );
                                  }),
                            ),

                            // CardSection(
                            //   image: AssetImage('assets/icons/syringe.png'),
                            //   title: "Trulicity",
                            //   value: "1",
                            //   unit: "shot",
                            //   time: "8-9AM",
                            //   isDone: true,
                            // )
                          ],
                        )
                      : GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, "/MedicalTodayAddPage");
                          },
                          child: Text(
                            "Hi???n t???i kh??ng c?? l???ch tr??nh. \nTh??m l???ch tr??nh thu???c!",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        ),
                ),

                // Info Medical
                SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "L???CH S??? B???NH",
                      style: TextStyle(
                          color: Constants.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, "/MedicalAllPage")
                            .then((value) {
                          if (value) {
                            _onRefresh();
                          }
                        });
                      },
                      child: Text(
                        "T???T C???",
                        style: TextStyle(
                            color: Constants.textPrimary,
                            fontSize: 13,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20),

                Container(
                  child: listMedical == null
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
                                itemCount: listMedical.length < 3
                                    ? listMedical.length
                                    : 3,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        "/MedicalDetailPage",
                                        arguments: listMedical[index],
                                      ).then((value) {
                                        if (value) {
                                          _onRefresh();
                                        }
                                      });
                                    },
                                    child: CardItems(
                                      image: Image.asset(
                                        'assets/icons/history_medical.png',
                                      ),
                                      title: listMedical[index].name,
                                      value: "Th???i gian b???",
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
                                              " ng??y"
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

                SizedBox(height: 20),

                // Scheduled Activities
                // Text(
                //   "L???CH TR??NH",
                //   style: TextStyle(
                //       color: Constants.textPrimary,
                //       fontSize: 13,
                //       fontWeight: FontWeight.bold),
                // ),

                // SizedBox(height: 20),

                // Container(
                //   child: ListView(
                //     scrollDirection: Axis.vertical,
                //     physics: NeverScrollableScrollPhysics(),
                //     shrinkWrap: true,
                //     children: <Widget>[
                //       CardItems(
                //         image: Image.asset(
                //           'assets/icons/Walking.png',
                //         ),
                //         title: "Walking",
                //         value: "750",
                //         unit: "steps",
                //         color: Constants.lightYellow,
                //         progress: 30,
                //       ),
                //       CardItems(
                //         image: Image.asset(
                //           'assets/icons/Swimming.png',
                //         ),
                //         title: "Swimming",
                //         value: "30",
                //         unit: "mins",
                //         color: Constants.lightBlue,
                //         progress: 0,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
